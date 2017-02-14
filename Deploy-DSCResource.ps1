$DSCResource = 'xjbsqlserver','xdynamics365'
$DSCResourcePath = 'f:\github'

# ----- Copy Dynamics module to DSC server for distribution
Copy-item 'F:\OneDrive - StratusLIVE, LLC\Scripts\Modules\Dynamics365' -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force
Copy-item 'F:\github\SQLExtras' -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force

# ----- Copy to the share location on DSC
Copy-item 'F:\OneDrive - StratusLIVE, LLC\Scripts\Modules\Dynamics365' -Destination '\\sl-dsc.stratuslivedemo.com\c$\PSModules' -Recurse -Force
Copy-item 'F:\github\SQLExtras' -Destination '\\sl-dsc.stratuslivedemo.com\c$\PSModules' -Recurse -Force


Foreach ( $D in $DSCResource ) 
{

    # ----- Grab the version from the module manifest
    $Version = ([string](Get-content -Path F:\GitHub\$D\$D.psd1 | select-string -Pattern 'moduleversion')).split('=')[1].replace("'","").TrimStart(' ')

    # ----- Copy to DSC Server
    Copy-item -Path $DSCResourcePath\$D -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force 

    # ----- Create zip and Checksum
    Compress-Archive -Path $DSCResourcePath\$D -DestinationPath f:\github\$($D)_$($Version).zip -force
    New-DscChecksum -Path f:\github\$($D)_$($Version).zip -OutPath f:\github

    # ----- Move to DSC Server 
    Move-Item -path f:\github\$($D)_$($Version).zip* -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\DscService\Modules' -Force
}

Get-date
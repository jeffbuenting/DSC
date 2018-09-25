$DSCResource = 'xdyn365'
$DSCResourcePath = 'F:\GitHub'

# ----- Copy Dynamics module to DSC server for distribution
#Copy-item 'F:\OneDrive - StratusLIVE, LLC\Scripts\Modules\xjbsqlserver' -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force
#Copy-item 'F:\github\SQLExtras' -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force

# ----- Copy to the share location on DSC
#Copy-item 'F:\OneDrive - StratusLIVE, LLC\Scripts\Modules\$DSCResource' -Destination '\\sl-dsc.stratuslivedemo.com\c$\PSModules' -Recurse -Force
#Copy-item 'F:\github\SQLExtras' -Destination '\\sl-dsc.stratuslivedemo.com\c$\PSModules' -Recurse -Force


Foreach ( $D in $DSCResource ) 
{

    Write-Output "$D"

    # ----- Grab the version from the module manifest
    $Version = ([string](Get-content -Path $DSCResourcePath\$D\$D.psd1 | select-string -Pattern 'moduleversion')).split('=')[1].replace("'","").TrimStart(' ')

    # ----- Removing from windows\modules because it seems not to be overwriting
    Remove-Item -Path "\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules\$D" -Recurse -force

    # ----- Copy to DSC Server
   # if ( -Not (Test-Path -Path '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules') ) { New-Item -ItemType Directory -Path '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules' }
    Copy-item -Path "$DSCResourcePath\$D" -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force

    # ----- Create zip and Checksum
    Compress-Archive -Path $DSCResourcePath\$D -DestinationPath f:\github\$($D)_$($Version).zip -force
    New-DscChecksum -Path f:\github\$($D)_$($Version).zip -OutPath f:\github

    # ----- Delete the existing Files as overwriting them does not seem to work
    Remove-Item -path "\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\DscService\Modules\$D*.*" -Recurse -Force

    # ----- Move to DSC Server 
    Move-Item -path f:\github\$($D)_$($Version).zip* -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\DscService\Modules' -Force
}



Get-date
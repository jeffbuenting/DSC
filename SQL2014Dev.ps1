# ----- http://colinsalmcorner.com/post/install-and-configure-sql-server-using-powershell-dsc

Configuration SQL2014Dev {

    Param (
        [Parameter( Mandatory = $True )]
        [ValidateScript( { (Get-item $_ | Select-Object -ExpandProperty Extension ) -eq '.iso' } ) ]
        [String]$WinISO,

        [Parameter( Mandatory = $True )]
        [ValidateScript( { (Get-item $_ | Select-Object -ExpandProperty Extension ) -eq '.iso' } ) ]
        [String]$SQLISO           
    )

    Node SQL2014Dev {

        # ----- SQL Prereqs
        $WinDriveLetter = (Mount-DiskImage -ImagePath $WinISO -PassThru | Get-Volume ).DriveLetter
        
        WindowsFeature Net35 {
            Name = "Net-Framework-Core"
            Ensure = "Present"
            Source = "$WinDriveLetter\Source\SXS"
        }

        # ----- Install SQL
        $SQLDriveLetter = (Mount-DiskImage -ImagePath $WinISO -PassThru | Get-Volume ).DriveLetter

    }
}

SQL2014dev -WinISO \\vaslnas\StratusLive\Software\en_windows_server_2012_r2_x64_dvd_2707946.iso -SQLISO \\vaslnas\StratusLive\Software\en_sql_server_2014_developer_edition_with_service_pack_1_x64_dvd_6668542.iso -OutputPath 'C:\DSC Configs\' -verbose 

New-DscChecksum -Path 'C:\DSC Configs\SQL2014dev.mof' -OutPath 'C:\DSC Configs' -Force
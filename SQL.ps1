# ----- http://colinsalmcorner.com/post/install-and-configure-sql-server-using-powershell-dsc

Configuration SQL {

    Param (
        [Parameter( Mandatory = $True )]
        [ValidateScript( { (Get-item $_ | Select-Object -ExpandProperty Extension ) -eq '.iso' } ) ]
        [String]$WinISO,

        [Parameter( Mandatory = $True )]
        [ValidateScript( { (Get-item $_ | Select-Object -ExpandProperty Extension ) -eq '.iso' } ) ]
        [String]$SQLISO           
    )

    Node SQL {

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

SQL -OutputPath 'C:\DSC Configs\' -verbose 

New-DscChecksum -Path 'C:\DSC Configs\SQL.mof' -OutPath 'C:\DSC Configs' -Force
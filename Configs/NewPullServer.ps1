Configuration GOGoDSCPullServer {

    Param (
        [String[]]$NodeName = 'localhost',

        [ValidateNotNullOrEmpty()]
        [String]$CertificateThumbPrint,

        [Parameter( Mandatory = $True )]
        [ValidateNotNullOrEmpty()]
        [String]$RegistrationKey
    )

    Import-DscResource -ModuleName xPSDesiredStateConfiguration

    Node $NodeName {
        
        WindowsFeature DSCServiceFeature {
            Ensure = 'Present'
            Name = 'DSC-Service'
        }

        XDSCWebService PSDSCPullServer {
            Ensure = 'Present'
            EndpointName = 'PSDSCPullServer'
            Port = 443
            PhysicalPath = "$Env:SystemDrive\inetpub\wwwroot\PSDSCPullServer"
            CertificateThumbPrint = $CertificateThumbPrint
            ModulePath = "$Env:ProgramFiles\WindowsPowerShell\DSCService\Modules"
            ConfigurationPath = "$Env:ProgramFiles\WindowsPowerShell\DSCService\Configuration"
            State = "Started"
            UseSecurityBestPractices = $True
            DependsOn = "[WindowsFeature]DSCServiceFeature"
        }

        File RegistrationKeyFile {
            Ensure = 'Present'
            Type = 'File'
            DestinationPath = "$Env:ProgramFiles\WindowsPowershell\DSCService\RegistrationKeys.txt"
            Contents = $RegistrationKey
        }
    }
}

GoGoDSCPullServer -NodeName SL-DSC -CertificateThumbPrint 63B900EBA08923FCB344E12F64919A2DB1FDDFF1 -Registrationkey f9bb4992-016b-4fb5-a81d-91f7eb803b2a -OutputPath c:\DSCConfigs\

[DSCLocalConfigurationManager()]
Configuration LCMConfig {
    
    Param(
        [String]$ComputerName
    )


    Node $ComputerName {

        Settings {
            RefreshMode = 'Pull'
        }           

        ConfigurationRepositoryWeb SL-DSC {
            AllowUnsecureConnection = $False
            ConfigurationNames = @('CRMEnvironment')
            RegistrationKey = 'f9bb4992-016b-4fb5-a81d-91f7eb803b2a'
            ServerUrl = 'https://sl-dsc.stratuslivedemo.com/PSDSCPullServer.svc'
        }

    }

}

LCMConfig -computerName jb-crm01 -Outputpath c:\dscconfigs
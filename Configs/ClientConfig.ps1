[DSCLocalConfigurationManager()]
configuration PullClientConfigNames
{
    Node localhost
    {
        Settings
        {
            RefreshMode = 'Pull'
            RefreshFrequencyMins = 30 
            RebootNodeIfNeeded = $true
            ConfigurationMode = 'ApplyAndAutoCorrect'
        }
        
        ConfigurationRepositoryWeb DSCServer
        {
            ServerURL = 'https://sl-dsc:4433/PSDSCPullServer.svc'
            RegistrationKey = 'ad87424e-691f-4a1b-acb7-3091408bb9d2'
            ConfigurationNames = @('BaseServer')
        } 
        
        ReportServerWeb ReportSrv
        {
            ServerURL = 'https://sl-dsc:4433/PSDSCPullServer.svc'
        }
     
    }
}

PullClientConfigNames -OutputPath c:\DSCConfig
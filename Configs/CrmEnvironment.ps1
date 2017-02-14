Configuration CRMEnvironment {
    Node $AllNodes.Where( {$_.Role -eq 'CRM'} ).NodeName {
        
        WindowsFeature IIS {
            Ensure = 'Present'
            Name = 'Web-Server'
        }
    }
}


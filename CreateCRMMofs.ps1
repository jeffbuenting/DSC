CRMEnvironment -ConfigurationData C:\dscscripts\Jeffb01ConfigData.psd1 -outputpath C:\DSCConfigs

New-DscChecksum -Path C:\DSCConfigs\JB-CRM01.mof -OutPath C:\DSCConfigs

copy-item -path C:\DSCConfigs\jb-crm01* -Destination 'C:\Program Files\WindowsPowerShell\DscService\Configuration'

Configuration CRM






# ----- To utilize encrypted passwords in a MOF file you need a CA setup.  Since we don't have that I am setting the Allow Plain text password to True.  This really should be changed
# ----- https://blogs.technet.microsoft.com/ashleymcglone/2015/12/18/using-credentials-with-psdscallowplaintextpassword-and-psdscallowdomainuser-in-powershell-dsc-configuration-data/
# ----- https://msdn.microsoft.com/en-us/powershell/dsc/securemof
# ----- https://blogs.msdn.microsoft.com/powershell/2015/10/01/powershell-dsc-faq-sorting-out-certificates/
$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = '*';
            PSDscAllowPlainTextpassword = $True;
        }
    )
}


$secpasswd = ConvertTo-SecureString '1$tellar$ervice' -AsPlainText -Force
$CRMAdmin = New-Object System.Management.Automation.PSCredential (“stratuslivedemo\administrator”, $secpasswd)
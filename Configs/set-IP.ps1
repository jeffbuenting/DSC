

Configuration BaseServer {

    param (
        
        [Parameter ( ParameterSetName = 'IP' )]
        [String]$IP,

        [Parameter ( ParameterSetName = 'IP' )]
        [Int]$SubnetMask,

        [Parameter ( ParameterSetName = 'IP' )]
        [String]$InterfaceAlias,

        [Parameter ( ParameterSetName = 'IP' )]
        [String]$DefaultGateway,

        [Parameter ( ParameterSetName = 'IP' )]
        [ValidateSet ('IPV4','IPV6' )]
        [String]$IPAddressFamily = 'IPV4'
    )

    Import-dscresource -ModuleName xNetworking

    Node LocalHost {
   
        # ---- IP Address
        if ( $PSCmdlet.ParameterSetName -eq 'IP' ) {
                Write-Verbose "Setting Static IP"
                # ----- xNetworking : https://github.com/PowerShell/xNetworking
                 xIPAddress IP {
                    IPAddress = $IP
                    SubnetMask = $SubnetMask
                    InterfaceAlias = $InterfaceAlias
                }

                xDefaultGatewayAddress Gateway {
                    Address = $DefaultGateway
                    InterfaceAlias = $InterfaceAlias
                    AddressFamily = $IPAddressFamily
                }
            }
            Else {
                Write-Verbose "Setting IP to DHCP"

        }
    }
}


#$ConfigData = @{
#   AllNodes = @(
#       @{
#           NodeName = 'LocalHost';
#        }
#    )
#}



baseserver -IP '192.168.1.230' -Subnetmask 24 -defaultgateway '192.168.1.1' -OutputPath 'C:\DSC Configs' #-ConfigurationData $ConfigData

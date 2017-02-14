Function Get-DSCVerboseLog {

<#
    .Synopsis
        Retrieves a DSC Configuration Log file.

    .Description
        When running DSC COnfigurations interactively, you can output the Verbose log to the screen so you can see what is happening.  However, if a reboot is needed then when the configuration picks up after the reboot, Verbose output to the screen does not happen.  

        The Verbose info is actually saved in a JSON file in the c:\windows\system32\Configuration\ConfigurationStatus folder.

        This cmdlet retrieves the specified log.

    .Link
        http://nanalakshmanan.com/blog/Historical-Job-Logs/
#>

    [CmdletBinding()]
    Param (
        [String[]]$ComputerName = $env:COMPUTERNAME,

        [String]$JobID
    )

    Process {
        Foreach ( $C in $ComputerName ) {
            Write-Verbose "Getting logs from $C"

            if ( -Not $JobID ) {
                Write-verbose "NO Job ID Included.  Select from the following JobIDs:"
                Try {
                    $CimSession = New-CimSession -ComputerName $C -ErrorAction Stop
                    $JobID = get-dscconfigurationstatus -CimSession $CimSession  -all -ErrorAction Stop | Select-Object Status, startdate,type,jobid | Out-GridView -Title "Select the DSC Configuration" -OutputMode Single -ErrorAction Stop| Select-Object -ExpandProperty JobID
                }
                Catch {
                    $EXceptionMessage = $_.Exception.Message
                    $ExceptionType = $_.exception.GetType().fullname
                    Throw "Get-DSCVerboseLog : Error getting a Job ID.`n`n     $ExceptionMessage`n`n     Exception : $ExceptionType" 
                }
            }
            
            #Get-Item -Path "\\$C\c$\Windows\system32\configuration\configurationStatus\$JobID*" | Foreach {
                Write-Verbose "Returning $($_.Fullname) Log"

                $Content = Get-Content -Raw -Encoding Unicode -Path \\$C\c$\Windows\system32\configuration\configurationStatus\$JobID-0.details.json
               # $Content | measure-object
             
                $Log = ConvertFrom-Json $Content

                Write-Output $Log
            #}
        }
    }

}

#{16FBE203-F22A-11E6-80BA-00155D000A30}-0.details.json

#Get-DSCVerboseLog -ComputerName jb-sql01.stratuslivedemo.com -Verbose 
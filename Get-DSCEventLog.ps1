function Get-DSCEventLog {

<#
    .Synopsis
        Returns DSC event log entries

    .Description
        Returns DSC Event log Entries.  Can be filtered on Job so you can get only the specific job alerts.  Also can be filtered on EventLog.

        The DSC logs are split into three channels.  
            Operational                 Contains all error messages.
            Analytics                   Contains Verbose Messages if any.  
                                        Also can be used to identify where errors occurred.
            Debug                       Developer information 

    .Parameter ComputerName
        Name of the computer from which to retrieve the DSC logs

    .Parameter Log
        Name of the DSC EventLog

    .Parameter JobID
        Uniquely represents a DSC operation.  Each log entry begins with a job id.

    .Example
        Get-DSCEventLog -ComputerName 'ServerA'

        Returns all Events from all three logs on ServerA.

    .Example
        Get-DSCEventLog -ComputerName 'ServerA' -Log 'Microsoft-Windows-DSC/Analytic'

        Returns only the Analytics log from ServerA.

    .Example
        Get-DSCEventLog -ComputerName 'ServerA' -Log 'Microsoft-Windows-DSC/Analytic' -JobID '{031B1F38-F3AC-11E6-80BD-00155D000A30}'

        Returns only the Job {031B1F38-F3AC-11E6-80BD-00155D000A30} from the analytics Log.

    .Link
        https://blogs.msdn.microsoft.com/powershell/2014/01/03/using-event-logs-to-diagnose-errors-in-desired-state-configuration/

    .Link
        https://msdn.microsoft.com/en-us/powershell/dsc/troubleshooting

    .Link
        https://msdn.microsoft.com/en-us/library/bb525433(v=vs.85).aspx

    .Notes
        Author : Jeff Buenting
#>

    [CmdletBinding()]
    Param (
        [String]$ComputerName = $env:COMPUTERNAME,

        [ValidateSet ( 'Microsoft-windows-dsc/operational','Microsoft-Windows-DSC/Analytic','Microsoft-windows-dsc/Debug' )]
        [String[]]$Log = @('Microsoft-windows-dsc/operational','Microsoft-Windows-DSC/Analytic','Microsoft-windows-dsc/Debug'),

        [String]$JobID
    )

    Write-Verbose "Retrieving logs from $ComputerName"

    Foreach ( $L in $Log ) {
        Write-Verbose "Returning $L log"
        
        Try {
            if ( $JobID ) {
                Write-Output (Get-WinEvent -ComputerName $ComputerName -LogName $L -oldest -ErrorAction Stop | where message -Like "Job $JobID*" )
            }
            Else {
                 Write-Output (Get-WinEvent -ComputerName $ComputerName -LogName $L -oldest -ErrorAction Stop )
            }
        }
        Catch {
            $EXceptionMessage = $_.Exception.Message
            $ExceptionType = $_.exception.GetType().fullname
            Throw "Get-DSCEventLog : Error getting events in log $L.`n`n     $ExceptionMessage`n`n     Exception : $ExceptionType" 
        }
    }
}



$E = Get-DSCEventLog -ComputerName 'jb-sql01.stratuslivedemo.com' -Log 'Microsoft-Windows-DSC/Analytic' -JobID '{031B1F38-F3AC-11E6-80BD-00155D000A30} '   -verbose

$E.message

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"



$TestCases = @(
    @{
        TestName = 'One Server, all logs'
        ComputerName = 'jb-sql01.stratuslivedemo.com'
    }

    @{
        TestName = 'One Server, analytics log'
        ComputerName = 'jb-sql01.stratuslivedemo.com'
        Log = 'Microsoft-Windows-DSC/Analytic'
    }

    @{
        TestName = 'One Server, Operational log'
        ComputerName = 'jb-sql01.stratuslivedemo.com'
        Log = 'Microsoft-Windows-DSC/Operational'
    }

    @{
        TestName = 'One Server, Debug log'
        ComputerName = 'jb-sql01.stratuslivedemo.com'
        Log = 'Microsoft-Windows-DSC/Debug'
    }

    @{
        TestName = 'One Server, analytics log, One JobID'
        ComputerName = 'jb-sql01.stratuslivedemo.com'
        Log = 'Microsoft-Windows-DSC/Analytic'
        JobID = '{031B1F38-F3AC-11E6-80BD-00155D000A30}'
    }

    @{
        TestName = 'No Server Name passed'  
    }
)


Describe "Get-DSCEventLog" {

    # ----- Get Function Help
    # ----- Pester to test Comment based help
    # ----- http://www.lazywinadmin.com/2016/05/using-pester-to-test-your-comment-based.html
    Context "Help" {

        $H = Help Get-DSCEventLog -Full

        # ----- Help Tests
        It "has Synopsis Help Section" {
            $H.Synopsis | Should Not BeNullorEmpty
        }

        It "has Description Help Section" {
            $H.Description | Should Not BeNullorEmpty
        }

        It "has Parameters Help Section" {
            $H.Parameters | Should Not BeNullorEmpty
        }

        # Examples
        it "Example - Count should be greater than 0"{
            $H.examples.example.code.count | Should BeGreaterthan 0
        }
            
        # Examples - Remarks (small description that comes with the example)
        foreach ($Example in $H.examples.example)
        {
            it "Example - Remarks on $($Example.Title)"{
                $Example.remarks | Should not BeNullOrEmpty
            }
        }


        It "has Notes Help Section" {
            $H.alertSet | Should Not BeNullorEmpty
        }
    }

    # ----- Expected Results
    Context "Results" {
        It "Should be an EventLogRecord. Test: <TestName>" -TestCases $TestCases {
            Param (
                [String]$ComputerName,

                [String]$Log,

                [String]$JobID
            )

            if ( $Log ) {
                $E = Get-DSCEventLog -ComputerName $ComputerName -Log $Log -JobID $JobID
            }
            Else {
                $E = Get-DSCEventLog -ComputerName $ComputerName -JobID $JobID
            }

            $E | Should beofType 'System.Diagnostics.Eventing.Reader.EventLogRecord'
        }
    }
}

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

$TestCases = @(
    

    @{
        TestName = 'JobID Included'
        ComputerName = 'jb-sql01.stratuslivedemo.com'
        JobID = '{16FBE203-F22A-11E6-80BA-00155D000A30}'
    }
    
    @{
        TestName = 'No JobID Included'
        ComputerName = 'jb-sql01.stratuslivedemo.com'
    }
)


Describe "Get-DSCVerboseLog" {
 
    It "Returns a Custom Object. Test: <TestName>" -TestCases $TestCases  {
        param ( 
            $ComputerName,
            $JobID
        )

        $Log = Get-DSCVerboseLog -ComputerName $ComputerName -JobID $JobID
    
        $Log | Should BeOfType PSCustomObject
    }

    
}

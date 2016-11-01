# ----- https://msdn.microsoft.com/en-us/powershell/dsc/reportserver

function Get-DSCReport
{
    param(
        $AgentId = "$((glcm).AgentId)", 
        $serviceURL 
    )

    $requestUri = "$serviceURL/Nodes(AgentId= '$AgentId')/Reports"
    $request = Invoke-WebRequest -Uri $requestUri  -ContentType "application/json;odata=minimalmetadata;streaming=true;charset=utf-8" `
               -UseBasicParsing -Headers @{Accept = "application/json";ProtocolVersion = "2.0"} `
               -ErrorAction SilentlyContinue -ErrorVariable ev
    $object = ConvertFrom-Json $request.content
    Write-Output $object.value
}


Get-DSCReport -AgentId 4D95E80B-A067-11E6-80B6-00155D000A30 -serviceURL 'https://sl-dsc:4433/PSDSCPullServer.svc'
param(
    [Parameter(Mandatory)]
    [string]$RDPHost,
    [string]$RDPSettings = "w=1920,h=1080"
)

function Convert-RdpStringToHashTable {
    $pairs = $RDPSettings -split ','
    $hash = @{}
    foreach ($pair in $pairs) {
        $parts = $pair -split '='
        if ($parts.Count -eq 2) {
            $key = $parts[0].Trim()
            $value = $parts[1].Trim()
            $hash[$key] = $value
        }
    }
    return $hash
}


function Format-MstscArgs {
    $sessionArgs = ""
    $rdpSettingsHash = Convert-RdpStringToHashTable
    foreach ($k in $rdpSettingsHash.Keys) {
        $sessionArgs += " /$($k):$($rdpSettingsHash[$k])"
    }
    return $sessionArgs
}

Write-Host "Start RDP signal received"

$psexecPath = "PsExec.exe"
$mstscArgs = Format-MstscArgs

Write-Host "Starting MSTSC with arguments: $mstscArgs"

$psexecArgs = "-i 0 -h -d mstsc.exe /v:$RDPHost $mstscArgs"
Write-Host $psexecArgs
Start-Process -FilePath $psexecPath -ArgumentList $psexecArgs -WindowStyle Hidden
Write-Host "RDP Session Started"

Start-Sleep -Seconds 10
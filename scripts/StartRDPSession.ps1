param(
    [string]$SessionHost,
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
    $sessionArgs = "/v:$SessionHost"
    $rdpSettingsHash = Convert-RdpStringToHashTable
    foreach ($k in $rdpSettingsHash.Keys) {
        $sessionArgs += " /$($k):$($rdpSettingsHash[$k])"
    }
    return $args
}

$psexecPath = "PsExec.exe"
$mstscArgs = Format-MstscArgs

Write-Host "Starting MSTSC with arguments: $mstscArgs"

$psexecArgs = "-i 2 -d mstsc.exe $mstscArgs"

Start-Process -FilePath $psexecPath -ArgumentList $psexecArgs -WindowStyle Hidden

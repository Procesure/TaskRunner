param(
    [string]$SessionHost,
    [string]$RDPSettings = "w=1920,h=1080"
)

# Convert the RDPSettings string (e.g. "w=1920,h=1080") into a hashtable.
function Convert-RdpStringToHashTable {
    # Here, $RDPSettings is in the global/script scope.
    $pairs = $RDPSettings -split ','
    $hash = @{}
    foreach ($pair in $pairs) {
        # Each pair is expected to be "key=value"
        $parts = $pair -split '='
        if ($parts.Count -eq 2) {
            $key = $parts[0].Trim()
            $value = $parts[1].Trim()
            $hash[$key] = $value
        }
    }
    return $hash
}

# Build the arguments string for mstsc.exe based on the session host and settings.
function Build-MstscArgs {
    # Use the global variable $SessionHost directly.
    $args = "/v:$SessionHost"
    # Call the conversion function to get the settings hash table.
    $rdpSettingsHash = Convert-RdpStringToHashTable
    foreach ($k in $rdpSettingsHash.Keys) {
        # Append each key/value pair as /key:value. We use $rdpSettingsHash[$k] for the value.
        $args += " /$($k):$($rdpSettingsHash[$k])"
    }
    return $args
}

# Main execution
$psexecPath = "C:\Program Files\Procesure\PsExec.exe"
$mstscArgs = Build-MstscArgs

Write-Host "Starting MSTSC with arguments: $mstscArgs"

$psexecArgs = "-i 2 -d mstsc.exe $mstscArgs"

Start-Process -FilePath $psexecPath -ArgumentList $psexecArgs -WindowStyle Hidden

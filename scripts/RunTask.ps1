param(
    [Parameter(Mandatory)]
    [string]$ExecutableCMD,
    [string]$SessionHost,
    [switch]$Interactive,
    [string]$CMDWorkingDir = $null,
    [string]$InteractiveSessionSettings = $null
)

Write-Host "=== Starting RDP script..."

if ($Interactive -And $SessionHost) {
    if ($InteractiveSessionSettings) {
        if ($InteractiveSessionSettings) {
            & powershell.exe -ExecutionPolicy Bypass -File ".\StartRDPSession.ps1" -RDPHost $SessionHost -RDPSettings $InteractiveSessionSettings
        } else {
            & powershell.exe -ExecutionPolicy Bypass -File ".\StartRDPSession.ps1" -RDPHost $SessionHost
        }
    } else {
        & powershell.exe -ExecutionPolicy Bypass -File ".\StartRDPSession.ps1" -RDPHost $SessionHost
    }
}

Write-Host "First script finished. Continuing..."
Write-Host "=== Running second script with -ExecutableCMD $ExecutableCMD ..."

$executeArgs = @("-ExecutableCMD", "`"$ExecutableCMD`"")

if ($CMDWorkingDir -ne $null) {
    $executeArgs += @("-CMDWorkingDir", "`"$CMDWorkingDir`"")
}

if ($Interactive) {
    $executeArgs += "-Interactive"
}

if ($SessionHost) {
    $executeArgs += @("-SessionHost", "`"$SessionHost`"")
}

Write-Host "Executing command: powershell.exe -ExecutionPolicy Bypass -File .\ExecuteInSession.ps1 $executeArgs"
& powershell.exe -ExecutionPolicy Bypass -File ".\ExecuteInSession.ps1" @executeArgs

if ($Interactive -And $SessionHost) {
    & powershell.exe -ExecutionPolicy Bypass -File ".\DisconnectRDPSession.ps1" -RDPHost $SessionHost
}

Write-Host "All tasks done, exiting."

exit 0

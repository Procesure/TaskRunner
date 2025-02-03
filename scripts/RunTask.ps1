param(
    [Parameter(Mandatory)]
    [string]$ExecutableCommand,
    [string]$SessionHost,
    [switch]$Interactive,
    [string]$InteractiveSessionSettings
)

Write-Host "=== Starting RDP script..."

if ($Interactive -And $SessionHost) {
    if ($InteractiveSessionSettings) {
        & powershell.exe -ExecutionPolicy Bypass -File ".\StartRDPSession.ps1" -RDPHost $SessionHost -RDPSettings $InteractiveSessionSettings
    } else {
        & powershell.exe -ExecutionPolicy Bypass -File ".\StartRDPSession.ps1" -RDPHost $SessionHost
    }
    
}

Write-Host "First script finished. Continuing..."

Write-Host "=== Running second script with -ExecutableCommand $ExecutableCommand..."

if (-Not $Interactive) {
    & powershell.exe -ExecutionPolicy Bypass -File ".\ExecuteInSession.ps1" -ExecutableCommand $ExecutableCommand
}
elseif ($Interactive -And $SessionHost) {
    & powershell.exe -ExecutionPolicy Bypass -File ".\ExecuteInSession.ps1" -ExecutableCommand $ExecutableCommand -Interactive -SessionHost $SessionHost
}
else {
    & powershell.exe -ExecutionPolicy Bypass -File ".\ExecuteInSession.ps1" -ExecutableCommand $ExecutableCommand -Interactive
}

if ($Interactive -And $SessionHost) {
    & powershell.exe -ExecutionPolicy Bypass -File ".\DisconnectRDPSession.ps1" -RDPHost $SessionHost
}

Write-Host "All tasks done, exiting."

exit 0


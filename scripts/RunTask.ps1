param(
    [string]$ExecutableCommand,
    [boolean]$Interactive,
    [string]$RDPSessionHost,
    [string]$RDPSessionSettings
)

Write-Host "=== Starting RDP script..."

if ($Interactive -And $SessionHost) {
    & "C:\Program Files\Procesure\StartRDPSession.ps1" -SessionHost $SessionHost -RDPSettings $RDPSessionSettings
}

Write-Host "First script finished. Continuing..."

Write-Host "=== Running second script with -ExecutableCommand $ExecutableCommand..."

if (not $Interactive) {
    & "C:\Program Files\Procesure\ExecuteInSession.ps1" -ExecutableCommand $ExecutableCommand -Interactive False
}
elseif ($Interactive -And $SessionHost) {
    & "C:\Program Files\Procesure\ExecuteInSession.ps1" -ExecutableCommand $ExecutableCommand -Interactive True -SessionHost $SessionHost
}
else {
    & "C:\Program Files\Procesure\ExecuteInSession.ps1" -ExecutableCommand $ExecutableCommand -Interactive True
}

if ($Interactive -And $SessionHost) {
    & "C:\Program Files\Procesure\DisconnectRDPSession.ps1" -SessionHost $SessionHost
}


Write-Host "All tasks done, exiting."
exit 0

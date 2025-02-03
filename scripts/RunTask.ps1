param(
    [Parameter(Mandatory)]
    [string]$ExecutableCommand,
    [string]$SessionHost,
    [boolean]$Interactive = $false,
    [string]$InteractiveSessionSettings
)

Write-Host "=== Starting RDP script..."

if ($Interactive -And $SessionHost) {
    & ".\StartRDPSession.ps1" -RDPHost $SessionHost -RDPSettings $InteractiveSessionSettings
}

Write-Host "First script finished. Continuing..."

Write-Host "=== Running second script with -ExecutableCommand $ExecutableCommand..."

if (-Not $Interactive) {
    & ".\ExecuteInSession.ps1" -ExecutableCommand $ExecutableCommand -Interactive $false
}
elseif ($Interactive -And $SessionHost) {
    & ".\ExecuteInSession.ps1" -ExecutableCommand $ExecutableCommand -Interactive $true -SessionHost $SessionHost
}
else {
    & ".\ExecuteInSession.ps1" -ExecutableCommand $ExecutableCommand -Interactive $true
}

if ($Interactive -And $SessionHost) {
    & ".\DisconnectRDPSession.ps1" -RDPHost $SessionHost
}


Write-Host "All tasks done, exiting."
exit 0

param(
    [Parameter(Mandatory)]
    [string]$ExecutableCMD,
    [string]$CMDWorkingDir = $null,
    [string]$SessionHost,
    [switch]$Interactive
)

function Get-MstscSessionId {

    param()

    $mstscProcesses = Get-CimInstance -ClassName Win32_Process -Filter "Name='mstsc.exe'"
    foreach ($proc in $mstscProcesses) {
        if ($proc.CommandLine -and $proc.CommandLine -match "/v:$SessionHost") {
            Write-Host "Found MSTSC process for host $SessionHost with SessionId: $($proc.SessionId)"
            return [int]$proc.SessionId
        }
    }

    return $null

}


function Get-MostRecentActiveSessionID {

    $username = [Environment]::UserName
    $queryOutput = query session $username
    $activeSessionLines = @($queryOutput | Where-Object { $_ -match "\b$username\b" -and $_ -match "Active" })

    Write-Host "Number of active sessions: $($activeSessionLines.Length)"

    if ($activeSessionLines) {

        $activeSessionLine = $activeSessionLines[-1]
        $parts = $activeSessionLine -replace '^\s+', '' -split '\s+'

        Write-Host "Parts from the last active session line: $parts"

        if ($parts.Length -gt 3) {
            $usernameIndex = $parts.IndexOf($username)
            if ($usernameIndex -gt -1 -and $usernameIndex + 1 -lt $parts.Length) {
                $sessionID = $parts[$usernameIndex + 1]
                Write-Host "Extracted session ID: $sessionID"
                return $sessionID
            }
        }

        Write-Host "Parts: $parts"
        Write-Host "Active session line: $activeSessionLine"
    } else {
        Write-Host "No active session found for the user $username."
    }

}

$targetSessionId = $null

if (-Not $Interactive) {
    $targetSessionId = 0
} elseif ($SessionHost) {
    Write-Host "SessionHost provided: $SessionHost; searching for MSTSC session..."
    $targetSessionId = Get-MostRecentActiveSessionId # FIX LATER SHOULD IMPLEMENT LOGIC TO GET VALUE FROM SESSION HOST
    if ($null -eq $targetSessionId) {
        Write-Host "No MSTSC session found for host $SessionHost. Trying an active session."
        $targetSessionId = Get-MostRecentActiveSessionId
        if ($null -eq $targetSessionId) {
            $targetSessionId = 0
        }
    }
} else {
    Write-Host "No SessionHost provided; attempting to get the most recent active session."
    $targetSessionId = Get-MostRecentActiveSessionId
    if ($null -eq $targetSessionId) {
        Write-Host "No active session found. Defaulting to session 0."
        $targetSessionId = 0
    }
}

Write-Host "Using session ID: $targetSessionId"

$psexecPath = "PsExec.exe"

if ($CMDWorkingDir) {
    $arguments = "-s -i $targetSessionId -w $CMDWorkingDir cmd.exe /c `"$ExecutableCMD`""
} else {
    $arguments = "-s -i $targetSessionId cmd.exe /c `"$ExecutableCMD`""
}

Write-Host "Executing command with PsExec: $psexecPath $arguments"

Start-Process -FilePath $psexecPath -ArgumentList $arguments -NoNewWindow -Wait

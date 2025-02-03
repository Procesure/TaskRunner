param (
    [Parameter(Mandatory)]
    [string]$RDPHost
)

function Get-ProcessIDByIP {
    param (
        [string]$IP
    )

    $connections = Get-NetTCPConnection -State Established
    $filteredConnections = $connections | Where-Object { $_.RemoteAddress -eq $RDPHost }

    $targetRDPClientPIDs = $filteredConnections | ForEach-Object {
        $_.OwningProcess
    }

    $targetRDPClientPID = $targetRDPClientPIDs | Select-Object -Unique | Select-Object -First 1

    if ($targetRDPClientPID -and $targetRDPClientPID -is [int]) {
        return $targetRDPClientPID
    } elseif ($targetRDPClientPID -and $targetRDPClientPID -isnot [int]) {
        try {
            return [int]$targetRDPClientPID
        } catch {
            Write-Output "Failed to convert PID to integer: $targetRDPClientPID"
            return $null
        }
    } else {
        return $null
    }
}


function Stop-ProcessByPID {
    param (
        [int]$ProcessID
    )
    Write-Output "Attempting to stop process ID: $ProcessID"
    try {
        $process = Get-Process -Id $ProcessID
        $process | Stop-Process -Force
        Write-Output "Process $ProcessID has been terminated."
    } catch {
        Write-Output "Failed to terminate process $ProcessID. Error: $_"
    }
}

if ($RDPHost) {
    $targetRDPClientPID = Get-ProcessIDByIP
    if ($targetRDPClientPID) {
        Write-Output "Found PID $targetRDPClientPID for IP $RDPHost"
        Stop-ProcessByPID -ProcessID $targetRDPClientPID
    } else {
        Write-Output "No connection found for IP $RDPHost"
    }
} else {
    Write-Output "No Target IP provided."
}

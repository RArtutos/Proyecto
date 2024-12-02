# ProcessManager.ps1
class ProcessManager {
    [string] $RemoteServer
    
    ProcessManager([string]$server) {
        $this.RemoteServer = $server
    }
    
    [array] GetLocalProcesses() {
        return Get-Process | Select-Object Id, ProcessName, CPU, WorkingSet
    }
    
    [array] GetRemoteProcesses() {
        $response = Invoke-RestMethod -Uri "$($this.RemoteServer)/api/processes" -Method GET
        return $response.processes
    }
    
    [bool] StopRemoteProcess([int]$processId) {
        try {
            $body = @{
                processId = $processId
            } | ConvertTo-Json
            
            $response = Invoke-RestMethod -Uri "$($this.RemoteServer)/api/processes/stop" `
                                        -Method POST `
                                        -Body $body `
                                        -ContentType "application/json"
            return $true
        }
        catch {
            Write-Error "Failed to stop remote process: $_"
            return $false
        }
    }
}

Export-ModuleMember -Function * -Variable *
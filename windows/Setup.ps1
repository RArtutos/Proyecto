# Setup.ps1
param(
    [string]$SqlServer = "localhost",
    [string]$Database = "SecureFiles",
    [string]$KeyStorePath = "C:\ProgramData\SecureFileSystem\keys",
    [string]$LogPath = "C:\ProgramData\SecureFileSystem\logs"
)

# Import required modules
Import-Module SqlServer

# Create necessary directories
$directories = @(
    $KeyStorePath,
    $LogPath,
    "C:\ProgramData\SecureFileSystem\files"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force
    }
}

# Initialize database
$dbManager = [DatabaseManager]::new($SqlServer, $Database)
$dbManager.InitializeDatabase()

# Create scheduled task for synchronization
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File $PSScriptRoot\src\sync\SyncUsers.ps1"
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "SyncUsers" -Description "Synchronize users between Windows and Linux servers"

# Start HTTP server
Start-Process powershell -ArgumentList "-File $PSScriptRoot\src\http\Server.ps1"

Write-Host "Setup completed successfully!"
# Main entry point for Windows application
param(
    [string]$ConfigPath = ".\config.json"
)

# Import required modules
. "$PSScriptRoot\src\Config\ConfigManager.ps1"
. "$PSScriptRoot\src\Database\DatabaseManager.ps1"
. "$PSScriptRoot\src\GUI\MainWindow.ps1"

# Initialize configuration
$config = [ConfigManager]::new($ConfigPath)

# Initialize database
$dbManager = [DatabaseManager]::new($config.SqlServer, $config.Database)
$dbManager.InitializeDatabase()

# Start HTTP server in background
Start-Process powershell -ArgumentList "-File $PSScriptRoot\src\Http\Server.ps1" -WindowStyle Hidden

# Start main GUI application
Start-MainWindow -Config $config
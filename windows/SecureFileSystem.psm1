# SecureFileSystem.psm1
# Main module file that imports all components

# Import all classes and functions
. "$PSScriptRoot\src\Config\ConfigManager.ps1"
. "$PSScriptRoot\src\Database\DatabaseManager.ps1"
. "$PSScriptRoot\src\ProcessManagement\ProcessManager.ps1"
. "$PSScriptRoot\src\GUI\MainWindow.ps1"
. "$PSScriptRoot\src\GUI\UserWindow.ps1"
. "$PSScriptRoot\src\GUI\ProcessWindow.ps1"

# Export functions that should be available to users of the module
Export-ModuleMember -Function Start-MainWindow, Show-CreateUserWindow, Show-ProcessWindow
# ConfigManager.ps1
class ConfigManager {
    [string] $SqlServer
    [string] $Database
    [int] $HttpPort
    [string] $KeyStorePath
    [string] $FilePath
    [string] $LogPath

    ConfigManager([string]$configPath) {
        $config = Get-Content $configPath | ConvertFrom-Json
        $this.SqlServer = $config.sqlServer
        $this.Database = $config.database
        $this.HttpPort = $config.httpPort
        $this.KeyStorePath = $config.keyStorePath
        $this.FilePath = $config.filePath
        $this.LogPath = $config.logPath
    }
}
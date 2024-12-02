# Windows Setup Script
param(
    [string]$ConfigPath = ".\config.json"
)

# Import configuration
$config = Get-Content $ConfigPath | ConvertFrom-Json

# Create necessary directories
$directories = @(
    $config.keyStorePath,
    $config.filePath,
    $config.logPath
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force
        Write-Host "Created directory: $dir"
    }
}

# Install SQL Server if not present
if (-not (Get-Service -Name "MSSQLSERVER" -ErrorAction SilentlyContinue)) {
    Write-Host "Installing SQL Server Express..."
    # Download SQL Server Express
    $url = "https://go.microsoft.com/fwlink/?LinkID=866658"
    $outFile = "$env:TEMP\SQL2019-SSEI-Expr.exe"
    Invoke-WebRequest -Uri $url -OutFile $outFile
    
    # Install SQL Server Express
    Start-Process -FilePath $outFile -ArgumentList "/ACTION=Install /IACCEPTSQLSERVERLICENSETERMS /QUIET" -Wait
}

# Configure SQL Server
$sqlps = "SqlServer"
if (-not (Get-Module -ListAvailable -Name $sqlps)) {
    Install-Module -Name $sqlps -Force -AllowClobber
}

# Create database
$query = "IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = '$($config.database)')
          BEGIN
              CREATE DATABASE [$($config.database)]
          END"
Invoke-Sqlcmd -Query $query -ServerInstance $config.sqlServer

Write-Host "Setup completed successfully!"
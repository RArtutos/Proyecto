# DatabaseManager.ps1
using namespace System.Data.SqlClient

class DatabaseManager {
    [string] $ConnectionString
    
    DatabaseManager([string]$server, [string]$database) {
        $this.ConnectionString = "Server=$server;Database=$database;Integrated Security=True;"
    }
    
    [void] InitializeDatabase() {
        $conn = [SqlConnection]::new($this.ConnectionString)
        $conn.Open()
        
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = @"
CREATE TABLE IF NOT EXISTS Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(255) NOT NULL,
    PublicKey NVARCHAR(MAX),
    PrivateKey NVARCHAR(MAX),
    CreatedDate DATETIME DEFAULT GETDATE(),
    Origin NVARCHAR(10) DEFAULT 'Windows'
);

CREATE TABLE IF NOT EXISTS Files (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Filename NVARCHAR(255) NOT NULL,
    IsEncrypted BIT DEFAULT 0,
    IsSigned BIT DEFAULT 0,
    Origin NVARCHAR(10) DEFAULT 'Windows',
    CreatedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE IF NOT EXISTS Logs (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT,
    Operation NVARCHAR(255),
    Details NVARCHAR(MAX),
    Timestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);
"@
        $cmd.ExecuteNonQuery()
        $conn.Close()
    }
    
    [void] AddUser([string]$username, [string]$publicKey, [string]$privateKey) {
        $conn = [SqlConnection]::new($this.ConnectionString)
        $conn.Open()
        
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = "INSERT INTO Users (Username, PublicKey, PrivateKey) VALUES (@username, @publicKey, @privateKey)"
        $cmd.Parameters.AddWithValue("@username", $username)
        $cmd.Parameters.AddWithValue("@publicKey", $publicKey)
        $cmd.Parameters.AddWithValue("@privateKey", $privateKey)
        
        $cmd.ExecuteNonQuery()
        $conn.Close()
    }
    
    [System.Data.DataTable] GetUsers() {
        $conn = [SqlConnection]::new($this.ConnectionString)
        $conn.Open()
        
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = "SELECT * FROM Users"
        
        $adapter = [SqlDataAdapter]::new($cmd)
        $table = [System.Data.DataTable]::new()
        $adapter.Fill($table)
        
        $conn.Close()
        return $table
    }
}

Export-ModuleMember -Function * -Variable *
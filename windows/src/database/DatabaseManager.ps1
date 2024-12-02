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
        
        # Create Users table
        $cmd.CommandText = @"
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Users] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [Username] NVARCHAR(255) NOT NULL,
        [FullName] NVARCHAR(255) NOT NULL,
        [Password] NVARCHAR(255) NOT NULL,
        [Email] NVARCHAR(255),
        [PublicKey] NVARCHAR(MAX),
        [PrivateKey] NVARCHAR(MAX),
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [Origin] NVARCHAR(10) DEFAULT 'Windows'
    )
END
"@
        $cmd.ExecuteNonQuery()

        # Create Files table
        $cmd.CommandText = @"
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Files]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Files] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [Filename] NVARCHAR(255) NOT NULL,
        [OwnerId] INT NOT NULL,
        [IsEncrypted] BIT DEFAULT 0,
        [IsSigned] BIT DEFAULT 0,
        [SignedBy] INT,
        [Origin] NVARCHAR(10) DEFAULT 'Windows',
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (OwnerId) REFERENCES Users(Id),
        FOREIGN KEY (SignedBy) REFERENCES Users(Id)
    )
END
"@
        $cmd.ExecuteNonQuery()

        # Create Logs table
        $cmd.CommandText = @"
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Logs]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Logs] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [UserId] INT,
        [Operation] NVARCHAR(255),
        [Details] NVARCHAR(MAX),
        [Timestamp] DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (UserId) REFERENCES Users(Id)
    )
END
"@
        $cmd.ExecuteNonQuery()
        
        $conn.Close()
    }

    [void] CreateUser([string]$username, [string]$fullName, [string]$password, [string]$email) {
        $conn = [SqlConnection]::new($this.ConnectionString)
        $conn.Open()
        
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = @"
INSERT INTO Users (Username, FullName, Password, Email) 
VALUES (@username, @fullName, @password, @email)
"@
        $cmd.Parameters.AddWithValue("@username", $username)
        $cmd.Parameters.AddWithValue("@fullName", $fullName)
        $cmd.Parameters.AddWithValue("@password", $password)
        $cmd.Parameters.AddWithValue("@email", $email)
        
        $cmd.ExecuteNonQuery()
        $conn.Close()
    }
}
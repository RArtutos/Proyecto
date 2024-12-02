# KeyManager.ps1
using namespace System.Security.Cryptography

class KeyManager {
    [string] $KeyStorePath
    
    KeyManager([string]$storePath) {
        $this.KeyStorePath = $storePath
        if (-not (Test-Path $storePath)) {
            New-Item -ItemType Directory -Path $storePath -Force
        }
    }
    
    [hashtable] GenerateKeyPair([string]$username) {
        $rsa = [RSACryptoServiceProvider]::new(2048)
        
        $privateKey = $rsa.ToXmlString($true)
        $publicKey = $rsa.ToXmlString($false)
        
        $privatePath = Join-Path $this.KeyStorePath "$username.private"
        $publicPath = Join-Path $this.KeyStorePath "$username.public"
        
        $privateKey | Out-File $privatePath -Force
        $publicKey | Out-File $publicPath -Force
        
        return @{
            PrivateKey = $privateKey
            PublicKey = $publicKey
        }
    }
    
    [string] GetPublicKey([string]$username) {
        $publicPath = Join-Path $this.KeyStorePath "$username.public"
        if (Test-Path $publicPath) {
            return Get-Content $publicPath -Raw
        }
        throw "Public key not found for user: $username"
    }
    
    [string] GetPrivateKey([string]$username) {
        $privatePath = Join-Path $this.KeyStorePath "$username.private"
        if (Test-Path $privatePath) {
            return Get-Content $privatePath -Raw
        }
        throw "Private key not found for user: $username"
    }
}

Export-ModuleMember -Function * -Variable *
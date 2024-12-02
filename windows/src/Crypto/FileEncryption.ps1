# FileEncryption.ps1
using namespace System.Security.Cryptography
using namespace System.Text

class FileEncryption {
    static [byte[]] EncryptFile([string]$filePath, [string]$publicKey) {
        $content = [File]::ReadAllBytes($filePath)
        $rsa = [RSACryptoServiceProvider]::new()
        $rsa.FromXmlString($publicKey)
        
        return $rsa.Encrypt($content, $true)
    }
    
    static [byte[]] DecryptFile([byte[]]$encryptedData, [string]$privateKey) {
        $rsa = [RSACryptoServiceProvider]::new()
        $rsa.FromXmlString($privateKey)
        
        return $rsa.Decrypt($encryptedData, $true)
    }
    
    static [string] SignFile([string]$filePath, [string]$privateKey) {
        $content = [File]::ReadAllBytes($filePath)
        $rsa = [RSACryptoServiceProvider]::new()
        $rsa.FromXmlString($privateKey)
        
        $signature = $rsa.SignData($content, [HashAlgorithmName]::SHA256, [RSASignaturePadding]::Pkcs1)
        return [Convert]::ToBase64String($signature)
    }
    
    static [bool] VerifySignature([string]$filePath, [string]$signature, [string]$publicKey) {
        $content = [File]::ReadAllBytes($filePath)
        $rsa = [RSACryptoServiceProvider]::new()
        $rsa.FromXmlString($publicKey)
        
        $signatureBytes = [Convert]::FromBase64String($signature)
        return $rsa.VerifyData($content, $signatureBytes, [HashAlgorithmName]::SHA256, [RSASignaturePadding]::Pkcs1)
    }
}

Export-ModuleMember -Function * -Variable *
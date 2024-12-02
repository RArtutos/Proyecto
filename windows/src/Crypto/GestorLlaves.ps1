# GestorLlaves.ps1
using namespace System.Security.Cryptography

class GestorLlaves {
    [string] $RutaLlaves

    GestorLlaves([string]$rutaLlaves) {
        $this.RutaLlaves = $rutaLlaves
        if (-not (Test-Path $rutaLlaves)) {
            New-Item -ItemType Directory -Path $rutaLlaves -Force
        }
    }

    [void] GenerarParLlaves([string]$usuario) {
        $rsa = [RSACryptoServiceProvider]::new(2048)
        
        $llavePrivada = $rsa.ToXmlString($true)
        $llavePublica = $rsa.ToXmlString($false)
        
        $rutaPrivada = Join-Path $this.RutaLlaves "$usuario.private"
        $rutaPublica = Join-Path $this.RutaLlaves "$usuario.public"
        
        $llavePrivada | Out-File $rutaPrivada -Force
        $llavePublica | Out-File $rutaPublica -Force
    }

    [byte[]] EncriptarArchivo([string]$rutaArchivo, [string]$usuario) {
        $contenido = [System.IO.File]::ReadAllBytes($rutaArchivo)
        $llavePublica = Get-Content (Join-Path $this.RutaLlaves "$usuario.public")
        
        $rsa = [RSACryptoServiceProvider]::new()
        $rsa.FromXmlString($llavePublica)
        
        return $rsa.Encrypt($contenido, $true)
    }

    [byte[]] DesencriptarArchivo([byte[]]$datosEncriptados, [string]$usuario) {
        $llavePrivada = Get-Content (Join-Path $this.RutaLlaves "$usuario.private")
        
        $rsa = [RSACryptoServiceProvider]::new()
        $rsa.FromXmlString($llavePrivada)
        
        return $rsa.Decrypt($datosEncriptados, $true)
    }

    [string] FirmarArchivo([string]$rutaArchivo, [string]$usuario) {
        $contenido = [System.IO.File]::ReadAllBytes($rutaArchivo)
        $llavePrivada = Get-Content (Join-Path $this.RutaLlaves "$usuario.private")
        
        $rsa = [RSACryptoServiceProvider]::new()
        $rsa.FromXmlString($llavePrivada)
        
        $firma = $rsa.SignData($contenido, [HashAlgorithmName]::SHA256, [RSASignaturePadding]::Pkcs1)
        return [Convert]::ToBase64String($firma)
    }

    [bool] VerificarFirma([string]$rutaArchivo, [string]$firma, [string]$usuario) {
        $contenido = [System.IO.File]::ReadAllBytes($rutaArchivo)
        $llavePublica = Get-Content (Join-Path $this.RutaLlaves "$usuario.public")
        
        $rsa = [RSACryptoServiceProvider]::new()
        $rsa.FromXmlString($llavePublica)
        
        $firmaBytes = [Convert]::FromBase64String($firma)
        return $rsa.VerifyData($contenido, $firmaBytes, [HashAlgorithmName]::SHA256, [RSASignaturePadding]::Pkcs1)
    }
}
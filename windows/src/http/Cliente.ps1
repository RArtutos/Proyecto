# Cliente.ps1
class ClienteHTTP {
    [string] $ServidorLinux
    
    ClienteHTTP([string]$servidor) {
        $this.ServidorLinux = $servidor
    }
    
    [object] EnviarPeticion([string]$ruta, [string]$metodo, [object]$datos) {
        $uri = "$($this.ServidorLinux)$ruta"
        
        $parametros = @{
            Uri = $uri
            Method = $metodo
            ContentType = "application/json"
        }
        
        if ($datos) {
            $parametros.Body = ($datos | ConvertTo-Json)
        }
        
        try {
            $respuesta = Invoke-RestMethod @parametros
            return $respuesta
        }
        catch {
            Write-Error "Error en la petición: $_"
            return $null
        }
    }
    
    [void] SincronizarUsuarios() {
        $usuarios = $this.EnviarPeticion("/api/usuarios", "GET", $null)
        foreach ($usuario in $usuarios) {
            Add-UsuarioLocal $usuario
        }
    }
    
    [bool] SubirArchivo([string]$rutaArchivo) {
        $archivo = Get-Item $rutaArchivo
        $contenido = [System.IO.File]::ReadAllBytes($rutaArchivo)
        
        $datos = @{
            nombre = $archivo.Name
            contenido = [Convert]::ToBase64String($contenido)
        }
        
        $respuesta = $this.EnviarPeticion("/api/archivos", "POST", $datos)
        return $respuesta -ne $null
    }
}
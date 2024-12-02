# Servidor.ps1
using namespace System.Net
using namespace System.Text

class ServidorHTTP {
    [HttpListener] $Listener
    [int] $Puerto
    [string] $RutaArchivos
    
    ServidorHTTP([int]$puerto) {
        $this.Puerto = $puerto
        $this.RutaArchivos = "C:\ProgramData\SecureFileSystem\files"
        $this.Listener = [HttpListener]::new()
        $this.Listener.Prefixes.Add("http://+:$puerto/")
    }
    
    [void] Iniciar() {
        $this.Listener.Start()
        Write-Host "Servidor iniciado en puerto $($this.Puerto)"
        
        while ($this.Listener.IsListening) {
            $contexto = $this.Listener.GetContext()
            $this.ProcesarPeticion($contexto)
        }
    }
    
    [void] ProcesarPeticion([HttpListenerContext]$contexto) {
        $peticion = $contexto.Request
        $respuesta = $contexto.Response
        
        switch ($peticion.Url.LocalPath) {
            "/api/usuarios" {
                if ($peticion.HttpMethod -eq "POST") {
                    $this.ProcesarCreacionUsuario($contexto)
                }
                elseif ($peticion.HttpMethod -eq "GET") {
                    $this.EnviarListaUsuarios($contexto)
                }
            }
            "/api/archivos" {
                if ($peticion.HttpMethod -eq "POST") {
                    $this.ProcesarSubidaArchivo($contexto)
                }
                elseif ($peticion.HttpMethod -eq "GET") {
                    $this.EnviarListaArchivos($contexto)
                }
            }
            default {
                $this.EnviarError($contexto, "Ruta no encontrada", 404)
            }
        }
    }
    
    [void] EnviarRespuesta([HttpListenerContext]$contexto, [object]$datos, [int]$codigo = 200) {
        $json = ConvertTo-Json $datos
        $buffer = [Encoding]::UTF8.GetBytes($json)
        
        $contexto.Response.StatusCode = $codigo
        $contexto.Response.ContentType = "application/json"
        $contexto.Response.ContentLength64 = $buffer.Length
        $contexto.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $contexto.Response.Close()
    }
    
    [void] EnviarError([HttpListenerContext]$contexto, [string]$mensaje, [int]$codigo) {
        $this.EnviarRespuesta($contexto, @{error = $mensaje}, $codigo)
    }
    
    [void] Detener() {
        $this.Listener.Stop()
        $this.Listener.Close()
    }
}

# Iniciar el servidor
$servidor = [ServidorHTTP]::new(8080)
$servidor.Iniciar()
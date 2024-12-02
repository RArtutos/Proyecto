# Server.ps1
using namespace System.Net
using namespace System.Text

class HttpServer {
    [HttpListener] $Listener
    [int] $Port
    
    HttpServer([int]$port) {
        $this.Port = $port
        $this.Listener = [HttpListener]::new()
        $this.Listener.Prefixes.Add("http://+:$port/")
    }
    
    [void] Start() {
        $this.Listener.Start()
        Write-Host "Server started on port $($this.Port)"
        
        while ($this.Listener.IsListening) {
            $context = $this.Listener.GetContext()
            $this.HandleRequest($context)
        }
    }
    
    [void] HandleRequest([HttpListenerContext]$context) {
        $request = $context.Request
        $response = $context.Response
        
        switch ($request.Url.LocalPath) {
            "/api/users" {
                if ($request.HttpMethod -eq "POST") {
                    $this.HandleCreateUser($context)
                }
                elseif ($request.HttpMethod -eq "GET") {
                    $this.HandleGetUsers($context)
                }
            }
            "/api/files" {
                if ($request.HttpMethod -eq "POST") {
                    $this.HandleFileUpload($context)
                }
                elseif ($request.HttpMethod -eq "GET") {
                    $this.HandleFileList($context)
                }
            }
            default {
                $this.SendResponse($context, @{error = "Invalid endpoint"}, 404)
            }
        }
    }
    
    [void] SendResponse([HttpListenerContext]$context, [object]$data, [int]$statusCode = 200) {
        $json = ConvertTo-Json $data
        $buffer = [Encoding]::UTF8.GetBytes($json)
        
        $context.Response.StatusCode = $statusCode
        $context.Response.ContentType = "application/json"
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.Close()
    }
    
    [void] Stop() {
        $this.Listener.Stop()
        $this.Listener.Close()
    }
}

Export-ModuleMember -Function * -Variable *
#!/bin/bash

source ../process/process_manager.sh

PUERTO=8080
RUTA_ARCHIVOS="/var/lib/secure-files"

function procesar_peticion() {
    local peticion
    read -r peticion

    local metodo=$(echo "$peticion" | cut -d' ' -f1)
    local ruta=$(echo "$peticion" | cut -d' ' -f2)

    case "$ruta" in
        "/api/processes")
            if [ "$metodo" = "GET" ]; then
                echo -e "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r"
                format_processes_json
            elif [ "$metodo" = "POST" ]; then
                local content_length=$(grep -i "Content-Length:" | cut -d' ' -f2)
                read -n "$content_length" data
                local pid=$(echo "$data" | jq -r '.processId')
                
                if stop_process "$pid"; then
                    echo -e "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r{\"success\":true}"
                else
                    echo -e "HTTP/1.1 500 Internal Server Error\r\nContent-Type: application/json\r\n\r{\"success\":false}"
                fi
            fi
            ;;
        *)
            echo -e "HTTP/1.1 404 Not Found\r\nContent-Type: application/json\r\n\r{\"error\":\"Not Found\"}"
            ;;
    esac
}

while true; do
    nc -l -p "$PUERTO" -c procesar_peticion
done
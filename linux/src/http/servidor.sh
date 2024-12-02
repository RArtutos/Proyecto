#!/bin/bash

# Configuración del servidor
PUERTO=8080
RUTA_ARCHIVOS="/var/lib/secure-files"

# Función para procesar peticiones
function procesar_peticion() {
    local peticion
    read -r peticion

    # Extraer método y ruta
    local metodo=$(echo "$peticion" | cut -d' ' -f1)
    local ruta=$(echo "$peticion" | cut -d' ' -f2)

    # Leer headers
    while read -r linea; do
        [ -z "$(echo $linea | tr -d '\r\n')" ] && break
    done

    case "$ruta" in
        "/api/usuarios")
            if [ "$metodo" = "GET" ]; then
                echo -e "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r"
                listar_usuarios_json
            elif [ "$metodo" = "POST" ]; then
                # Leer el cuerpo de la petición
                read -n "$CONTENT_LENGTH" datos
                echo -e "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r"
                crear_usuario_desde_json "$datos"
            fi
            ;;
        "/api/archivos")
            if [ "$metodo" = "GET" ]; then
                echo -e "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r"
                listar_archivos_json
            elif [ "$metodo" = "POST" ]; then
                # Procesar subida de archivo
                procesar_subida_archivo
            fi
            ;;
        *)
            echo -e "HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\n\r\nRuta no encontrada"
            ;;
    esac
}

# Iniciar servidor
while true; do
    nc -l -p $PUERTO -c procesar_peticion
done
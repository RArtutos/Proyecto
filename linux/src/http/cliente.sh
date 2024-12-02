#!/bin/bash

# Configuración del cliente
SERVIDOR_WINDOWS="http://localhost:8080"

function enviar_peticion() {
    local ruta="$1"
    local metodo="$2"
    local datos="$3"
    
    if [ "$metodo" = "GET" ]; then
        curl -s -X GET "$SERVIDOR_WINDOWS$ruta"
    elif [ "$metodo" = "POST" ]; then
        curl -s -X POST "$SERVIDOR_WINDOWS$ruta" \
             -H "Content-Type: application/json" \
             -d "$datos"
    fi
}

function sincronizar_usuarios() {
    local usuarios=$(enviar_peticion "/api/usuarios" "GET")
    echo "$usuarios" | jq -r '.[]' | while read -r usuario; do
        crear_usuario_local "$usuario"
    done
}

function subir_archivo() {
    local archivo="$1"
    local nombre=$(basename "$archivo")
    
    curl -s -X POST "$SERVIDOR_WINDOWS/api/archivos" \
         -F "archivo=@$archivo" \
         -F "nombre=$nombre"
}
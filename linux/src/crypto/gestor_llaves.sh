#!/bin/bash

RUTA_LLAVES="/var/lib/secure-files/keys"

function generar_par_llaves() {
    local usuario="$1"
    local ruta_privada="$RUTA_LLAVES/$usuario.private"
    local ruta_publica="$RUTA_LLAVES/$usuario.public"

    # Generar par de llaves RSA
    openssl genpkey -algorithm RSA -out "$ruta_privada" -pkeyopt rsa_keygen_bits:2048
    openssl rsa -pubout -in "$ruta_privada" -out "$ruta_publica"

    # Establecer permisos
    chmod 600 "$ruta_privada"
    chmod 644 "$ruta_publica"

    return 0
}

function encriptar_archivo() {
    local archivo="$1"
    local usuario_destino="$2"
    local llave_publica="$RUTA_LLAVES/$usuario_destino.public"
    
    openssl rsautl -encrypt -pubin -inkey "$llave_publica" \
                   -in "$archivo" -out "$archivo.enc"
}

function desencriptar_archivo() {
    local archivo="$1"
    local usuario="$2"
    local llave_privada="$RUTA_LLAVES/$usuario.private"
    
    openssl rsautl -decrypt -inkey "$llave_privada" \
                   -in "$archivo" -out "${archivo%.enc}"
}

function firmar_archivo() {
    local archivo="$1"
    local usuario="$2"
    local llave_privada="$RUTA_LLAVES/$usuario.private"
    
    openssl dgst -sha256 -sign "$llave_privada" \
                 -out "$archivo.sig" "$archivo"
}

function verificar_firma() {
    local archivo="$1"
    local firma="$archivo.sig"
    local usuario="$2"
    local llave_publica="$RUTA_LLAVES/$usuario.public"
    
    openssl dgst -sha256 -verify "$llave_publica" \
                 -signature "$firma" "$archivo"
}
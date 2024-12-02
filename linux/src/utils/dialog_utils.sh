#!/bin/bash

# Configuración general de dialog
export DIALOG_OK=0
export DIALOG_CANCEL=1
export DIALOG_ESC=255

function mostrar_error() {
    local mensaje="$1"
    dialog --title "Error" --msgbox "$mensaje" 6 50
}

function mostrar_exito() {
    local mensaje="$1"
    dialog --title "Éxito" --msgbox "$mensaje" 6 50
}

function mostrar_info() {
    local titulo="$1"
    local mensaje="$2"
    dialog --title "$titulo" --msgbox "$mensaje" 8 60
}

function seleccionar_archivo() {
    local titulo="$1"
    local directorio="/var/lib/secure-files"
    
    dialog --title "$titulo" \
           --fselect "$directorio/" 10 60 \
           2>/tmp/archivo_seleccionado

    if [ $? -eq 0 ]; then
        cat /tmp/archivo_seleccionado
        return 0
    else
        return 1
    fi
}

function seleccionar_usuario() {
    local titulo="$1"
    local usuarios=$(listar_usuarios)
    
    dialog --title "$titulo" \
           --menu "Seleccione un usuario:" 15 50 8 \
           $usuarios 2>/tmp/usuario_seleccionado

    if [ $? -eq 0 ]; then
        cat /tmp/usuario_seleccionado
        return 0
    else
        return 1
    fi
}

function confirmar_accion() {
    local mensaje="$1"
    dialog --title "Confirmar" \
           --yesno "$mensaje" 8 50
    return $?
}

function mostrar_progreso() {
    local titulo="$1"
    local comando="$2"
    
    (
        $comando 2>&1 | dialog --title "$titulo" \
                              --progressbox 20 70
    )
}

function entrada_texto() {
    local titulo="$1"
    local mensaje="$2"
    
    dialog --title "$titulo" \
           --inputbox "$mensaje" 8 50 \
           2>/tmp/entrada_texto

    if [ $? -eq 0 ]; then
        cat /tmp/entrada_texto
        return 0
    else
        return 1
    fi
}

function seleccionar_opcion() {
    local titulo="$1"
    shift
    local opciones=("$@")
    
    local menu_items=""
    local i=1
    for opcion in "${opciones[@]}"; do
        menu_items="$menu_items $i $opcion"
        ((i++))
    done
    
    dialog --title "$titulo" \
           --menu "Seleccione una opción:" 15 50 8 \
           $menu_items 2>/tmp/opcion_seleccionada

    if [ $? -eq 0 ]; then
        cat /tmp/opcion_seleccionada
        return 0
    else
        return 1
    fi
}

function mostrar_lista() {
    local titulo="$1"
    local items="$2"
    
    dialog --title "$titulo" \
           --msgbox "$items" 20 70
}

function entrada_password() {
    local titulo="$1"
    local mensaje="$2"
    
    dialog --title "$titulo" \
           --passwordbox "$mensaje" 8 50 \
           2>/tmp/password

    if [ $? -eq 0 ]; then
        cat /tmp/password
        return 0
    else
        return 1
    fi
}

function limpiar_archivos_temp() {
    rm -f /tmp/archivo_seleccionado
    rm -f /tmp/usuario_seleccionado
    rm -f /tmp/entrada_texto
    rm -f /tmp/opcion_seleccionada
    rm -f /tmp/password
}

# Registrar limpieza de archivos temporales al salir
trap limpiar_archivos_temp EXIT
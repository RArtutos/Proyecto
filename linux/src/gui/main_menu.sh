#!/bin/bash

# Importar utilidades
source ../utils/dialog_utils.sh
source ../crypto/gestor_llaves.sh
source ../database/gestor_db.sh
source ../archivos/gestor_archivos.sh

DIALOG=${DIALOG=dialog}
TEMP_FILE="/tmp/input.$$"

function mostrar_menu_principal() {
    while true; do
        $DIALOG --clear --title "Sistema de Archivos Seguro" \
                --menu "Seleccione una operación:" 20 70 12 \
                1 "Crear Nuevo Usuario" \
                2 "Generar Par de Llaves" \
                3 "Subir Archivo" \
                4 "Descargar Archivo" \
                5 "Encriptar Archivo" \
                6 "Firmar Archivo" \
                7 "Ver Usuarios" \
                8 "Ver Archivos" \
                9 "Validar Firma" \
                10 "Desencriptar Archivo" \
                11 "Gestionar Procesos Remotos" \
                12 "Salir" 2> $TEMP_FILE

        if [ $? -ne 0 ]; then
            rm -f $TEMP_FILE
            exit 1
        fi

        opcion=$(cat $TEMP_FILE)
        case $opcion in
            1) crear_usuario ;;
            2) generar_llaves ;;
            3) subir_archivo ;;
            4) descargar_archivo ;;
            5) encriptar_archivo ;;
            6) firmar_archivo ;;
            7) ver_usuarios ;;
            8) ver_archivos ;;
            9) validar_firma ;;
            10) desencriptar_archivo ;;
            11) gestionar_procesos ;;
            12) 
                rm -f $TEMP_FILE
                clear
                exit 0
                ;;
        esac
    done
}

function crear_usuario() {
    $DIALOG --title "Crear Usuario" \
            --form "Ingrese los datos del usuario:" 15 50 3 \
            "Usuario:" 1 1 "" 1 15 30 0 \
            "Nombre:" 2 1 "" 2 15 30 0 \
            2> $TEMP_FILE

    if [ $? -eq 0 ]; then
        usuario=$(sed -n 1p $TEMP_FILE)
        nombre=$(sed -n 2p $TEMP_FILE)
        crear_usuario_db "$usuario" "$nombre"
        $DIALOG --msgbox "Usuario creado exitosamente" 6 40
    fi
}

function generar_llaves() {
    usuario=$($DIALOG --title "Generar Llaves" \
                    --inputbox "Ingrese el nombre de usuario:" 8 40 \
                    2> $TEMP_FILE)

    if [ $? -eq 0 ]; then
        generar_par_llaves "$usuario"
        $DIALOG --msgbox "Llaves generadas exitosamente" 6 40
    fi
}

# Iniciar la aplicación
clear
mostrar_menu_principal
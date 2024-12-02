# MainWindow.ps1
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "$PSScriptRoot\..\Crypto\GestorLlaves.ps1"
. "$PSScriptRoot\..\Database\GestorDB.ps1"
. "$PSScriptRoot\..\Archivos\GestorArchivos.ps1"
. "$PSScriptRoot\ProcessWindow.ps1"

function Crear-VentanaPrincipal {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Sistema de Archivos Seguro"
    $form.Size = New-Object System.Drawing.Size(600,400)
    $form.StartPosition = "CenterScreen"

    $menu = New-Object System.Windows.Forms.MenuStrip
    $form.MainMenuStrip = $menu

    $menuUsuarios = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuUsuarios.Text = "Usuarios"
    $menuUsuarios.DropDownItems.Add("Crear Usuario", $null).Add_Click({Mostrar-CrearUsuario})
    $menuUsuarios.DropDownItems.Add("Generar Llaves", $null).Add_Click({Mostrar-GenerarLlaves})
    $menuUsuarios.DropDownItems.Add("Ver Usuarios", $null).Add_Click({Mostrar-ListaUsuarios})

    $menuArchivos = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuArchivos.Text = "Archivos"
    $menuArchivos.DropDownItems.Add("Subir Archivo", $null).Add_Click({Mostrar-SubirArchivo})
    $menuArchivos.DropDownItems.Add("Descargar Archivo", $null).Add_Click({Mostrar-DescargarArchivo})
    $menuArchivos.DropDownItems.Add("Ver Archivos", $null).Add_Click({Mostrar-ListaArchivos})

    $menuSeguridad = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuSeguridad.Text = "Seguridad"
    $menuSeguridad.DropDownItems.Add("Encriptar Archivo", $null).Add_Click({Mostrar-EncriptarArchivo})
    $menuSeguridad.DropDownItems.Add("Desencriptar Archivo", $null).Add_Click({Mostrar-DesencriptarArchivo})
    $menuSeguridad.DropDownItems.Add("Firmar Archivo", $null).Add_Click({Mostrar-FirmarArchivo})
    $menuSeguridad.DropDownItems.Add("Verificar Firma", $null).Add_Click({Mostrar-VerificarFirma})

    # Add Process Management menu
    $menuProcesos = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuProcesos.Text = "Procesos"
    $menuProcesos.DropDownItems.Add("Gestionar Procesos", $null).Add_Click({Show-ProcessWindow})

    $menu.Items.Add($menuUsuarios)
    $menu.Items.Add($menuArchivos)
    $menu.Items.Add($menuSeguridad)
    $menu.Items.Add($menuProcesos)

    $form.Controls.Add($menu)
    return $form
}

# Start the application
$ventanaPrincipal = Crear-VentanaPrincipal
[System.Windows.Forms.Application]::Run($ventanaPrincipal)
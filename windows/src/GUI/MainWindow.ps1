# MainWindow.ps1
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Importar módulos
. "$PSScriptRoot\..\Crypto\GestorLlaves.ps1"
. "$PSScriptRoot\..\Database\GestorDB.ps1"
. "$PSScriptRoot\..\Archivos\GestorArchivos.ps1"

function Crear-VentanaPrincipal {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Sistema de Archivos Seguro"
    $form.Size = New-Object System.Drawing.Size(600,400)
    $form.StartPosition = "CenterScreen"

    # Menú principal
    $menu = New-Object System.Windows.Forms.MenuStrip
    $form.MainMenuStrip = $menu

    # Menú Usuarios
    $menuUsuarios = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuUsuarios.Text = "Usuarios"
    $menuUsuarios.DropDownItems.Add("Crear Usuario", $null).Add_Click({Mostrar-CrearUsuario})
    $menuUsuarios.DropDownItems.Add("Generar Llaves", $null).Add_Click({Mostrar-GenerarLlaves})
    $menuUsuarios.DropDownItems.Add("Ver Usuarios", $null).Add_Click({Mostrar-ListaUsuarios})

    # Menú Archivos
    $menuArchivos = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuArchivos.Text = "Archivos"
    $menuArchivos.DropDownItems.Add("Subir Archivo", $null).Add_Click({Mostrar-SubirArchivo})
    $menuArchivos.DropDownItems.Add("Descargar Archivo", $null).Add_Click({Mostrar-DescargarArchivo})
    $menuArchivos.DropDownItems.Add("Ver Archivos", $null).Add_Click({Mostrar-ListaArchivos})

    # Menú Seguridad
    $menuSeguridad = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuSeguridad.Text = "Seguridad"
    $menuSeguridad.DropDownItems.Add("Encriptar Archivo", $null).Add_Click({Mostrar-EncriptarArchivo})
    $menuSeguridad.DropDownItems.Add("Desencriptar Archivo", $null).Add_Click({Mostrar-DesencriptarArchivo})
    $menuSeguridad.DropDownItems.Add("Firmar Archivo", $null).Add_Click({Mostrar-FirmarArchivo})
    $menuSeguridad.DropDownItems.Add("Verificar Firma", $null).Add_Click({Mostrar-VerificarFirma})

    # Agregar menús
    $menu.Items.Add($menuUsuarios)
    $menu.Items.Add($menuArchivos)
    $menu.Items.Add($menuSeguridad)

    $form.Controls.Add($menu)
    return $form
}

function Mostrar-CrearUsuario {
    $formUsuario = New-Object System.Windows.Forms.Form
    $formUsuario.Text = "Crear Usuario"
    $formUsuario.Size = New-Object System.Drawing.Size(300,200)
    $formUsuario.StartPosition = "CenterScreen"

    $lblUsuario = New-Object System.Windows.Forms.Label
    $lblUsuario.Location = New-Object System.Drawing.Point(10,20)
    $lblUsuario.Size = New-Object System.Drawing.Size(100,20)
    $lblUsuario.Text = "Usuario:"
    $formUsuario.Controls.Add($lblUsuario)

    $txtUsuario = New-Object System.Windows.Forms.TextBox
    $txtUsuario.Location = New-Object System.Drawing.Point(110,20)
    $txtUsuario.Size = New-Object System.Drawing.Size(150,20)
    $formUsuario.Controls.Add($txtUsuario)

    $btnCrear = New-Object System.Windows.Forms.Button
    $btnCrear.Location = New-Object System.Drawing.Point(110,100)
    $btnCrear.Size = New-Object System.Drawing.Size(75,23)
    $btnCrear.Text = "Crear"
    $btnCrear.Add_Click({
        $usuario = $txtUsuario.Text
        if ($usuario) {
            Crear-Usuario $usuario
            [System.Windows.Forms.MessageBox]::Show("Usuario creado exitosamente")
            $formUsuario.Close()
        }
    })
    $formUsuario.Controls.Add($btnCrear)

    $formUsuario.ShowDialog()
}

# Iniciar la aplicación
$ventanaPrincipal = Crear-VentanaPrincipal
[System.Windows.Forms.Application]::Run($ventanaPrincipal)
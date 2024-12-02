# MainWindow.ps1
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Start-MainWindow {
    param (
        [Parameter(Mandatory=$true)]
        [ConfigManager]$Config
    )

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Secure File System"
    $form.Size = New-Object System.Drawing.Size(600,400)
    $form.StartPosition = "CenterScreen"

    $menu = New-Object System.Windows.Forms.MenuStrip
    $form.MainMenuStrip = $menu

    # Users Menu
    $menuUsers = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuUsers.Text = "Users"
    $menuUsers.DropDownItems.Add("Create User", $null).Add_Click({Show-CreateUserWindow})

    # Files Menu
    $menuFiles = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuFiles.Text = "Files"

    # Security Menu
    $menuSecurity = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuSecurity.Text = "Security"

    # Process Menu
    $menuProcesses = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuProcesses.Text = "Processes"
    $menuProcesses.DropDownItems.Add("Manage Processes", $null).Add_Click({Show-ProcessWindow})

    $menu.Items.Add($menuUsers)
    $menu.Items.Add($menuFiles)
    $menu.Items.Add($menuSecurity)
    $menu.Items.Add($menuProcesses)

    $form.Controls.Add($menu)
    $form.ShowDialog()
}
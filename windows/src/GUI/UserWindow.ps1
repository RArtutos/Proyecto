# UserWindow.ps1
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-CreateUserWindow {
    param (
        [Parameter(Mandatory=$true)]
        [ConfigManager]$Config
    )

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Create New User"
    $form.Size = New-Object System.Drawing.Size(400,350)
    $form.StartPosition = "CenterScreen"

    # Username
    $lblUsername = New-Object System.Windows.Forms.Label
    $lblUsername.Location = New-Object System.Drawing.Point(10,20)
    $lblUsername.Size = New-Object System.Drawing.Size(100,20)
    $lblUsername.Text = "Username:"
    $form.Controls.Add($lblUsername)

    $txtUsername = New-Object System.Windows.Forms.TextBox
    $txtUsername.Location = New-Object System.Drawing.Point(120,20)
    $txtUsername.Size = New-Object System.Drawing.Size(250,20)
    $form.Controls.Add($txtUsername)

    # Full Name
    $lblFullName = New-Object System.Windows.Forms.Label
    $lblFullName.Location = New-Object System.Drawing.Point(10,60)
    $lblFullName.Size = New-Object System.Drawing.Size(100,20)
    $lblFullName.Text = "Full Name:"
    $form.Controls.Add($lblFullName)

    $txtFullName = New-Object System.Windows.Forms.TextBox
    $txtFullName.Location = New-Object System.Drawing.Point(120,60)
    $txtFullName.Size = New-Object System.Drawing.Size(250,20)
    $form.Controls.Add($txtFullName)

    # Password
    $lblPassword = New-Object System.Windows.Forms.Label
    $lblPassword.Location = New-Object System.Drawing.Point(10,100)
    $lblPassword.Size = New-Object System.Drawing.Size(100,20)
    $lblPassword.Text = "Password:"
    $form.Controls.Add($lblPassword)

    $txtPassword = New-Object System.Windows.Forms.TextBox
    $txtPassword.Location = New-Object System.Drawing.Point(120,100)
    $txtPassword.Size = New-Object System.Drawing.Size(250,20)
    $txtPassword.PasswordChar = '*'
    $form.Controls.Add($txtPassword)

    # Email
    $lblEmail = New-Object System.Windows.Forms.Label
    $lblEmail.Location = New-Object System.Drawing.Point(10,140)
    $lblEmail.Size = New-Object System.Drawing.Size(100,20)
    $lblEmail.Text = "Email:"
    $form.Controls.Add($lblEmail)

    $txtEmail = New-Object System.Windows.Forms.TextBox
    $txtEmail.Location = New-Object System.Drawing.Point(120,140)
    $txtEmail.Size = New-Object System.Drawing.Size(250,20)
    $form.Controls.Add($txtEmail)

    # Create Button
    $btnCreate = New-Object System.Windows.Forms.Button
    $btnCreate.Location = New-Object System.Drawing.Point(120,200)
    $btnCreate.Size = New-Object System.Drawing.Size(100,30)
    $btnCreate.Text = "Create"
    $btnCreate.Add_Click({
        if ($txtUsername.Text -and $txtFullName.Text -and $txtPassword.Text) {
            $dbManager = [DatabaseManager]::new($Config.SqlServer, $Config.Database)
            $dbManager.CreateUser($txtUsername.Text, $txtFullName.Text, $txtPassword.Text, $txtEmail.Text)
            [System.Windows.Forms.MessageBox]::Show("User created successfully")
            $form.Close()
        }
        else {
            [System.Windows.Forms.MessageBox]::Show("Please fill in all required fields")
        }
    })
    $form.Controls.Add($btnCreate)

    $form.ShowDialog()
}
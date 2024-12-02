# ProcessWindow.ps1
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. "$PSScriptRoot\..\ProcessManagement\ProcessManager.ps1"

function Show-ProcessWindow {
    $processManager = [ProcessManager]::new("http://localhost:8080")
    
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Process Manager"
    $form.Size = New-Object System.Drawing.Size(800,600)
    $form.StartPosition = "CenterScreen"

    $gridView = New-Object System.Windows.Forms.DataGridView
    $gridView.Location = New-Object System.Drawing.Point(10,10)
    $gridView.Size = New-Object System.Drawing.Size(760,480)
    $gridView.AllowUserToAddRows = $false
    $gridView.AllowUserToDeleteRows = $false
    $gridView.ReadOnly = $true
    $gridView.MultiSelect = $false
    $gridView.SelectionMode = "FullRowSelect"
    
    $btnRefresh = New-Object System.Windows.Forms.Button
    $btnRefresh.Location = New-Object System.Drawing.Point(10,500)
    $btnRefresh.Size = New-Object System.Drawing.Size(100,30)
    $btnRefresh.Text = "Refresh"
    $btnRefresh.Add_Click({
        Update-ProcessList $gridView $processManager
    })

    $btnStop = New-Object System.Windows.Forms.Button
    $btnStop.Location = New-Object System.Drawing.Point(120,500)
    $btnStop.Size = New-Object System.Drawing.Size(100,30)
    $btnStop.Text = "Stop Process"
    $btnStop.Add_Click({
        if ($gridView.SelectedRows.Count -gt 0) {
            $processId = $gridView.SelectedRows[0].Cells["Id"].Value
            if ($processManager.StopRemoteProcess($processId)) {
                [System.Windows.Forms.MessageBox]::Show("Process stopped successfully")
                Update-ProcessList $gridView $processManager
            }
            else {
                [System.Windows.Forms.MessageBox]::Show("Failed to stop process")
            }
        }
    })

    $form.Controls.Add($gridView)
    $form.Controls.Add($btnRefresh)
    $form.Controls.Add($btnStop)

    Update-ProcessList $gridView $processManager
    $form.ShowDialog()
}

function Update-ProcessList($gridView, $processManager) {
    $processes = $processManager.GetRemoteProcesses()
    $gridView.DataSource = $processes
}

Export-ModuleMember -Function Show-ProcessWindow
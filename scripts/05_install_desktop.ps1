. "$PSScriptRoot\helpers.ps1"

Write-Header "ETAPE 5 : Installation WSL Debian / Bruno / VSCode"
Initialize-TmpDir

Write-Step "Installation de WSL avec Debian..."

$wslStatus = wsl --status 2>&1
if ($LASTEXITCODE -eq 0 -and ($wslStatus -match "Debian")) {
    Write-Info "WSL avec Debian est deja installe."
} else {
    $wslFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
    if ($wslFeature.State -ne "Enabled") {
        Write-Info "Activation de la fonctionnalite WSL..."
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart | Out-Null
        Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform          -NoRestart | Out-Null
    }

    Write-Info "Installation de Debian via WSL (cela peut prendre quelques minutes)..."
    wsl --install -d Debian --no-launch
    if ($LASTEXITCODE -eq 0) {
        Write-Success "WSL Debian installe."
        Write-Log "WSL Debian installed"
        Write-Warn "Un redemarrage peut etre necessaire pour finaliser WSL."
    } else {
        Write-Err "Echec de l'installation de WSL Debian (code: $LASTEXITCODE)"
    }
}

Write-Step "Installation de Bruno..."

$brunoUrl  = Get-DownloadUrl "bruno"
$brunoExe  = Join-Path $script:TMP_DIR "bruno-installer.exe"

$ok = Get-Download -Url $brunoUrl -Dest $brunoExe
if ($ok) {
    Start-Process -FilePath $brunoExe -ArgumentList "/S" -Wait -NoNewWindow
    Write-Success "Bruno installe."
    Write-Log "Bruno installed"

    $brunoTarget = "$env:LOCALAPPDATA\Programs\Bruno\Bruno.exe"
    if (Test-Path $brunoTarget) {
        New-Shortcut -ShortcutPath (Join-Path $script:DEV_SOFT "Bruno.lnk") `
                     -Target       $brunoTarget `
                     -Description  "Bruno API Client"
    }
} else {
    Write-Err "Impossible d'installer Bruno."
}

Write-Step "Installation de Visual Studio Code..."

$codeUrl    = Get-DownloadUrl "code"
$codeExe    = Join-Path $script:TMP_DIR "vscode-installer.exe"

$ok = Get-Download -Url $codeUrl -Dest $codeExe
if ($ok) {
    $codeArgs = "/VERYSILENT /NORESTART /MERGETASKS=!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"
    Start-Process -FilePath $codeExe -ArgumentList $codeArgs -Wait -NoNewWindow
    Write-Success "VSCode installe."
    Write-Log "VSCode installed"
} else {
    Write-Err "Impossible d'installer VSCode."
}

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path","User")

# Raccourci VSCode
$codeTarget = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"
if (-not (Test-Path $codeTarget)) {
    $codeTarget = "C:\Program Files\Microsoft VS Code\Code.exe"
}
if (Test-Path $codeTarget) {
    New-Shortcut -ShortcutPath (Join-Path $script:DEV_SOFT "VSCode.lnk") `
                 -Target       $codeTarget `
                 -Description  "Visual Studio Code"
}

Write-Step "Application des settings VSCode..."

$vsCodeSettingsDir  = Join-Path $env:APPDATA "Code\User"
$vsCodeSettingsDest = Join-Path $vsCodeSettingsDir "settings.json"

New-Item -ItemType Directory -Force -Path $vsCodeSettingsDir | Out-Null

if (Test-Path $script:SETTINGS_FILE) {
    Copy-Item -Path $script:SETTINGS_FILE -Destination $vsCodeSettingsDest -Force
    Write-Success "settings.json applique : $vsCodeSettingsDest"
    Write-Log "VSCode settings applied from $($script:SETTINGS_FILE)"

    Copy-Item -Path $script:SETTINGS_FILE `
              -Destination (Join-Path $script:DEV_CONFIG "vscode\settings.json") -Force
} else {
    Write-Warn "Fichier conf/settings.json introuvable."
}

Write-Step "Installation des extensions VSCode (depuis user.ini [plugins])..."

$codeBin = Get-Command code -ErrorAction SilentlyContinue
if (-not $codeBin) {
    Write-Warn "La commande 'code' n'est pas dans le PATH. Ajoutez VSCode au PATH et relancez."
} else {
    $ini      = Read-Ini $script:USERINI_FILE
    $plugins  = $ini["plugins"]
    if ($plugins) {
        $allExtensions = @()
        foreach ($key in $plugins.Keys) {
            $exts = ($plugins[$key] -split ",") | ForEach-Object { $_.Trim() }
            $allExtensions += $exts
        }

        $total = $allExtensions.Count
        $i     = 1
        foreach ($ext in $allExtensions) {
            Write-Host "  [$i/$total] " -NoNewline -ForegroundColor DarkGray
            Write-Host "Installation de " -NoNewline -ForegroundColor White
            Write-Host $ext              -ForegroundColor Cyan
            & code --install-extension $ext --force 2>&1 | Out-Null
            Write-Log "VSCode extension: $ext"
            $i++
        }
        Write-Success "$($allExtensions.Count) extension(s) installee(s)."
    }
}

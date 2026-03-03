. "$PSScriptRoot\helpers.ps1"

Write-Header "ETAPE 7 : Nettoyage et sauvegarde"

$backupDir   = Join-Path $script:DEV_CONFIG "backup"
$timestamp   = Get-Date -Format "yyyyMMdd_HHmmss"
$backupStamp = Join-Path $backupDir "backup_$timestamp"

New-Item -ItemType Directory -Force -Path $backupStamp | Out-Null
Write-Step "Sauvegarde des fichiers de configuration..."

$backupItems = @(
    @{ Src  = $script:SETTINGS_FILE
       Dest = Join-Path $backupStamp "settings.json"
       Name = "VSCode settings.json" },

    @{ Src  = $script:USERINI_FILE
       Dest = Join-Path $backupStamp "user.ini"
       Name = "user.ini" },

    @{ Src  = $script:LINKS_FILE
       Dest = Join-Path $backupStamp "links.ini"
       Name = "links.ini" },

    @{ Src  = "$HOME\.gitconfig"
       Dest = Join-Path $backupStamp ".gitconfig"
       Name = ".gitconfig" },

    @{ Src  = (Join-Path $env:APPDATA "Code\User\settings.json")
       Dest = Join-Path $backupStamp "vscode-user-settings.json"
       Name = "VSCode user settings.json (AppData)" },

    @{ Src  = $script:DEV_SSH
       Dest = Join-Path $backupStamp "ssh"
       Name = "Cles SSH" }
)

foreach ($item in $backupItems) {
    if (-not (Test-Path $item.Src)) {
        Write-Info "Non trouve (ignore) : $($item.Name)"
        continue
    }
    if ((Get-Item $item.Src).PSIsContainer) {
        Copy-Item -Path $item.Src -Destination $item.Dest -Recurse -Force
    } else {
        Copy-Item -Path $item.Src -Destination $item.Dest -Force
    }
    Write-Success "Sauvegarde : $($item.Name)"
    Write-Log "Backed up: $($item.Src) -> $($item.Dest)"
}

$readmePath = Join-Path $backupStamp "README.txt"
@"
Sauvegarde cfg-setup
Date    : $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")
Machine : $env:COMPUTERNAME
User    : $env:USERNAME

Contenu :
  .gitconfig              - Configuration Git utilisateur
  settings.json           - Template settings VSCode (conf/)
  vscode-user-settings    - Settings VSCode actifs (AppData)
  user.ini                - Configuration d'installation
  links.ini               - URLs de telechargement
  ssh\                    - Cles SSH (CONFIDENTIEL)
"@ | Set-Content $readmePath -Encoding UTF8

Write-Info "README cree dans le backup."

Write-Step "Nettoyage des fichiers temporaires..."

if (Test-Path $script:TMP_DIR) {
    $size = (Get-ChildItem -Path $script:TMP_DIR -Recurse -File |
             Measure-Object -Property Length -Sum).Sum
    $sizeMB = [math]::Round($size / 1MB, 2)
    Remove-Item -Path $script:TMP_DIR -Recurse -Force
    Write-Success "Dossier temp supprime ($sizeMB Mo liberes) : $($script:TMP_DIR)"
    Write-Log "Cleaned up: $($script:TMP_DIR) ($sizeMB MB freed)"
} else {
    Write-Info "Aucun dossier temporaire a nettoyer."
}

Write-Host ""
Write-Host "  Vider la corbeille Windows ? " -NoNewline -ForegroundColor Yellow
Write-Host "y" -NoNewline -ForegroundColor Green
Write-Host "/" -NoNewline -ForegroundColor Gray
Write-Host "n ? " -NoNewline -ForegroundColor Red
$emptyBin = Read-Host
if ($emptyBin.Trim().ToLower() -eq "y") {
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Success "Corbeille videe."
}

Write-Host ""
Write-Host "  =================================================================" -ForegroundColor Cyan
Write-Host "  Backup disponible dans :" -ForegroundColor Cyan
Write-Host "    $backupStamp" -ForegroundColor White
Write-Host "  Log d'installation    :" -ForegroundColor Cyan
Write-Host "    $($script:LOG_FILE)" -ForegroundColor White
Write-Host "  =================================================================" -ForegroundColor Cyan
Write-Host ""

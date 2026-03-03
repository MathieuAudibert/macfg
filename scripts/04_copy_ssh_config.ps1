. "$PSScriptRoot\helpers.ps1"

Write-Header "ETAPE 4 : Copie des cles SSH vers ~/dev/config/ssh"

$sshSource = Join-Path $HOME ".ssh"
$sshDest   = $script:DEV_SSH

if (-not (Test-Path $sshSource)) {
    Write-Warn "Aucun dossier .ssh trouve dans $HOME"
    Write-Info "Vous pouvez generer une cle SSH avec la commande :"
    Write-Host ""
    Write-Host "       ssh-keygen -t ed25519 -C `"votre@email.com`"" -ForegroundColor DarkCyan
    Write-Host ""

    Write-Host "  Voulez-vous generer une cle SSH maintenant ? " -NoNewline -ForegroundColor Yellow
    Write-Host "y" -NoNewline -ForegroundColor Green
    Write-Host "/" -NoNewline -ForegroundColor Gray
    Write-Host "n ? "  -NoNewline -ForegroundColor Red
    $gen = Read-Host

    if ($gen.Trim().ToLower() -eq "y") {
        Write-Host "  Email pour la cle SSH : " -NoNewline -ForegroundColor Yellow
        $sshEmail = Read-Host

        $keyPath = Join-Path $sshSource "id_ed25519"
        ssh-keygen -t ed25519 -C $sshEmail -f $keyPath -N '""'
        Write-Success "Cle SSH generee : $keyPath"
        Write-Log "SSH key generated: $keyPath"
    } else {
        Write-Warn "Generation ignoree. Le dossier SSH sera vide."
        exit 0
    }
}

New-Item -ItemType Directory -Force -Path $sshDest | Out-Null
$sshFiles = Get-ChildItem -Path $sshSource -File

if ($sshFiles.Count -eq 0) {
    Write-Warn "Aucun fichier trouve dans $sshSource"
    exit 0
}

foreach ($file in $sshFiles) {
    $destFile = Join-Path $sshDest $file.Name
    Copy-Item -Path $file.FullName -Destination $destFile -Force
    Write-Success "Copie : $($file.Name)"
    Write-Log "SSH file copied: $($file.FullName) -> $destFile"
}

$acl = Get-Acl $sshDest
$acl.SetAccessRuleProtection($true, $false)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    $env:USERNAME, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
)
$acl.AddAccessRule($rule)
Set-Acl -Path $sshDest -AclObject $acl

Write-Host ""
Write-Success "Cles SSH sauvegardees dans : $sshDest"
Write-Warn "Ces fichiers sont sensibles. Ne les partagez pas."

$pubKey = Get-ChildItem -Path $sshDest -Filter "*.pub" | Select-Object -First 1
if ($pubKey) {
    Write-Step "Votre cle publique (a ajouter sur GitHub/GitLab) :"
    Write-Host ""
    Get-Content $pubKey.FullName | ForEach-Object {
        Write-Host "       $_" -ForegroundColor DarkCyan
    }
    Write-Host ""
}

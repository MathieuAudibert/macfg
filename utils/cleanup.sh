#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; GRAY='\033[0;37m'; NC='\033[0m'

log()     { echo -e "${CYAN}  >> $*${NC}"; }
success() { echo -e "${GREEN}  [OK] $*${NC}"; }
warn()    { echo -e "${YELLOW}  [!!] $*${NC}"; }
err()     { echo -e "${RED}  [KO] $*${NC}"; }

echo ""
echo -e "${CYAN}  ============================================================${NC}"
echo -e "${CYAN}  CLEANUP - cfg-setup (WSL Debian side)${NC}"
echo -e "${CYAN}  ============================================================${NC}"
echo ""

FREED=0

log "Suppression des paquets apt inutilises..."
sudo apt autoremove -y --purge 2>/dev/null && success "apt autoremove OK" || warn "apt autoremove: rien a faire"
sudo apt autoclean  -y         2>/dev/null && success "apt autoclean OK"  || warn "apt autoclean: rien a faire"

log "Nettoyage du cache apt..."
CACHE_SIZE=$(du -sh /var/cache/apt/archives/ 2>/dev/null | cut -f1 || echo "0")
sudo apt clean 2>/dev/null
success "Cache apt nettoye (etait : $CACHE_SIZE)"

TMP_DIRS=(
    "$HOME/.cache/pip"
    "$HOME/.cache/uv"
    "$HOME/.cargo/registry/cache"
    "/tmp/cfg-setup-install"
)

for d in "${TMP_DIRS[@]}"; do
    if [ -d "$d" ]; then
        SIZE=$(du -sh "$d" 2>/dev/null | cut -f1 || echo "?")
        rm -rf "$d"
        success "Supprime ($SIZE) : $d"
    else
        echo -e "  ${GRAY}Non present : $d${NC}"
    fi
done

DEV_CONFIG="$HOME/dev/config"
if [ -d "$DEV_CONFIG/backup" ]; then
    log "Suppression des backups de plus de 30 jours..."
    find "$DEV_CONFIG/backup" -maxdepth 1 -type d -mtime +30 | while read -r old; do
        rm -rf "$old"
        warn "Backup ancien supprime : $old"
    done
fi

echo ""
success "Nettoyage termine."
echo ""

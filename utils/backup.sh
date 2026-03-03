#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; GRAY='\033[0;37m'; NC='\033[0m'

log()     { echo -e "${CYAN}  >> $*${NC}"; }
success() { echo -e "${GREEN}  [OK] $*${NC}"; }
warn()    { echo -e "${YELLOW}  [!!] $*${NC}"; }
err()     { echo -e "${RED}  [KO] $*${NC}"; }

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DEV_CONFIG="$HOME/dev/config"
BACKUP_DIR="$DEV_CONFIG/backup/backup_$TIMESTAMP"

echo ""
echo -e "${CYAN}  ============================================================${NC}"
echo -e "${CYAN}  BACKUP - cfg-setup (WSL Debian side)${NC}"
echo -e "${CYAN}  ============================================================${NC}"
echo ""

mkdir -p "$BACKUP_DIR"

declare -A ITEMS=(
    ["$HOME/.gitconfig"]="$BACKUP_DIR/.gitconfig"
    ["$HOME/.ssh"]="$BACKUP_DIR/ssh"
    ["$HOME/.bashrc"]="$BACKUP_DIR/.bashrc"
    ["$HOME/.bash_profile"]="$BACKUP_DIR/.bash_profile"
    ["$HOME/.profile"]="$BACKUP_DIR/.profile"
)

for src in "${!ITEMS[@]}"; do
    dest="${ITEMS[$src]}"
    if [ ! -e "$src" ]; then
        warn "Non trouve (ignore) : $src"
        continue
    fi
    if [ -d "$src" ]; then
        cp -r "$src" "$dest"
    else
        cp "$src" "$dest"
    fi
    success "Sauvegarde : $(basename $src)"
done

# README du backup
cat > "$BACKUP_DIR/README.txt" << EOF
Sauvegarde cfg-setup (WSL Debian)
Date    : $(date "+%d/%m/%Y %H:%M:%S")
Machine : $(hostname)
User    : $USER

Contenu :
  .gitconfig     - Configuration Git
  ssh/           - Cles SSH (CONFIDENTIEL)
  .bashrc        - Configuration bash
  .bash_profile
  .profile
EOF

echo ""
success "Backup termine : $BACKUP_DIR"
echo ""

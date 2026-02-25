#!/bin/zsh

export RICH_FORCE_COLOR=1
export CLICOLOR_FORCE=1

# --- sanity check ---
if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <target> <username> <password>"
  exit 1
fi

TARGET="$1"
USER="$2"
PASS="$3"

# --- supported netexec protocols ---
protocols=(
  smb
  ldap
  winrm
  wmi
  rdp
  ssh
  ftp
  mssql
  nfs
  vnc
)

# Basic Mode
# --- iterate over protocols ---
for proto in "${protocols[@]}"; do
  echo
  echo "===== Testing $proto ====="
  netexec "$proto" "$TARGET" -u "$USER" -p "$PASS" 2>/dev/null
done

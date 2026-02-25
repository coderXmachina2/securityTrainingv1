#!/bin/zsh

INPUT="$1"
DOMAIN="$2"

if [[ -z "$INPUT" || ! -f "$INPUT" || -z "$DOMAIN" ]]; then
  echo "Usage: $0 <secretsdump.txt> <domain>"
  exit 1
fi

OUTDIR="parsed_secrets"
NTLM_DIR="$OUTDIR/ntlm"
KERB_DIR="$OUTDIR/kerberos"

mkdir -p "$NTLM_DIR" "$KERB_DIR"

echo "[*] Parsing secretsdump output: $INPUT"
echo "[*] Domain set to: $DOMAIN"

# --------------------------------------------------
# Canonicalise principal names
# Output format: DOMAIN-username
# --------------------------------------------------
sanitize_user() {
  local raw="$1"

  # Remove control chars, keep printable ASCII only
  raw=$(echo "$raw" | tr -cd '[:print:]')

  # Replace domain separators and slashes with dash
  raw=$(echo "$raw" | sed 's/[\\\/]/-/g')

  # Remove whitespace
  raw=$(echo "$raw" | sed 's/[[:space:]]//g')

  # Collapse multiple dashes
  raw=$(echo "$raw" | sed 's/-\{2,\}/-/g')

  # Trim leading/trailing dashes
  raw=$(echo "$raw" | sed 's/^-//; s/-$//')

  # Enforce DOMAIN-user format if domain missing
  if [[ "$raw" != ${DOMAIN}-* ]]; then
    raw="${DOMAIN}-${raw}"
  fi

  echo "$raw"
}

# -------------------
# NTLM hashes
# -------------------
grep '^[^:]*:[0-9]\+:' "$INPUT" | while IFS=: read -r user rid lm nt rest; do
  clean_user=$(sanitize_user "$user")
  outfile="$NTLM_DIR/${clean_user}.ntlm.hash"

  echo "${clean_user}:${rid}:${lm}:${nt}:::" > "$outfile"
  echo "[+] NTLM -> $outfile"
done

# -------------------
# Kerberos keys
# -------------------
grep -E ':(aes256|aes128|des-cbc-md5):' "$INPUT" \
  | while IFS=: read -r user etype hash; do
      clean_user=$(sanitize_user "$user")
      outfile="$KERB_DIR/${clean_user}.kerberos.keys"

      echo "${clean_user}:${etype}:${hash}" >> "$outfile"
    done

# -------------------
# Deduplicate Kerberos keys
# -------------------
for f in "$KERB_DIR"/*.kerberos.keys; do
  sort -u "$f" -o "$f"
done

echo "[+] Done. Clean output written to $OUTDIR/"

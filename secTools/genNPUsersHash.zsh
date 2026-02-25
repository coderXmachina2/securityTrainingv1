#!/bin/zsh

# Usage:
# ./NPUsersHash.zsh NPUsersHash.txt

INPUT="$1"

if [[ -z "$INPUT" || ! -f "$INPUT" ]]; then
  echo "Usage: $0 <GetNPUsers_output.txt>"
  exit 1
fi

# Extract only valid AS-REP hashes
HASH_LINES=$(grep '^\$krb5asrep\$23\$' "$INPUT")

if [[ -z "$HASH_LINES" ]]; then
  echo "[-] No valid AS-REP hashes found in input."
  exit 2
fi

echo "[+] AS-REP hashes detected. Processing..."

echo "$HASH_LINES" | while read -r line; do
  # Extract username between $23$ and @
  username=$(echo "$line" | awk -F'[$@]' '{print $4}')

  if [[ -z "$username" ]]; then
    echo "[!] Failed to extract username from line:"
    echo "$line"
    continue
  fi

  outfile="${username}.hash"

  echo "$line" > "$outfile"
  echo "[+] Wrote hash to $outfile"
done

echo "[+] Done."


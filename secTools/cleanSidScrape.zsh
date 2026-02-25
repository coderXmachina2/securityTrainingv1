#!/bin/zsh

# Usage:
# ./extract_users.zsh sidScrape.txt users.txt

INPUT="$1"
OUTPUT="$2"

if [[ -z "$INPUT" || -z "$OUTPUT" ]]; then
  echo "Usage: $0 <sidScrape.txt> <output.txt>"
  exit 1
fi

grep -E 'SidTypeUser' "$INPUT" \
| awk -F'\\\\| \\(' '{print $2}' \
| sort -u > "$OUTPUT"

echo "[+] Extracted $(wc -l < "$OUTPUT") usernames to $OUTPUT"

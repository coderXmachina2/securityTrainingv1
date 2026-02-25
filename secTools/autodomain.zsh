#!/bin/zsh

if [ -z "$1" ]; then
    echo "Usage: autodomain <target-ip>"
    exit 1
fi

target=$1
scanfile="scan_${target}.nmap"

echo "[*] Running nmap scan against $target..."
nmap -sC -sV -O -oN "$scanfile" "$target"

echo "[*] Extracting domain name from scan..."
rawdom=$(grep -i "389/tcp" "$scanfile" | grep -oP "(?<=\().+?(?=\))" | head -n 1)

if [ -z "$rawdom" ]; then
    echo "[!] Could not determine domain name from LDAP banner."
    echo "[!] Check $scanfile manually."
    exit 1
fi

dom=$(echo "$rawdom" \
    | sed 's/Domain://I' \
    | sed 's/,.*//' \
    | sed 's/[0-9]\+$//' \
    | sed 's/\.$//' \
    | xargs)

echo "[+] Found domain: $dom"

timestamp=$(date "+%Y-%m-%d %H:%M:%S")

if grep -q "$target" /etc/hosts; then
    echo "[!] Entry for $target already exists in /etc/hosts:"
    grep "$target" /etc/hosts
    exit 1
fi

echo "[*] Adding to /etc/hosts..."
echo "$target $dom   # added $timestamp" | sudo tee -a /etc/hosts >/dev/null

echo "[*] Updated /etc/hosts:"
grep "$target" /etc/hosts

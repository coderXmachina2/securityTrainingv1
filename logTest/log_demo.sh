#!/usr/bin/env bash

LOGFILE="authActivity.log"

echo "========================================"
echo " LOG ANALYSIS DEMO (grep | sed | awk)"
echo " File: $LOGFILE"
echo "========================================"
echo

########################################
echo "[1] Show failed login attempts"
echo "Command: grep \"Failed password\" $LOGFILE"
echo "----------------------------------------"
grep "Failed password" "$LOGFILE"
echo

########################################
echo "[2] Extract source IPs from failed logins using sed"
echo "Command: grep \"Failed password\" $LOGFILE | sed 's/.*from //' | sed 's/ port.*//'"
echo "----------------------------------------"
grep "Failed password" "$LOGFILE" \
  | sed 's/.*from //' \
  | sed 's/ port.*//'
echo

########################################
echo "[3] Count number of failed attempts per IP using awk"
echo "Command: grep \"Failed password\" $LOGFILE | awk '{print \$(NF-3)}' | sort | uniq -c | sort -nr"
echo "----------------------------------------"
grep "Failed password" "$LOGFILE" \
  | awk '{print $(NF-3)}' \
  | sort \
  | uniq -c \
  | sort -nr
echo

########################################
echo "[4] Show successful logins"
echo "Command: grep \"Accepted password\" $LOGFILE"
echo "----------------------------------------"
grep "Accepted password" "$LOGFILE"
echo

########################################
echo "[5] Search for activity from a specific IP (198.51.100.77)"
echo "Command: grep \"198.51.100.77\" $LOGFILE"
echo "----------------------------------------"
grep "198.51.100.77" "$LOGFILE"
echo

########################################
echo "[6] Show sudo usage (privilege escalation events)"
echo "Command: grep \"sudo\" $LOGFILE"
echo "----------------------------------------"
grep "sudo" "$LOGFILE"
echo

########################################
echo "[7] Anonymize IP addresses using sed"
echo "Command: sed 's/[0-9]\\+\\.[0-9]\\+\\.[0-9]\\+\\.[0-9]\\+/X.X.X.X/g' $LOGFILE | head"
echo "----------------------------------------"
sed 's/[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+/X.X.X.X/g' "$LOGFILE" | head
echo

########################################
echo "[8] Show IP and result field using awk (field-based parsing)"
echo "Command: awk '{print \$(NF-3), \$(NF-1)}' $LOGFILE"
echo "----------------------------------------"
awk '{print $(NF-3), $(NF-1)}' "$LOGFILE"
echo

########################################
echo "[9] Demonstrate text substitution with sed"
echo "Command: sed 's/root/admin/' example.txt"
echo "----------------------------------------"
echo "root logged in" > example.txt
sed 's/root/admin/' example.txt
rm example.txt
echo

########################################
echo "[10] Demonstrate awk column selection"
echo "Command: awk '{print \$1, \$3}' example.txt"
echo "----------------------------------------"
echo "alice pts/0 192.168.1.10" > example.txt
awk '{print $1, $3}' example.txt
rm example.txt
echo

########################################
echo "Demo complete."
echo "========================================"

#!/bin/bash
# JUDGE SYSTEM CHECKER - BNK DIGITAL
IP_PESERTA=$1

if [ -z "$IP_PESERTA" ]; then
    echo "❌ Masukkan IP Target, Khuh!"
    exit 1
fi

echo "--- 🛡️ MEMULAI AUDIT KEAMANAN PADA $IP_PESERTA ---"

# 1. SSH Check (User pisang)
# Mengetes apakah root dilarang (Good) dan pisang diizinkan
ssh_root=$(ssh -o BatchMode=yes -o ConnectTimeout=2 root@$IP_PESERTA 2>&1)
if [[ $ssh_root == *"Permission denied"* ]]; then
    echo "✅ SSH: Root login sudah ditutup."
else
    echo "❌ SSH: Root login MASIH TERBUKA!"
fi

# 2. FTP Check (Anonymous)
ftp_anon=$(curl --connect-timeout 2 ftp://$IP_PESERTA/ 2>&1)
if [[ $ftp_anon == *"Login denied"* || $ftp_anon == *"Authentication failed"* ]]; then
    echo "✅ FTP: Anonymous login sudah dimatikan."
else
    echo "❌ FTP: Anonymous login MASIH AKTIF!"
fi

# 3. Samba Check (User pisang & Guest)
# Cek apakah guest access ditolak (Good)
smb_guest=$(smbclient -L //$IP_PESERTA -N 2>&1)
if [[ $smb_guest == *"NT_STATUS_ACCESS_DENIED"* || $smb_guest == *"NT_STATUS_INVALID_PARAMETER"* ]]; then
    echo "✅ Samba: Guest access sudah ditutup."
else
    echo "❌ Samba: Guest access MASIH TERBUKA!"
fi

# 4. Web Recon Check (CSS & JS)
# Apakah flag/comment di file statis sudah dibersihkan?
check_css=$(curl -s http://$IP_PESERTA/style.css | grep -i "FLAG")
check_js=$(curl -s http://$IP_PESERTA/script.js | grep -i "FLAG")

if [ -z "$check_css" ] && [ -z "$check_js" ]; then
    echo "✅ Web Assets: Info Leakage (Flag di CSS/JS) sudah dibersihkan."
else
    echo "❌ Web Assets: Masih ada Flag/Comment bocor di CSS/JS!"
fi
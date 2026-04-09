#!/bin/bash

# ============================================================
# FLAG PROVISIONER: BNK DIGITAL LAB (Jury Standalone Edition)
# Gunakan script ini untuk menanam flag unik di setiap VM.
# ============================================================

# --- [ SECTION: JURI EDIT DI SINI ] ---
# Ganti nilai di bawah ini untuk setiap VM peserta yang berbeda.
PARTICIPANT_ID="PESERTA_01" 
VM_IP=$(hostname -I | awk '{print $1}')
VM_HOST=$(hostname)

# Konfigurasi Flag Unik
FLAG_SQLI="FLAG{SQLI_${PARTICIPANT_ID}_BYPASS}"
FLAG_IDOR="FLAG{IDOR_${PARTICIPANT_ID}_SULTAN}"
FLAG_LFI="FLAG{LFI_${PARTICIPANT_ID}_TRAVERSAL}"
FLAG_FTP="FLAG{FTP_${PARTICIPANT_ID}_ANONYMOUS}"
FLAG_SSH="FLAG{SSH_${PARTICIPANT_ID}_PRIVATE}"
FLAG_SMB="FLAG{SMB_${PARTICIPANT_ID}_GUEST}"

# Flag untuk Web Assets (JS/CSS)
FLAG_CONSOLE="FLAG{JS_LOG_${PARTICIPANT_ID}}"
FLAG_JS_BASE64=$(echo "FLAG{JS_B64_${PARTICIPANT_ID}}" | base64)
FLAG_CSS_PLAIN="FLAG{CSS_COMMENT_${PARTICIPANT_ID}}"
FLAG_CSS_HIDDEN="FLAG{CSS_HIDDEN_${PARTICIPANT_ID}}"
FLAG_CSS_ROT13=$(echo "$FLAG_CSS_HIDDEN" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
# --------------------------------------

WEB_PATH="/var/www/html"

if [ "$EUID" -ne 0 ]; then 
  echo "Jalankan pake sudo, Khuh!"
  exit
fi

echo "Memulai penanaman flag untuk: $PARTICIPANT_ID"

# 1. Flag Layanan
mkdir -p /var/ftp/pub /srv/samba/public
echo "$FLAG_FTP" > /var/ftp/pub/flag_ftp.txt
echo "$FLAG_SMB" > /srv/samba/public/flag_smb.txt
echo "$FLAG_SSH" > /home/pisang/flag_ssh.txt
chown ftp:ftp /var/ftp/pub/flag_ftp.txt
chown pisang:pisang /home/pisang/flag_ssh.txt

# 2. Flag Web Assets
if [ -f "$WEB_PATH/script.js" ] && [ -f "$WEB_PATH/style.css" ]; then
    sed -i "s/{{FLAG_CONSOLE}}/$FLAG_CONSOLE/g" $WEB_PATH/script.js
    sed -i "s/{{FLAG_JS_BASE64}}/$FLAG_JS_BASE64/g" $WEB_PATH/script.js
    sed -i "s/{{FLAG_CSS_COMMENT}}/$FLAG_CSS_PLAIN/g" $WEB_PATH/style.css
    sed -i "s/{{FLAG_CSS_ROT13}}/$FLAG_CSS_ROT13/g" $WEB_PATH/style.css
    echo "Web Assets Injected."
fi

# 3. Flag LFI (Path Traversal Target)
echo "$FLAG_LFI" > /var/www/flag_lfi.txt
chown www-data:www-data /var/www/flag_lfi.txt
chmod 644 /var/www/flag_lfi.txt

# 4. Flag Database (SQLi & IDOR)
mariadb -u root -e "
USE ctf_db;
UPDATE accounts SET flag_bonus = '$FLAG_SQLI' WHERE id = 1;
UPDATE accounts SET flag_bonus = '$FLAG_IDOR' WHERE id = 3;
"

echo "----------------------------------------------------"
echo "🎉 FLAG UNIK UNTUK $PARTICIPANT_ID BERHASIL DIPASANG!"
echo "----------------------------------------------------"
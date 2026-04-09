#!/bin/bash

# ============================================================
# FLAG PROVISIONER: BNK DIGITAL LAB
# Gunakan script ini untuk menanam flag unik di setiap VM
# ============================================================

# --- KONFIGURASI FLAG (Silakan Ganti Di Sini) ---
FLAG_FTP="FLAG{FTP_ANON_$(hostname)}"
FLAG_SMB="FLAG{SMB_GUEST_$(date +%s)}"
FLAG_SSH="FLAG{SSH_PW_$(hostname | rev)}"
FLAG_SQLI="FLAG{SQLI_BYPASS_BNK_SUCCESS}"
FLAG_IDOR="FLAG{Harta_Karun_Firaun_2026}"
# Update pada script set_flags.sh bagian Web
FLAG_CONSOLE="FLAG{CONSOLE_LOG_$(hostname)}"
FLAG_JS_BASE64=$(echo "FLAG{JS_BASE64_DECODE_SUCCESS}" | base64)
FLAG_JS_COMMENT="FLAG{JAVASCRIPT_INSPECTOR_GENERAL}"
# Update pada script set_flags.sh bagian CSS
FLAG_CSS_PLAIN="FLAG{CSS_SOURCE_COMMENT_FOUND}"
FLAG_CSS_HIDDEN="FLAG{CSS_HIDDEN_VAL_REVEALED}"

# Generate ROT13 secara otomatis
FLAG_CSS_ROT13=$(echo "$FLAG_CSS_HIDDEN" | tr 'A-Za-z' 'N-ZA-Mn-za-m')

WEB_PATH="/var/www/html"

# Pastikan dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then 
  echo "Jalankan pake sudo, Khuh!"
  exit
fi

echo "Menanam flag ke seluruh layanan"

# 1. Flag FTP (Layanan vsftpd)
mkdir -p /var/ftp/pub
echo "$FLAG_FTP" > /var/ftp/pub/flag_ftp.txt
chown ftp:ftp /var/ftp/pub/flag_ftp.txt
echo "FTP Flag planted."

# 2. Flag Samba (Layanan SMB)
mkdir -p /srv/samba/public
echo "$FLAG_SMB" > /srv/samba/public/flag_smb.txt
chmod 644 /srv/samba/public/flag_smb.txt
echo "Samba Flag planted."

# 3. Flag SSH (User Home)
echo "$FLAG_SSH" > /home/pisang/flag_ssh.txt
chown pisang:pisang /home/pisang/flag_ssh.txt
echo "SSH Flag planted."

# 4. Flag Web Assets (Inject ke CSS & JS)
# Menggunakan 'sed' untuk mengganti placeholder dengan flag asli
# Proses Injeksi
sed -i "s/{{FLAG_CONSOLE}}/$FLAG_CONSOLE/g" $WEB_PATH/script.js
sed -i "s/{{FLAG_JS_BASE64}}/$FLAG_JS_BASE64/g" $WEB_PATH/script.js
sed -i "s/{{FLAG_JS_COMMENT}}/$FLAG_JS_COMMENT/g" $WEB_PATH/script.js
echo "JS Flags injected."

# Proses Injeksi ke style.css
sed -i "s/{{FLAG_CSS_COMMENT}}/$FLAG_CSS_PLAIN/g" $WEB_PATH/style.css
sed -i "s/{{FLAG_CSS_ROT13}}/$FLAG_CSS_ROT13/g" $WEB_PATH/style.css

echo "CSS Flags (Plain & ROT13) injected."

# 5. Flag Database (SQLi & IDOR)
# Script ini langsung masuk ke MariaDB dan update isinya
echo "Mengupdate flag di Database"
mariadb -u root -e "
USE ctf_db;
-- Update Flag SQLi
UPDATE secret_stuff SET flag_value = '$FLAG_SQLI' WHERE flag_name = 'SQLI_FLAG';
-- Update Flag IDOR (Akun Sultan ID 3)
UPDATE accounts SET flag_bonus = '$FLAG_IDOR' WHERE id = 3;
"
echo "Database Flags updated."

echo "----------------------------------------------------"
echo "🎉 SEMUA FLAG BERHASIL DIPASANG!"
echo "----------------------------------------------------"
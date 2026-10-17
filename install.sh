#!/bin/bash
# ============================================================
# SCRIPT AUTO-DEPLOY: BANK NASIONAL DIGITAL LAB
# Target: Debian 13 / DietPi / Ubuntu Server
# ============================================================

if [ "$EUID" -ne 0 ]; then 
  echo "GAGAL: Tolong jalankan sebagai root (gunakan sudo)"
  exit 1
fi

echo "[*] Memulai Instalasi Lab BNK Digital..."

# 1. Update & Install Dependencies
echo "[*] Menginstall layanan (Apache, PHP, MariaDB, FTP, SSH, Samba)..."
apt update && apt install -y apache2 php libapache2-mod-php mariadb-server vsftpd openssh-server samba sudo php-mysql

# 2. Setup Web Files & Permission
echo "[*] Menyiapkan file web di /var/www/html/..."
rm -rf /var/www/html/*
cp -r ./web/* /var/www/html/
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/

# 3. Setup Database (Pastikan database.sql sudah memiliki ID 999 untuk Flag 3)
echo "[*] Menyiapkan database ctf_db..."
mariadb -u root < ./setup/database.sql

# 4. Setup Layanan File (FTP & Samba) + FLAG 1 & 2
echo "[*] Mengkonfigurasi layanan FTP dan Samba..."
cp ./setup/service_configs/vsftpd.conf /etc/vsftpd.conf
mkdir -p /var/ftp/pub
echo "FLAG{FTP_ANONYMOUS_LOGIN_DETECTED}" > /var/ftp/pub/flag_ftp.txt
chown ftp:ftp /var/ftp/pub/flag_ftp.txt

cp ./setup/service_configs/smb.conf /etc/samba/smb.conf
mkdir -p /srv/samba/public
echo "FLAG{SAMBA_GUEST_SHARE_EXPOSED}" > /srv/samba/public/flag_smb.txt
chmod -R 777 /srv/samba/public

# 5. Setup Skenario LFI (Target Traversal & Kebocoran SSH) + FLAG 4
echo "[*] Membangun skenario LFI di sistem..."
echo "FLAG{LFI_B4se64_Tr4v3rsal_M4st3r}" > /etc/bnk_secret.conf
echo "[FATAL] 2026-10-17 10:00:01 - DB Auth Failed. System fallback using cleartext credentials (pisang:rebus)" > /var/log/bnk_debug.log
chmod 644 /etc/bnk_secret.conf /var/log/bnk_debug.log

# 6. Pembuatan User 'pisang' untuk SSH (Foothold)
echo "[*] Membuat user 'pisang'..."
useradd -m -s /bin/bash pisang
echo "pisang:rebus" | chpasswd
# Menyamakan akses ke Samba untuk mengecoh/memperkaya enumerasi
(echo "rebus"; echo "rebus") | smbpasswd -s -a pisang

# 7. Setup Privilege Escalation (Sudo Bypass) & FLAG 5
echo "[*] Membangun jalur eskalasi hak akses (GTFOBins) & Root Flag..."
echo "FLAG{BNK_D1g1t4l_Fulloy_Pwn3d_R00T}" > /root/root.txt
chmod 600 /root/root.txt
# Memberikan hak akses sudo tanpa password untuk program 'less' kepada user pisang
echo "pisang ALL=(root) NOPASSWD: /usr/bin/less" > /etc/sudoers.d/pisang_ctf
chmod 0440 /etc/sudoers.d/pisang_ctf

# 8. Restart Semua Layanan
echo "[*] Merestart dan menyimpan perubahan layanan..."
systemctl restart apache2 mariadb vsftpd ssh smbd

echo "----------------------------------------------------"
echo "LAB Bank Nasional Digital (5 FLAG) BERHASIL DI-DEPLOY!"
echo "IP Server VM saat ini: $(hostname -I | awk '{print $1}')"
echo "Silakan ujicoba serangan dari mesin Linux Anda."
echo "----------------------------------------------------"

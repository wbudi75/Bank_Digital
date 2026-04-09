#!/bin/bash

# ============================================================
# SCRIPT AUTO-DEPLOY: BNK DIGITAL LAB
# Author: Kukuh
# Target: Debian-based System (LXD/VM)
# ============================================================

# Pastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then 
  echo "Tolong jalankan sebagai root (pake sudo ya)"
  exit
fi

echo "Memulai Instalasi Lab BNK Digital..."

# 1. Update & Install Dependencies
echo "Menginstall layanan (Apache, PHP, MariaDB, FTP, SSH, Samba)"
apt update && apt install -y apache2 php libapache2-mod-php mariadb-server vsftpd openssh-server samba php-mysql

# 2. Setup Web Files
echo "Menyiapkan file web di /var/www/html/"
# Copy file lab 
cp -r ./web/* /var/www/html/

# Atur izin akses
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/

# 3. Setup Database
echo "Menyiapkan database ctf_db"
# Menjalankan script SQL yang udah lo buat
mariadb -u root < ./setup/database.sql
# Pastikan user dbuser punya akses (opsional kalau sudah ada di .sql)
mariadb -u root -e "GRANT ALL PRIVILEGES ON ctf_db.* TO 'dbuser'@'localhost' IDENTIFIED BY 'dbpass'; FLUSH PRIVILEGES;"

# 4. Setup Layanan Sistem (Vulnerable Configs)
echo "Menerapkan konfigurasi layanan"

# FTP
cp ./setup/service_configs/vsftpd.conf /etc/vsftpd.conf
mkdir -p /var/ftp/pub
echo "FLAG{FTP_ANONYMOUS_LOGIN_DETECTED}" > /var/ftp/pub/flag_ftp.txt
chown ftp:ftp /var/ftp/pub/flag_ftp.txt

# SSH
cp ./setup/service_configs/sshd_config /etc/ssh/sshd_config

# Samba
cp ./setup/service_configs/smb.conf /etc/samba/smb.conf
mkdir -p /srv/samba/public
echo "FLAG{SAMBA_GUEST_SHARE_EXPOSED}" > /srv/samba/public/flag_smb.txt
chmod -R 777 /srv/samba/public

# 5. Buat User 'pisang' untuk SSH & Samba
echo "Membuat user 'pisang'"
useradd -m -s /bin/bash pisang
echo "pisang:rebus" | chpasswd
# Daftarkan ke Samba (password 'rebus' juga biar sinkron)
(echo "rebus"; echo "rebus") | smbpasswd -s -a pisang

# 6. Restart Semua Layanan
echo "Merestart semua layanan"
systemctl restart apache2 mariadb vsftpd ssh smbd

echo "----------------------------------------------------"
echo "LAB BNK DIGITAL BERHASIL DI-DEPLOY!"
echo "IP Server: $(hostname -I | awk '{print $1}')"
echo "Selamat Nge-hack, Khuh!"
echo "----------------------------------------------------"
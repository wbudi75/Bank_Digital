# BNK Digital: Vulnerable Lab & Hardening Simulation

Laboratorium simulasi keamanan "Bank Nasional Kukuh" (BNK Digital) yang dirancang untuk melatih kemampuan **Offensive** (Penetrasi) dan **Defensive** (Hardening) pada infrastruktur server Linux.

## Skenario Lab
Sebuah bank digital baru saja meluncurkan layanannya. Namun, karena terburu-buru, banyak celah keamanan yang tertinggal di level aplikasi web dan layanan sistem (FTP, SSH, Samba).

**Tujuan:** Temukan 11 Flag (Total 1.000 Poin) dan lakukan perbaikan (hardening) pada sistem.

## Stack Teknologi
- **OS:** Debian 12
- **Web:** PHP 8.x, Apache2
- **Database:** MariaDB/MySQL
- **Services:** OpenSSH, vsftpd, Samba

## Daftar Vulnerability & Flag
| Kategori    | Teknik        | Deskripsi Singkat                                      | Poin |
| :--------   | :------       | :----------------                                      | :--- |
| **Web**     | SQL Injection | Bypass login via `' OR 1=1 #`                          | 100  |
| **Web**     | LFI           | Akses file sistem via parameter `?page=`               | 100  |
| **Web**     | IDOR          | Manipulasi `?id=` di dashboard untuk intip saldo orang | 150  |
| **Network** | FTP Anon      | Login tanpa password pada port 21                      | 100  |
| **Network** | SMB Guest     | Akses folder share publik tanpa autentikasi            | 100  |
| **Recon**   | Info Leak     | Flag tersembunyi di CSS, JS, dan Console Log           | 250  |

---

## Panduan Hardening (Defense)
Bagian ini menjelaskan bagaimana memperbaiki celah yang ditemukan:

### 1. Web Security
- **SQLi:**  Mengimplementasikan *Prepared Statements* pada `login.php`.
- **LFI:** Menerapkan *Allow-list* (Whitelisting) pada file yang boleh di-include.
- **IDOR:** Validasi `session_id` agar user hanya bisa mengakses data miliknya sendiri.

### 2. System Hardening
- **SSH:** Mematikan `PermitRootLogin`, membatasi `MaxAuthTries`, dan menggunakan `AllowUsers`.
- **FTP:** Menonaktifkan `anonymous_enable` di `vsftpd.conf`.
- **Samba:** Menghapus `map to guest` dan mewajibkan autentikasi user.

---

## Cara Deployment
1. git clone https://github.com/username-kamu/BNK-Digital-Lab.git
2. cd BNK-Digital-Lab
3. chmod +x install.sh
   sudo ./install.sh
4. chmod +x ./setup/set_flags.sh
   sudo ./setup/set_flags.sh
5. Pastikan semua service (Apache, MariaDB, SSH, FTP, Samba) berjalan.

## Lingkungan Kerja (Compatibility)
Lab ini telah diuji dan berjalan lancar pada:
* **OS:** Debian 12
* **Virtualisasi:** Proxmox, LXD/Incus
* **Hardware:** Minimal RAM 2GB, 1 Core CPU 

### Catatan Khusus VirtualBox:
Gunakan **Bridged Adapter** agar IP mesin lab dapat diakses oleh mesin penyerang (Kali Linux).

**Author:** Budi
**License:** MIT
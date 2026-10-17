# Bank Nasional Digital (BND): Vulnerable Lab untuk Penetration Testing

Laboratorium simulasi keamanan "Bank Nasional Digital" (BND) yang dirancang khusus untuk melatih kemampuan **Offensive (Penetrasi)** pada aplikasi web dan infrastruktur server Linux tingkat pemula.

**Catatan:** Lab ini murni dirancang untuk eksploitasi (*Vulnerable by Design*).

## Skenario Lab
Sebuah bank digital baru saja meluncurkan layanannya. Namun, karena kurangnya pemahaman *developer* mengenai *secure coding* dan konfigurasi sistem, banyak celah keamanan kritikal yang tertinggal.

**Tujuan Peserta:** Lakukan *Reconnaissance*, temukan kerentanan pada layanan jaringan, bobol aplikasi web bank, dan lakukan eskalasi hak akses (*Privilege Escalation*) untuk mendapatkan akses *Root*. Terdapat **5 Flag** tersembunyi yang harus ditemukan.

## Stack Teknologi & Environment
- **OS Target:** Debian 13 / DietPi / Ubuntu Server
- **Web Server:** Apache2, PHP 8.x
- **Database:** MariaDB
- **Layanan Lain:** OpenSSH, vsftpd, Samba

## Daftar Vulnerability (Kill Chain)
| Tahapan     | Kerentanan / Teknik  | Deskripsi Eksploitasi                                                      |
| :--------   | :------------------- | :------------------------------------------------------------------------- |
| **Network** | FTP Anonymous        | Akses layanan FTP (Port 21) tanpa *password*                               |
| **Network** | SMB Guest Share      | Eksplorasi folder *share* publik SMB                                       |
| **Web**     | IDOR                 | Manipulasi parameter `?id=` di *dashboard* untuk mengintip rekening sultan |
| **Web**     | SQL Injection        | *Authentication Bypass* (`' OR 1=1 #`) pada form *login*                   |
| **System**  | Privilege Escalation | *Bypass* Sudo menggunakan GTFOBins (`less`) untuk menjadi *Root*           |

---

## Cara Deployment (Satu Langkah)
Lab ini dirancang agar dapat di-*deploy* secara otomatis di dalam mesin virtual Linux Anda yang masih bersih.

1. `git clone https://github.com/wbudi75/Bank_Digital.git`
2. `cd Bank_Digital`
3. `chmod +x install.sh`
4. `sudo ./install.sh`

Setelah instalasi selesai, akses IP dari VM Target melalui peramban (browser) mesin penyerang (Kali Linux/Parrot/Pop!_OS).

## Kredensial Awal (Starting Point)
Untuk memulai simulasi *pentest* realistis, peserta dapat menggunakan kredensial legal berikut:
- **Login Web Nasabah:** Username `BND02` | Password `pwd02`
- **Login SSH Target (Foothold):** Username `pisang` | Password `rebus`

## Lingkungan Kerja (Compatibility)
Lab ini sangat ringan dan dapat dijalankan di ekosistem berikut:
* **Virtualisasi:** VirtualBox, LXD/Incus, Proxmox VE
* **Spesifikasi Minimal:** 1 Core CPU, RAM 512MB - 1GB (Disarankan menggunakan OS DietPi/Debian 13/Ubuntu Server Minimal).
* **Catatan Jaringan:** Jika menggunakan VirtualBox, atur Network ke **Bridged Adapter** atau **Host-Only Adapter** agar IP VM dapat dijangkau oleh mesin penyerang.

---
**Author:** Kukuh  
**License:** MIT

-- ==========================================================
-- DATABASE SETUP: BNK DIGITAL (CTF LAB)
-- Author: Kukuh
-- ==========================================================

-- 1. Buat Database
CREATE DATABASE IF NOT EXISTS ctf_db;
USE ctf_db;

-- 2. Hapus tabel lama jika ada (biar bersih pas deploy ulang)
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS users;

-- 3. Struktur Tabel Users (Untuk Login)
CREATE TABLE users (
    id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL
);

-- Isi Data User
-- admin: buat tes login normal
-- pisang: pintu masuk utama peserta
INSERT INTO users (id, username, password) VALUES 
(1, 'pisang', 'rebus'),
(2, 'admin', '4dm1n');

-- 4. Struktur Tabel Accounts (Untuk Skenario IDOR & Saldo)
CREATE TABLE accounts (
    id INT PRIMARY KEY,
    user_id INT,
    account_number VARCHAR(20),
    full_name VARCHAR(50),
    balance DECIMAL(15, 2),
    flag_bonus VARCHAR(100)
);

-- Isi Data Rekening Nasabah
-- ID 1: Akun milik peserta (Pisang)
-- ID 2: Akun nasabah lain (Fulan)
-- ID 3: Akun target (Sultan) yang nyimpen FLAG
INSERT INTO accounts (id, user_id, account_number, full_name, balance, flag_bonus) VALUES 
(1, 1, '11223344', 'Pisang Rebus', 500000.00, ''),
(2, 2, '99887766', 'Fulan Hartono', 150000000.00, ''),
(3, 3, '55443322', 'Sultan Firaun', 900000000.00, 'FLAG{Harta_Karun_Firaun}');

-- 5. Tambahan: Tabel Rahasia (Opsional buat SQLi Manual)
-- Buat peserta yang nggak mau lewat login tapi mau lari ke tabel lain via UNION SELECT
CREATE TABLE IF NOT EXISTS secret_stuff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    flag_name VARCHAR(50),
    flag_value VARCHAR(100)
);

INSERT INTO secret_stuff (flag_name, flag_value) VALUES 
('SQLI_FLAG', 'FLAG{SQLI_BYPASS_BNK_SUCCESS}');
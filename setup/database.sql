-- ==========================================================
-- DATABASE SETUP: BND
-- Author: Kukuh 
-- ==========================================================

-- 1. Inisialisasi Database
CREATE DATABASE IF NOT EXISTS ctf_db;
USE ctf_db;

-- 2. Bersihkan Tabel Lama
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS system_config;

-- 3. Struktur Tabel Accounts
CREATE TABLE accounts (
    id VARCHAR(20) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
    account_number VARCHAR(20),
    full_name VARCHAR(50),
    balance DECIMAL(15, 2),
    flag_bonus VARCHAR(100)
);

-- 4. Pengisian Data Nasabah & Admin
-- Urutan 1: admin (Agar payload ' OR 1=1 # langsung menangkap baris ini)
-- Urutan 2: BND01 (Nasabah biasa)
-- Urutan 3: BND02 (Titik awal peserta)
-- Urutan 4: BND03 (Target IDOR)
INSERT INTO accounts (id, password, account_number, full_name, balance, flag_bonus) VALUES 
('admin', 'p4ssw0rd', '00000000', 'Administrator System', 0.00, 'FLAG{SQLi_Auth_Byp4ss_0wn3d}'),
('BND01', 'pwd01', '10000001', 'Kukuh Kameswara', 15000000.00, ''),
('BND02', 'pwd02', '10000002', 'Agista Broker', 500000000.00, ''),
('BND03', 'pwd03', '99999999', 'Sultan Firaun', 9000000000.00, 'FLAG{IDOR_Sult4n_B0nuz}');

-- 5. Pembuatan User Database
GRANT ALL PRIVILEGES ON ctf_db.* TO 'dbuser'@'localhost' IDENTIFIED BY 'dbpass';
FLUSH PRIVILEGES;

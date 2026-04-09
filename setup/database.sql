-- ==========================================================
-- DATABASE SETUP: BNK DIGITAL (CTF LAB)
-- Author: Budi | Version: 2.0 
-- ==========================================================

-- 1. Inisialisasi Database
CREATE DATABASE IF NOT EXISTS ctf_db;
USE ctf_db;

-- 2. Bersihkan Tabel Lama
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS users;

-- 3. Struktur Tabel Users (Untuk Autentikasi Login)
CREATE TABLE users (
    id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL
);

-- Admin di ID 1 agar kena bypass ' OR 1=1 #
-- Pisang di ID 2 sebagai akses legal pertama peserta
INSERT INTO users (id, username, password) VALUES 
(1, 'admin', '4dm1nk03'),
(2, 'pisang', 'rebus');

-- 4. Struktur Tabel Accounts (Untuk Dashboard & Skenario IDOR)
CREATE TABLE accounts (
    id INT PRIMARY KEY,
    account_number VARCHAR(20),
    full_name VARCHAR(50),
    balance DECIMAL(15, 2),
    flag_bonus VARCHAR(100)
);

-- Pengisian Data Rekening Nasabah
-- ID 1: Administrator (Target SQLi Bypass)
-- ID 2: Pisang Rebus (Akun milik peserta)
-- ID 3: Sultan Firaun (Target IDOR)
INSERT INTO accounts (id, account_number, full_name, balance, flag_bonus) VALUES 
(1, '00000000', 'Administrator System', 0.00, 'PLACEHOLDER_SQLI'),
(2, '11223344', 'Pisang Rebus', 500000.00, ''),
(3, '55443322', 'Sultan Firaun', 900000000.00, 'PLACEHOLDER_IDOR');
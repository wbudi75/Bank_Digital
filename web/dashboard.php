<?php
mysqli_report(MYSQLI_REPORT_OFF);
$conn = new mysqli("localhost", "dbuser", "dbpass", "ctf_db");

if ($conn->connect_error) {
    die("Koneksi Database Gagal: " . $conn->connect_error);
}

$id = isset($_GET['id']) ? $_GET['id'] : '';
$password = isset($_GET['password']) ? $_GET['password'] : '';

// [!] VULNERABLE SQL QUERY
$sql = "SELECT id, account_number, full_name, balance, flag_bonus FROM accounts WHERE id = '$id' AND password = '$password'";

$result = @$conn->query($sql);
$row = $result ? $result->fetch_assoc() : null;
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | BNK Digital</title>
    <style>
        body { background-color: #f8fafc; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; }
        
        /* Navbar Styling */
        .navbar { background-color: #ffffff; padding: 1rem 3rem; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .brand-name { font-size: 1.5rem; font-weight: 800; color: #0284c7; letter-spacing: 0.5px; }
        .nav-links { list-style: none; margin: 0; padding: 0; }
        .nav-links li a { text-decoration: none; color: #ef4444; font-weight: 600; padding: 0.5rem 1.2rem; border: 1px solid #ef4444; border-radius: 6px; transition: all 0.2s; }
        .nav-links li a:hover { background-color: #ef4444; color: #ffffff; }

        /* Dashboard Content */
        .dashboard-container { max-width: 800px; margin: 3rem auto; padding: 2.5rem; background: #ffffff; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.08); border-top: 4px solid #0284c7; }
        .welcome-header { border-bottom: 2px solid #f1f5f9; padding-bottom: 1.5rem; margin-bottom: 2rem; }
        .welcome-header h2 { color: #0f172a; margin-top: 0; margin-bottom: 0.5rem; font-size: 1.8rem; }
        .status-text { color: #64748b; margin: 0; font-size: 0.95rem; }
        
        /* Data Box */
        .account-details { display: flex; justify-content: space-between; background: #f8fafc; padding: 2rem; border-radius: 8px; margin-bottom: 1.5rem; border: 1px solid #e2e8f0; }
        .detail-box h4 { color: #64748b; font-size: 0.85rem; margin-top: 0; margin-bottom: 0.5rem; text-transform: uppercase; letter-spacing: 1px; }
        .detail-box p { font-size: 1.5rem; font-weight: 700; color: #334155; margin: 0; }
        .balance { color: #16a34a !important; font-size: 1.8rem !important; }
        
        /* Message Boxes */
        .error-msg { color: #b91c1c; background: #fef2f2; padding: 1.5rem; border-radius: 8px; border: 1px solid #fca5a5; text-align: center; font-size: 1.1rem; }
        .flag-box { margin-top: 1.5rem; padding: 1.5rem; background: #fffbeb; border: 1px dashed #f59e0b; border-radius: 8px; color: #b45309; font-family: 'Courier New', Courier, monospace; font-size: 1.1rem; }
        
        .back-link { display: inline-block; margin-top: 1.5rem; color: #0284c7; text-decoration: none; font-weight: 600; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <!-- Navbar dengan Tombol Keluar -->
    <nav class="navbar">
        <div class="logo-container">
            <span class="brand-name">BNK Digital</span>
        </div>
        <ul class="nav-links">
            <li><a href="index.html">Keluar</a></li>
        </ul>
    </nav>

    <div class="dashboard-container">
        <?php if ($row): ?>
            <div class="welcome-header">
                <h2>Selamat Datang, <?php echo htmlspecialchars($row['full_name']); ?></h2>
                <p class="status-text">Status Akun: Aktif</p>
            </div>
            
            <div class="account-details">
                <div class="detail-box">
                    <h4>Nomor Rekening</h4>
                    <p><?php echo htmlspecialchars($row['account_number']); ?></p>
                </div>
                <div class="detail-box" style="text-align: right;">
                    <h4>Saldo Tersedia</h4>
                    <p class="balance">Rp <?php echo number_format($row['balance'], 2, ',', '.'); ?></p>
                </div>
            </div>

            <?php if (!empty($row['flag_bonus'])): ?>
                <div class="flag-box">
                    <strong>Catatan Sistem:</strong><br><br>
                    <?php echo htmlspecialchars($row['flag_bonus']); ?>
                </div>
            <?php endif; ?>

        <?php else: ?>
            <div class="error-msg">
                <strong>Autentikasi Gagal:</strong> Kredensial yang Anda masukkan tidak valid.
            </div>
            <div style="text-align: center;">
                <a href="index.html" class="back-link">&larr; Kembali ke Halaman Login</a>
            </div>
        <?php endif; ?>
    </div>
</body>
</html>

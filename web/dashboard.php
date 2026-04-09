<?php
$conn = mysqli_connect("localhost", "dbuser", "dbpass", "ctf_db");

// --- CELAH IDOR ---
// Sistem cuma ambil ID dari URL (?id=...) tanpa validasi session
$user_id = $_GET['id'];
$query = "SELECT * FROM accounts WHERE user_id = '$user_id'";
$result = mysqli_query($conn, $query);
$data = mysqli_fetch_assoc($result);
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <title>Dashboard | BNK Digital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="bg-light">
    <nav class="navbar navbar-dark p-3">
        <div class="container"><span class="navbar-brand fw-bold">BNK Dashboard</span></div>
    </nav>

    <div class="container mt-5">
        <div class="card shadow p-4">
            <h4>Selamat Datang, <span class="text-primary"><?php echo $data['full_name']; ?></span></h4>
            <hr>
            <div class="row">
                <div class="col-md-6">
                    <p class="text-muted mb-0">Nomor Rekening</p>
                    <h5><?php echo $data['account_number']; ?></h5>
                </div>
                <div class="col-md-6 text-end">
                    <p class="text-muted mb-0">Saldo Tersedia</p>
                    <h3 class="text-success">Rp <?php echo number_format($data['balance'], 0, ',', '.'); ?></h3>
                </div>
            </div>
            <div class="alert alert-info mt-3">
                <strong>Catatan Rahasia:</strong> <?php echo $data['flag_bonus']; ?>
            </div>
        </div>

        <div class="mt-4 text-center">
            <p>Bukan akun Anda? <a href="login.php">Keluar</a></p>
        </div>
    </div>
</body>
</html>
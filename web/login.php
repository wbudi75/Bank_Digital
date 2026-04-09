<?php
// Mulai session buat nyimpen data login
session_start();

// Konfigurasi Database
$host = "localhost";
$user_db = "dbuser";
$pass_db = "dbpass";
$name_db = "ctf_db";

$conn = mysqli_connect($host, $user_db, $pass_db, $name_db);

// Cek koneksi biar nggak Error 500 tanpa alasan
if (!$conn) {
    die("Koneksi Database Gagal: " . mysqli_connect_error());
}

$error_msg = "";

if (isset($_POST['login'])) {
    // SQL Injection SEDERHANA 
    $user = $_POST['username'];
    $pass = $_POST['password'];

    // Query nyari user
    $sql = "SELECT id, username FROM users WHERE username = '$user' AND password = '$pass'";
    $result = mysqli_query($conn, $sql);

    if ($result && mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        
        // Simpan ID ke session (buat bahan hardening nanti)
        $_SESSION['user_id'] = $row['id'];
        $_SESSION['username'] = $row['username'];

        // LEMPAR KE DASHBOARD (Skenario IDOR dimulai di sini)
        header("Location: dashboard.php?id=" . $row['id']);
        exit();
    } else {
        $error_msg = "Username atau Password salah.";
    }
}
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Bank Nasional Kukuh Digital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <style>
        body { background: #001a33; display: flex; align-items: center; justify-content: center; min-height: 100vh; margin: 0; }
        .login-card { border: none; border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.5); width: 100%; max-width: 400px; padding: 40px; background: #fff; }
        .btn-bank { background-color: #003366; color: white; font-weight: bold; }
        .btn-bank:hover { background-color: #002244; color: #ffc107; }
        .bank-logo { color: #003366; font-size: 2rem; font-weight: bold; text-align: center; margin-bottom: 20px; }
    </small></style>
</head>
<body>

<div class="login-card">
    <div class="bank-logo">BNK <span class="text-warning">Digital</span></div>
    <h5 class="text-center text-muted mb-4">Akses Internet Banking</h5>

    <?php if ($error_msg): ?>
        <div class="alert alert-danger p-2 small text-center"><?php echo $error_msg; ?></div>
    <?php endif; ?>

    <?php if ($success_msg): ?>
        <div class="alert alert-success p-3 text-center"><?php echo $success_msg; ?></div>
    <?php endif; ?>

    <form method="POST">
        <div class="mb-3">
            <label class="form-label small fw-bold">Username / ID Pengguna</label>
            <input type="text" name="username" class="form-control" placeholder="Masukkan ID" required>
        </div>
        <div class="mb-3">
            <label class="form-label small fw-bold">Password / PIN</label>
            <input type="password" name="password" class="form-control" placeholder="******" required>
        </div>
        <div class="d-grid mt-4">
            <button type="submit" name="login" class="btn btn-bank">LOGIN MASUK</button>
        </div>
    </form>

    <div class="text-center mt-4">
        <a href="index.php" class="text-decoration-none small text-muted">&larr; Kembali ke Beranda</a>
    </div>
</div>

</body>
</html>
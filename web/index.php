<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bank Nasional Kukuh | Layanan Digital Terpercaya</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.php">BNK <span class="text-warning">Digital</span></a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link active" href="index.php">Home</a></li>
                    <li class="nav-item"><a class="nav-link text-warning" href="login.php"><strong>Internet Banking</strong></a></li>
                    <li class="nav-item"><a class="nav-link" href="?page=about.php">Tentang Kami</a></li>
                    <li class="nav-item"><a class="nav-link" href="?page=contact.php">Hubungi Kami</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <?php
    // --- CELAH LFI (Local File Inclusion) ---
    if (isset($_GET['page'])) {
        echo "<div class='container mt-5 bg-white p-5 shadow rounded'>";
        $file = $_GET['page'];
        // Peserta harus sadar kalau ini bolong!
        if (file_exists($file) || strpos($file, '..') !== false) {
            include($file);
        } else {
            echo "<div class='alert alert-danger text-center'><h4>Error 404</h4>Halaman tidak ditemukan di server BNK.</div>";
        }
        echo "</div>";
    } else {
    ?>
        <header class="hero-section text-center text-white">
            <div class="container">
                <h1 class="display-4 fw-bold">Keamanan Anda, Prioritas Kami.</h1>
                <p class="lead">Solusi perbankan digital masa kini dengan sistem proteksi berlapis AI.</p>
                <div class="mt-4">
                    <a href="login.php" class="btn btn-warning btn-lg px-5 fw-bold shadow">Login Member</a>
                    <a href="#fitur" class="btn btn-outline-light btn-lg px-5 ms-2">Pelajari Lebih Lanjut</a>
                </div>
            </div>
        </header>

        <div id="fitur" class="container mt-5">
            <div class="row text-center">
                <div class="col-md-4 mb-4">
                    <div class="card card-feature p-4">
                        <h4 class="text-primary fw-bold">Transfer Instan</h4>
                        <p>Kirim dana ke mana saja tanpa batas waktu. Aman dan terenkripsi.</p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card card-feature p-4">
                        <h4 class="text-primary fw-bold">E-Wallet</h4>
                        <p>Integrasi lancar dengan berbagai dompet digital favorit Anda.</p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card card-feature p-4">
                        <h4 class="text-primary fw-bold">Smart Security</h4>
                        <p>Dipantau 24/7 oleh sistem keamanan siber tingkat tinggi.</p>
                    </div>
                </div>
            </div>
        </div>
    <?php } ?>

    <footer class="text-center text-white py-4 mt-5">
        <div class="container">
            <p class="mb-0">&copy; 2026 Bank Nasional Kukuh. Terdaftar & Diawasi oleh Jaringan Keamanan CTF.</p>
            <small class="text-muted">Security Version: 1.0.4-stable</small>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="script.js"></script>
</body>
</html>
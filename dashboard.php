<?php
session_start();
if (!isset($_SESSION['user'])) {
    header("Location: login.php");
    exit();
}

include 'koneksi.php';

$user = $_SESSION['user'];
$id_user = $user['id_user'];
$nama = $user['nama'];
$username = $user['username'];

// Generate QR Code otomatis (kecuali admin)
if ($username !== 'admin') {
    require_once 'generate_qr.php';
    generate_user_qr($id_user, $username, $koneksi);
}

// Ambil semua peran user
$roles = [];

if ($username === 'admin') {
    $roles[] = 'admin';
} else {
    $result_roles = $koneksi->query("SELECT peran FROM peran WHERE id_user = $id_user");
    while ($r = $result_roles->fetch_assoc()) {
        $roles[] = $r['peran'];
    }
}

$is_admin = in_array('admin', $roles);
$is_panitia = in_array('panitia', $roles);
$can_manage = $is_admin || $is_panitia;

// Data ringkasan (jika panitia/admin)
if ($can_manage) {
    $total_warga = $koneksi->query("SELECT COUNT(*) as total FROM peran WHERE peran = 'warga'")->fetch_assoc()['total'];
    $total_panitia = $koneksi->query("SELECT COUNT(*) as total FROM peran WHERE peran = 'panitia'")->fetch_assoc()['total'];
    $total_berqurban = $koneksi->query("SELECT COUNT(*) as total FROM peran WHERE peran = 'berqurban'")->fetch_assoc()['total'];

    $total_masuk = $koneksi->query("SELECT SUM(jumlah) as total FROM transaksi_keuangan WHERE tipe = 'masuk'")->fetch_assoc()['total'] ?? 0;
    $total_keluar = $koneksi->query("SELECT SUM(jumlah) as total FROM transaksi_keuangan WHERE tipe = 'keluar'")->fetch_assoc()['total'] ?? 0;
    $sisa_saldo = $total_masuk - $total_keluar;
}
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | Qurban</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center">
        <h3>Halo, <?= htmlspecialchars($nama) ?></h3>
        <a href="login.php" class="btn btn-danger">Logout</a>
    </div>
    <hr>

    <div class="alert alert-secondary">
        <strong>Peran Anda:</strong> <?= implode(', ', $roles) ?>
    </div>

    <?php if ($is_admin): ?>
    <!-- TAMPILAN ADMIN -->
    <div class="alert alert-info">
        <strong>Selamat datang, Admin! Anda memiliki akses penuh untuk mengelola sistem.</strong>
    </div>

    <!-- Menu Admin -->
    <div class="row g-4">
        <div class="col-md-3">
            <div class="card p-3 text-center shadow-sm">
                <h5>Warga</h5>
                <p class="fs-4"><?= $total_warga ?></p>
                <a href="warga.php" class="btn btn-sm btn-primary">Data Warga</a>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 text-center shadow-sm">
                <h5>Panitia</h5>
                <p class="fs-4"><?= $total_panitia ?></p>
                <a href="panitia.php" class="btn btn-sm btn-primary">Data Panitia</a>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 text-center shadow-sm">
                <h5>Berqurban</h5>
                <p class="fs-4"><?= $total_berqurban ?></p>
                <a href="qurban.php" class="btn btn-sm btn-primary">Data Qurban</a>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-3 text-center shadow-sm">
                <h5>Saldo</h5>
                <p>Masuk: Rp <?= number_format($total_masuk) ?></p>
                <p>Keluar: Rp <?= number_format($total_keluar) ?></p>
                <strong>Sisa: Rp <?= number_format($sisa_saldo) ?></strong>
            </div>
        </div>
    </div>
    <div class="row mb-4">
        <h5>Manajemen Data</h5>
        <div class="col-md-6"><a href="transaksi.php" class="btn btn-outline-success w-100">Transaksi</a></div>
        <div class="col-md-6    "><a href="pengambilan.php" class="btn btn-outline-info w-100">Distribusi Daging</a></div>
    </div>

    <hr>
    <?php elseif ($is_panitia): ?>
    <!-- Panitia: Tampilkan Manajemen Data -->
    <!-- Admin: Hapus Data Warga pada Manajemen Data -->
    <div class="row mb-4">
        <h5>Manajemen Data</h5>
        <div class="col-md-6"><a href="transaksi.php" class="btn btn-outline-success w-100">Transaksi</a></div>
        <div class="col-md-6"><a href="pengambilan.php" class="btn btn-outline-info w-100">Distribusi Daging</a></div>
    </div>
    <?php endif; ?>

    <!-- TAMPILAN QR UNTUK SEMUA PERAN (ADMIN & LAINNYA) -->
    <hr>
    <h4>QR Code Pengambilan Daging</h4>

    <?php
        $sql = "SELECT pd.qrcode_token, pd.status, p.peran,
                pd.jumlah_daging 
                FROM pengambilan_daging pd
                INNER JOIN peran p ON pd.id_peran = p.id_peran
                WHERE p.id_user = ? AND pd.status = 'Belum Diambil'";
        $stmt = $koneksi->prepare($sql);
        $stmt->bind_param("i", $id_user);
        $stmt->execute();
        $res = $stmt->get_result();

        if ($res->num_rows > 0):
    ?>
        <div class="row">
            <?php while ($data_qr = $res->fetch_assoc()): 
                $token = $data_qr['qrcode_token'];
                if (!$token) continue;
                $url = "asset/qrcode/img/qr_" . $username . "_" . $data_qr['peran'] . ".png";  // Pastikan nama file sesuai peran
            ?>
            <div class="col-md-4">
                <div class="card p-3 text-center shadow-sm">
                    <p>Peran: <?= $data_qr['peran'] ?></p>
                    <p>Daging: <?= $data_qr['jumlah_daging'] ?> Kg</p>
                    <img src="<?= $url ?>" alt="QR Code">
                    <a href="<?= $url ?>" class="btn btn-sm btn-primary mt-2" download="qr_<?= $data_qr['peran'] ?>_<?= $username ?>.png">Unduh QR</a>
                </div>
            </div>
            <?php endwhile; ?>
        </div>
    <?php else: ?>
        <div class="alert alert-warning">QR Code tidak ditemukan untuk akun ini.</div>
    <?php endif; ?>
</div>
</body>
</html>

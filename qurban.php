<?php
session_start();
include 'koneksi.php';

if (!isset($_SESSION['user'])) {
    header("Location: login.php");
    exit();
}

$user = $_SESSION['user'];
$roles = $user['role'];
$is_admin = in_array('admin', $roles);

// Hanya admin yang bisa mengakses
if (!$is_admin) {
    echo "<div style='padding:20px'><h4>Akses ditolak. Halaman ini hanya untuk admin dan panitia.</h4></div>";
    exit();
}

// Tambah berqurban
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['tambah'])) {
    $nik = $_POST['nik'];
    // Cek apakah sudah jadi berqurban
    $cek = $koneksi->prepare("SELECT 1 FROM peran WHERE nik = ? AND peran = 'berqurban' LIMIT 1");
    $cek->bind_param("s", $nik);
    $cek->execute();
    $cek->store_result();
    if ($cek->num_rows == 0) {
        $stmt = $koneksi->prepare("INSERT INTO peran (nik, peran) VALUES (?, 'berqurban')");
        $stmt->bind_param("s", $nik);
        $stmt->execute();
    }
    header("Location: qurban.php");
    exit();
}

// Hapus berqurban
if (isset($_GET['hapus']) && $is_admin) {
    $id_peran = intval($_GET['hapus']);
    // Hapus data pada pengambilan_daging yang memiliki id_peran yang sama
    $koneksi->query("DELETE FROM pengambilan_daging WHERE id_peran = $id_peran");
    // Hapus data pada peran
    $koneksi->query("DELETE FROM peran WHERE id_peran = $id_peran AND peran = 'berqurban'");
    header("Location: qurban.php");
    exit();
}

// Ambil data berqurban
$sql = "SELECT p.id_peran, w.nik, w.nama, w.asal, w.pekerjaan, p.peran
        FROM peran p
        INNER JOIN warga w ON p.nik = w.nik
        WHERE p.peran = 'berqurban'
        ORDER BY w.nama ASC";
$result = $koneksi->query($sql);

// Ambil semua warga yang belum jadi berqurban (untuk pilihan tambah)
$warga_sql = "SELECT w.nik, w.nama 
                FROM warga w
                WHERE w.nik NOT IN (
                    SELECT p.nik FROM peran p WHERE p.peran = 'berqurban'
                )
                AND w.nik NOT IN (
                    SELECT p.nik FROM peran p WHERE p.peran = 'admin'
                )
                ORDER BY w.nama ASC";
$warga_result = $koneksi->query($warga_sql);
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Data Berqurban</title>
    <link href="css/bootstrap.css" media="all" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center">
        <h3>Daftar Warga Berqurban</h3>
        <a href="dashboard.php" class="btn btn-secondary">Kembali</a>
    </div>
    <hr>

    <!-- Form Tambah Berqurban -->
    <div class="card mb-4">
        <div class="card-header">Tambah Warga Berqurban</div>
        <div class="card-body">
            <form method="post">
                <div class="row align-items-end">
                    <div class="col-md-8">
                        <label for="nik" class="form-label">Pilih Warga</label>
                        <select name="nik" id="nik" class="form-select" required>
                            <option value="">-- Pilih Warga --</option>
                            <?php while ($w = $warga_result->fetch_assoc()): ?>
                                <option value="<?= $w['nik'] ?>"><?= htmlspecialchars($w['nama']) ?> (<?= $w['nik'] ?>)</option>
                            <?php endwhile; ?>
                        </select>
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" name="tambah" class="btn btn-success w-100 mt-3 mt-md-0">Tambah Berqurban</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Tabel Berqurban -->
    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>No</th>
                <th>NIK</th>
                <th>Nama</th>
                <th>Asal</th>
                <th>Pekerjaan</th>
                <th>Peran</th>
                <?php if ($is_admin): ?>
                <th>Aksi</th>
                <?php endif; ?>
            </tr>
        </thead>
        <tbody>
            <?php if ($result->num_rows > 0): ?>
                <?php $no = 1; while ($row = $result->fetch_assoc()): ?>
                <tr>
                    <td><?= $no++ ?></td>
                    <td><?= htmlspecialchars($row['nik']) ?></td>
                    <td><?= htmlspecialchars($row['nama']) ?></td>
                    <td><?= htmlspecialchars($row['asal']) ?></td>
                    <td><?= htmlspecialchars($row['pekerjaan']) ?></td>
                    <td><?= htmlspecialchars($row['peran']) ?></td>
                    <?php if ($is_admin): ?>
                    <td>
                        <a href="qurban.php?hapus=<?= $row['id_peran'] ?>" class="btn btn-sm btn-danger" onclick="return confirm('Yakin hapus data ini?')">Hapus</a>
                    </td>
                    <?php endif; ?>
                </tr>
                <?php endwhile; ?>
            <?php else: ?>
                <tr><td colspan="<?= $is_admin ? 7 : 6 ?>" class="text-center">Belum ada data berqurban.</td></tr>
            <?php endif; ?>
        </tbody>
    </table>
</div>
</body>
</html>
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

// Hanya admin & panitia yang bisa mengakses
if (!$is_admin) {
    echo "<div style='padding:20px'><h4>Akses ditolak. Halaman ini hanya untuk admin dan panitia.</h4></div>";
    exit();
}

// Tambah berqurban
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['tambah'])) {
    $nik = $_POST['nik'];
    // Cari id_user dari nik
    $stmt = $koneksi->prepare("SELECT id_user FROM user WHERE nik = ?");
    $stmt->bind_param("s", $nik);
    $stmt->execute();
    $res = $stmt->get_result();
    if ($res->num_rows > 0) {
        $id_user = $res->fetch_assoc()['id_user'];
        // Cek apakah sudah jadi berqurban
        $cek = $koneksi->query("SELECT * FROM peran WHERE id_user=$id_user AND peran='berqurban'");
        if ($cek->num_rows == 0) {
            $koneksi->query("INSERT INTO peran (id_user, peran) VALUES ($id_user, 'berqurban')");
        }
    }
    header("Location: qurban.php");
    exit();
}

// Hapus berqurban
if (isset($_GET['hapus']) && $is_admin) {
    $id_peran = intval($_GET['hapus']);
    $koneksi->query("DELETE FROM peran WHERE id_peran=$id_peran AND peran='berqurban'");
    header("Location: qurban.php");
    exit();
}

// Ambil data berqurban
$sql = "SELECT p.id_peran, w.nik, w.nama, w.asal, w.pekerjaan, p.peran
        FROM peran p
        INNER JOIN user u ON p.id_user = u.id_user
        INNER JOIN warga w ON u.nik = w.nik
        WHERE p.peran = 'berqurban'
        ORDER BY w.nama ASC";
$result = $koneksi->query($sql);

// Ambil semua warga yang belum jadi berqurban (untuk pilihan tambah)
$warga_sql = "SELECT w.nik, w.nama FROM warga w
              INNER JOIN user u ON w.nik = u.nik
              WHERE w.nik NOT IN (
                SELECT u2.nik FROM peran p2
                INNER JOIN user u2 ON p2.id_user = u2.id_user
                WHERE p2.peran = 'berqurban'
              )
              ORDER BY w.nama ASC";
$warga_result = $koneksi->query($warga_sql);
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Data Berqurban</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center">
        <h3>Daftar Warga Berqurban</h3>
        <a href="dashboard.php" class="btn btn-secondary">Kembali</a>
    </div>
    <hr>

    <!-- Form Tambah Berqurban -->
    <!-- <div class="card mb-4">
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
    </div> -->

    <!-- Tabel Berqurban -->
    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>No</th>
                <th>NIK</th>
                <th>Nama</th>
                <th>asal</th>
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
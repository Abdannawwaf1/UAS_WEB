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

// Handle aksi tambah, edit, hapus
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Tambah warga
    if (isset($_POST['tambah'])) {
        $nik = $_POST['nik'];
        $nama = $_POST['nama'];
        $asal = $_POST['asal'];
        $pekerjaan = $_POST['pekerjaan'];
        $stmt = $koneksi->prepare("INSERT INTO warga (nik, nama, asal, pekerjaan) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("ssss", $nik, $nama, $asal, $pekerjaan);
        $stmt->execute();
        header("Location: warga.php");
        exit();
    }
    // Edit warga
    if (isset($_POST['edit'])) {
        $nik = $_POST['nik'];
        $nama = $_POST['nama'];
        $asal = $_POST['asal'];
        $pekerjaan = $_POST['pekerjaan'];
        $stmt = $koneksi->prepare("UPDATE warga SET nama=?, asal=?, pekerjaan=? WHERE nik=?");
        $stmt->bind_param("ssss", $nama, $asal, $pekerjaan, $nik);
        $stmt->execute();
        header("Location: warga.php");
        exit();
    }
}

// Hapus warga
if (isset($_GET['hapus']) && $is_admin) {
    $nik = intval($_GET['hapus']);
    // Hapus relasi di tabel user dan peran terlebih dahulu jika ada
    $koneksi->query("DELETE FROM user WHERE nik=$nik");
    $koneksi->query("DELETE FROM warga WHERE nik=$nik");
    header("Location: warga.php");
    exit();
}

// Ambil data warga
$sql = "SELECT * FROM warga ORDER BY nama ASC";
$result = $koneksi->query($sql);

// Untuk edit, ambil data warga yang dipilih
$edit_warga = null;
if (isset($_GET['edit']) && $is_admin) {
    $nik_edit = intval($_GET['edit']);
    $res_edit = $koneksi->query("SELECT * FROM warga WHERE nik=$nik_edit");
    if ($res_edit->num_rows > 0) {
        $edit_warga = $res_edit->fetch_assoc();
    }
}
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Data Warga</title>
    <link href="css/bootstrap.css" media="all" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center">
        <h3>Daftar Warga</h3>
        <a href="dashboard.php" class="btn btn-secondary">Kembali</a>
    </div>
    <hr>

    <?php if ($is_admin): ?>
    <!-- Form Tambah/Edit Warga -->
    <div class="card mb-4">
        <div class="card-header"><?= $edit_warga ? 'Edit Warga' : 'Tambah Warga' ?></div>
        <div class="card-body">
            <form method="post">
                <div class="row mb-2">
                    <div class="col-md-3">
                        <label>NIK</label>
                        <input type="number" name="nik" class="form-control" required value="<?= $edit_warga ? $edit_warga['nik'] : '' ?>" <?= $edit_warga ? 'readonly' : '' ?>>
                    </div>
                    <div class="col-md-3">
                        <label>Nama</label>
                        <input type="text" name="nama" class="form-control" required value="<?= $edit_warga ? htmlspecialchars($edit_warga['nama']) : '' ?>">
                    </div>
                    <div class="col-md-3">
                        <label>Asal</label>
                        <input type="text" name="asal" class="form-control" value="<?= $edit_warga ? htmlspecialchars($edit_warga['asal']) : '' ?>">
                    </div>
                    <div class="col-md-3">
                        <label>Pekerjaan</label>
                        <input type="text" name="pekerjaan" class="form-control" value="<?= $edit_warga ? htmlspecialchars($edit_warga['pekerjaan']) : '' ?>">
                    </div>
                </div>
                <button type="submit" name="<?= $edit_warga ? 'edit' : 'tambah' ?>" class="btn btn-success">
                    <?= $edit_warga ? 'Simpan Perubahan' : 'Tambah' ?>
                </button>
                <?php if ($edit_warga): ?>
                    <a href="warga.php" class="btn btn-secondary">Batal</a>
                <?php endif; ?>
            </form>
        </div>
    </div>
    <?php endif; ?>

    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>No</th>
                <th>NIK</th>
                <th>Nama</th>
                <th>Asal</th>
                <th>Pekerjaan</th>
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
                    <?php if ($is_admin): ?>
                    <td>
                        <a href="warga.php?edit=<?= $row['nik'] ?>" class="btn btn-sm btn-warning">Edit</a>
                        <a href="warga.php?hapus=<?= $row['nik'] ?>" class="btn btn-sm btn-danger" onclick="return confirm('Yakin hapus data?')">Hapus</a>
                    </td>
                    <?php endif; ?>
                </tr>
                <?php endwhile; ?>
            <?php else: ?>
                <tr><td colspan="<?= $is_admin ? 6 : 5 ?>" class="text-center">Tidak ada data warga.</td></tr>
            <?php endif; ?>
        </tbody>
    </table>
</div>
</body>
</html>

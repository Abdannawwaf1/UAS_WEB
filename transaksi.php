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
$is_panitia = in_array('panitia', $roles);

// Hanya admin & panitia yang bisa mengakses
if (!$is_admin && !$is_panitia) {
    echo "<div style='padding:20px'><h4>Akses ditolak. Halaman ini hanya untuk admin dan panitia.</h4></div>";
    exit();
}

// Tambah transaksi
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['tambah'])) {
    $nik = $_POST['nik'];
    $tanggal = $_POST['tanggal'];
    $keterangan = $_POST['keterangan'];
    $tipe = $_POST['tipe'];
    $jumlah = $_POST['jumlah'];

    $stmt = $koneksi->prepare("INSERT INTO transaksi_keuangan (nik, tanggal, keterangan, tipe, jumlah) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssi", $nik, $tanggal, $keterangan, $tipe, $jumlah);
    $stmt->execute();
    header("Location: transaksi.php");
    exit();
}

// Edit transaksi
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['edit'])) {
    $id_transaksi = $_POST['id_transaksi'];
    $nik = $_POST['nik'];
    $tanggal = $_POST['tanggal'];
    $keterangan = $_POST['keterangan'];
    $tipe = $_POST['tipe'];
    $jumlah = $_POST['jumlah'];

    $stmt = $koneksi->prepare("UPDATE transaksi_keuangan SET nik=?, tanggal=?, keterangan=?, tipe=?, jumlah=? WHERE id_transaksi=?");
    $stmt->bind_param("ssssii", $nik, $tanggal, $keterangan, $tipe, $jumlah, $id_transaksi);
    $stmt->execute();
    header("Location: transaksi.php");
    exit();
}

// Hapus transaksi
if (isset($_GET['hapus']) && ($is_admin || $is_panitia)) {
    $id_transaksi = intval($_GET['hapus']);
    $koneksi->query("DELETE FROM transaksi_keuangan WHERE id_transaksi=$id_transaksi");
    header("Location: transaksi.php");
    exit();
}

// Ambil data transaksi (join ke warga untuk dapat nama)
$sql = "SELECT t.*, w.nama FROM transaksi_keuangan t
        LEFT JOIN warga w ON t.nik = w.nik
        ORDER BY t.tanggal DESC, t.id_transaksi DESC";
$result = $koneksi->query($sql);

// Ambil semua warga untuk pilihan NIK
$warga_result = $koneksi->query("SELECT nik, nama FROM warga ORDER BY nama ASC");

// Untuk edit, ambil data transaksi yang dipilih
$edit_transaksi = null;
if (isset($_GET['edit']) && ($is_admin || $is_panitia)) {
    $id_edit = intval($_GET['edit']);
    $res_edit = $koneksi->query("SELECT * FROM transaksi_keuangan WHERE id_transaksi=$id_edit");
    if ($res_edit->num_rows > 0) {
        $edit_transaksi = $res_edit->fetch_assoc();
    }
}
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Data Transaksi Keuangan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center">
        <h3>Data Transaksi Keuangan</h3>
        <a href="dashboard.php" class="btn btn-secondary">Kembali</a>
    </div>
    <hr>

    <!-- Form Tambah/Edit Transaksi -->
    <div class="card mb-4">
        <div class="card-header"><?= $edit_transaksi ? 'Edit Transaksi' : 'Tambah Transaksi' ?></div>
        <div class="card-body">
            <form method="post">
                <?php if ($edit_transaksi): ?>
                    <input type="hidden" name="id_transaksi" value="<?= $edit_transaksi['id_transaksi'] ?>">
                <?php endif; ?>
                <div class="row mb-2">
                    <div class="col-md-2">
                        <label for="nik">Nama Warga</label>
                        <select name="nik" id="nik" class="form-select" required>
                            <option value="">-- Pilih Warga --</option>
                            <?php
                            // Reset pointer jika edit
                            if ($edit_transaksi) $warga_result->data_seek(0);
                            while ($w = $warga_result->fetch_assoc()): ?>
                                <option value="<?= $w['nik'] ?>" <?= ($edit_transaksi && $edit_transaksi['nik'] == $w['nik']) ? 'selected' : '' ?>>
                                    <?= htmlspecialchars($w['nama']) ?> (<?= $w['nik'] ?>)
                                </option>
                            <?php endwhile; ?>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label for="tanggal">Tanggal</label>
                        <input type="date" name="tanggal" class="form-control" required value="<?= $edit_transaksi ? $edit_transaksi['tanggal'] : '' ?>">
                    </div>
                    <div class="col-md-3">
                        <label for="keterangan">Keterangan</label>
                        <input type="text" name="keterangan" class="form-control" required value="<?= $edit_transaksi ? htmlspecialchars($edit_transaksi['keterangan']) : '' ?>">
                    </div>
                    <div class="col-md-2">
                        <label for="tipe">Tipe</label>
                        <select name="tipe" class="form-select" required>
                            <option value="masuk" <?= ($edit_transaksi && $edit_transaksi['tipe'] == 'masuk') ? 'selected' : '' ?>>Masuk</option>
                            <option value="keluar" <?= ($edit_transaksi && $edit_transaksi['tipe'] == 'keluar') ? 'selected' : '' ?>>Keluar</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label for="jumlah">Jumlah</label>
                        <input type="number" name="jumlah" class="form-control" required value="<?= $edit_transaksi ? $edit_transaksi['jumlah'] : '' ?>">
                    </div>
                    <div class="col-md-1 d-flex align-items-end">
                        <button type="submit" name="<?= $edit_transaksi ? 'edit' : 'tambah' ?>" class="btn btn-success w-100">
                            <?= $edit_transaksi ? 'Simpan' : 'Tambah' ?>
                        </button>
                    </div>
                    <?php if ($edit_transaksi): ?>
                        <div class="col-md-12 mt-2">
                            <a href="transaksi.php" class="btn btn-secondary btn-sm">Batal Edit</a>
                        </div>
                    <?php endif; ?>
                </div>
            </form>
        </div>
    </div>

    <!-- Tabel Transaksi -->
    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>No</th>
                <th>Nama Warga</th>
                <th>Tanggal</th>
                <th>Keterangan</th>
                <th>Tipe</th>
                <th>Jumlah</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            <?php if ($result->num_rows > 0): ?>
                <?php $no = 1; while ($row = $result->fetch_assoc()): ?>
                <tr>
                    <td><?= $no++ ?></td>
                    <td><?= htmlspecialchars($row['nama']) ?></td>
                    <td><?= htmlspecialchars($row['tanggal']) ?></td>
                    <td><?= htmlspecialchars($row['keterangan']) ?></td>
                    <td><?= htmlspecialchars($row['tipe']) ?></td>
                    <td><?= number_format($row['jumlah']) ?></td>
                    <td>
                        <a href="transaksi.php?edit=<?= $row['id_transaksi'] ?>" class="btn btn-sm btn-warning">Edit</a>
                        <a href="transaksi.php?hapus=<?= $row['id_transaksi'] ?>" class="btn btn-sm btn-danger" onclick="return confirm('Yakin hapus transaksi ini?')">Hapus</a>
                    </td>
                </tr>
                <?php endwhile; ?>
            <?php else: ?>
                <tr><td colspan="7" class="text-center">Tidak ada data transaksi.</td></tr>
            <?php endif; ?>
        </tbody>
    </table>
</div>
</body>
</html>
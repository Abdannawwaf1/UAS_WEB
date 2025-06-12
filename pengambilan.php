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

// Proses pencarian
$cari_token = isset($_GET['cari_token']) ? trim($_GET['cari_token']) : '';

// Edit pengambilan
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['edit'])) {
    $id_pengambilan = $_POST['id_pengambilan'];
    $jumlah_daging = $_POST['jumlah_daging'];
    $status = $_POST['status'];
    $qrcode_token = $_POST['qrcode_token'];
    $stmt = $koneksi->prepare("UPDATE pengambilan_daging SET jumlah_daging=?, status=?, qrcode_token=? WHERE id_pengambilan=?");
    $stmt->bind_param("dssi", $jumlah_daging, $status, $qrcode_token, $id_pengambilan);
    $stmt->execute();
    header("Location: pengambilan.php");
    exit();
}

// Hapus pengambilan
if (isset($_GET['hapus']) && ($is_admin || $is_panitia)) {
    $id_pengambilan = intval($_GET['hapus']);
    $koneksi->query("DELETE FROM pengambilan_daging WHERE id_pengambilan=$id_pengambilan");
    header("Location: pengambilan.php");
    exit();
}

// Ambil data pengambilan (join ke peran untuk dapat nama peran)
$where = "";
$params = [];
if ($cari_token !== "") {
    $where = "WHERE pd.qrcode_token LIKE ?";
    $params[] = "%$cari_token%";
}
$sql = "SELECT pd.*, p.peran 
        FROM pengambilan_daging pd
        INNER JOIN peran p ON pd.id_peran = p.id_peran
        $where
        ORDER BY pd.id_pengambilan DESC";
$stmt = $koneksi->prepare($sql);
if ($where !== "") {
    $stmt->bind_param("s", $params[0]);
}
$stmt->execute();
$result = $stmt->get_result();

// Untuk edit, ambil data pengambilan yang dipilih
$edit_pengambilan = null;
if (isset($_GET['edit']) && ($is_admin || $is_panitia)) {
    $id_edit = intval($_GET['edit']);
    $res_edit = $koneksi->query("SELECT pd.*, p.peran FROM pengambilan_daging pd INNER JOIN peran p ON pd.id_peran = p.id_peran WHERE pd.id_pengambilan=$id_edit");
    if ($res_edit->num_rows > 0) {
        $edit_pengambilan = $res_edit->fetch_assoc();
    }
}
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Data Pengambilan Daging</title>
    <link href="css/bootstrap.css" media="all" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center">
        <h3>Data Pengambilan Daging</h3>
        <a href="dashboard.php" class="btn btn-secondary">Kembali</a>
    </div>
    <hr>

    <!-- Form Cari Token -->
    <form method="get" class="mb-3">
        <div class="row g-2 align-items-center">
            <div class="col-md-8">
                <input type="text" name="cari_token" class="form-control" placeholder="Cari QR Code Token..." value="<?= htmlspecialchars($cari_token) ?>">
            </div>
            <div class="col-md-2">
                <button class="btn btn-primary w-100" type="submit">Cari</button>
            </div>
            <?php if ($cari_token !== ""): ?>
            <div class="col-md-2">
                <a href="pengambilan.php" class="btn btn-secondary w-100">Reset</a>
            </div>
            <?php endif; ?>
        </div>
    </form>

    <!-- Form Edit Pengambilan -->
    <?php if ($edit_pengambilan): ?>
    <div class="card mb-4">
        <div class="card-header">Edit Pengambilan Daging</div>
        <div class="card-body">
            <form method="post">
                <input type="hidden" name="id_pengambilan" value="<?= $edit_pengambilan['id_pengambilan'] ?>">
                <div class="row mb-2">
                    <div class="col-md-3">
                        <label>Peran</label>
                        <input type="text" class="form-control" value="<?= htmlspecialchars($edit_pengambilan['peran']) ?>" readonly>
                    </div>
                    <div class="col-md-3">
                        <label>Jumlah Daging (kg)</label>
                        <input type="number" step="0.01" name="jumlah_daging" class="form-control" required value="<?= $edit_pengambilan['jumlah_daging'] ?>">
                    </div>
                    <div class="col-md-3">
                        <label>Status</label>
                        <select name="status" class="form-select" required>
                            <option value="Belum Diambil" <?= $edit_pengambilan['status'] == 'Belum Diambil' ? 'selected' : '' ?>>Belum Diambil</option>
                            <option value="Sudah Diambil" <?= $edit_pengambilan['status'] == 'Sudah Diambil' ? 'selected' : '' ?>>Sudah Diambil</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label>QR Code Token</label>
                        <input type="text" name="qrcode_token" class="form-control" required value="<?= htmlspecialchars($edit_pengambilan['qrcode_token']) ?>">
                    </div>
                </div>
                <button type="submit" name="edit" class="btn btn-success">Simpan Perubahan</button>
                <a href="pengambilan.php" class="btn btn-secondary">Batal</a>
            </form>
        </div>
    </div>
    <?php endif; ?>

    <!-- Tabel Pengambilan Daging -->
    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>No</th>
                <th>Peran</th>
                <th>Jumlah Daging (kg)</th>
                <th>Status</th>
                <th>QR Code Token</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            <?php if ($result->num_rows > 0): ?>
                <?php $no = 1; while ($row = $result->fetch_assoc()): ?>
                <tr>
                    <td><?= $no++ ?></td>
                    <td><?= htmlspecialchars($row['peran']) ?></td>
                    <td><?= htmlspecialchars($row['jumlah_daging']) ?></td>
                    <td><?= htmlspecialchars($row['status']) ?></td>
                    <td><?= htmlspecialchars($row['qrcode_token']) ?></td>
                    <td>
                        <a href="pengambilan.php?edit=<?= $row['id_pengambilan'] ?>" class="btn btn-sm btn-warning">Edit</a>
                        <a href="pengambilan.php?hapus=<?= $row['id_pengambilan'] ?>" class="btn btn-sm btn-danger" onclick="return confirm('Yakin hapus data ini?')">Hapus</a>
                    </td>
                </tr>
                <?php endwhile; ?>
            <?php else: ?>
                <tr><td colspan="6" class="text-center">Tidak ada data pengambilan daging.</td></tr>
            <?php endif; ?>
        </tbody>
    </table>
</div>
</body>
</html>
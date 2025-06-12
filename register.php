<?php
session_start();
include 'koneksi.php';

$warga_result = $koneksi->query("SELECT w.nik, w.nama FROM warga w LEFT JOIN user u ON u.nik = w.nik WHERE u.nik IS NULL ORDER BY w.nama ASC");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nik = $_POST['nik'];
    $password = $_POST['password'];
    // Cek apakah NIK sudah terdaftar
    $cek = $koneksi->prepare("SELECT nik FROM user WHERE nik = ?");
    $cek->bind_param("s", $nik);
    $cek->execute();
    $cek->store_result();
    if ($cek->num_rows > 0) {
        $error = "NIK sudah terdaftar.";
    } else {
        // Tambah ke tabel user
        $stmt = $koneksi->prepare("INSERT INTO user (nik, password) VALUES (?, ?)");
        $stmt->bind_param("ss", $nik, $password);
        if ($stmt->execute()) {
            $success = "Registrasi berhasil! Silakan login.";
            $_POST = [];
            $warga_result = $koneksi->query("SELECT w.nik, w.nama FROM warga w LEFT JOIN user u ON u.nik = w.nik WHERE u.nik IS NULL ORDER BY w.nama ASC");
        } else {
            $error = "Registrasi gagal. Silakan coba lagi.";
            $_POST = [];
        }
    }
}
function alert($msg) {
    echo "<script language='javascript'>alert('$msg');";
    echo "document.location = 'login.php'</script>";
}

?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Register | Qurban</title>
    <link href="css/bootstrap.css" media="all" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="col-md-4 mx-auto card p-4 shadow-sm">
        <h3 class="text-center mb-3">Registrasi Akun</h3>
        <?php if (isset($error)) : 
            alert($error); ?>
        <?php endif; ?>
        <?php if (isset($success)) :
            alert($success); ?>
        <?php endif; ?>
        <form method="post">
            <div class="mb-3">
                <label>NIK:</label>
                <select name="nik" id="nik" class="form-select" required>
                    <option value=""></option>
                        <?php
                        while ($w = $warga_result->fetch_assoc()): ?>
                            <option value="<?= $w['nik'] ?>" <?= (isset($_POST['nik']) && $_POST['nik'] == $w['nik']) ? 'selected' : '' ?>>
                                <?= htmlspecialchars($w['nama']) ?> (<?= $w['nik'] ?>)
                            </option>
                        <?php endwhile; ?>
                </select>
                <!-- <input type="text" name="nik" class="form-control" required> -->
            </div>
            <div class="mb-3">
                <label>Password:</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button class="btn btn-success w-100"  type="submit">Daftar</button>
        </form>
        <div class="text-center mt-2">
            <a href="login.php">Sudah punya akun? Login di sini</a>
        </div>
    </div>
</div>
</body>
</html>
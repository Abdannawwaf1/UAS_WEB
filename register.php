<?php
session_start();
include 'koneksi.php';

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
        } else {
            $error = "Registrasi gagal. Silakan coba lagi.";
        }
    }
}
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Register Akun Qurban</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="col-md-4 mx-auto card p-4 shadow-sm">
        <h3 class="text-center mb-3">Registrasi Akun</h3>
        <?php if (isset($error)) : ?>
            <div class="alert alert-danger"><?= $error ?></div>
        <?php endif; ?>
        <?php if (isset($success)) : ?>
            <div class="alert alert-success"><?= $success ?></div>
        <?php endif; ?>
        <form method="post">
            <div class="mb-3">
                <label>NIK:</label>
                <input type="text" name="nik" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Password:</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button class="btn btn-success w-100" type="submit">Daftar</button>
        </form>
        <div class="text-center mt-2">
            <a href="login.php">Sudah punya akun? Login di sini</a>
        </div>
    </div>
</div>
</body>
</html>
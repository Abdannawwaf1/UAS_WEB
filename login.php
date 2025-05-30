<?php
session_start();
include 'koneksi.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $nik = $_POST['nik'];
    $password = $_POST['password'];

    // Cek admin hardcoded
    if ($nik === 'admin' && $password === 'admin123') {
        $_SESSION['user'] = [
            'id_user' => 0,
            'nama' => 'Administrator',
            'username' => 'admin',
            'role' => ['admin']
        ];
        header("Location: dashboard.php");
        exit();
    }

    // Ambil user dari tabel user berdasarkan NIK
    $sql = "SELECT u.*, w.nama FROM user u 
            LEFT JOIN warga w ON u.nik = w.nik 
            WHERE u.nik = ?";
    $stmt = $koneksi->prepare($sql);
    $stmt->bind_param("s", $nik);
    $stmt->execute();
    $res = $stmt->get_result();

    if ($res->num_rows === 1) {
        $data = $res->fetch_assoc();

        // Validasi password
        if ($password === $data['password']) {
            $id_user = $data['id_user'];
            $peran_result = $koneksi->query("SELECT peran FROM peran WHERE id_user = $id_user");

            $roles = [];
            while ($r = $peran_result->fetch_assoc()) {
                $roles[] = $r['peran'];
            }

            $_SESSION['user'] = [
                'id_user' => $data['id_user'],
                'nama' => $data['nama'],
                'username' => $data['nik'], // gunakan nik sebagai username
                'role' => $roles,
            ];

            header("Location: dashboard.php");
            exit();
        } else {
            $error = "Password salah.";
        }
    } else {
        $error = "NIK tidak ditemukan.";
    }
}
?>

<!-- HTML login form -->
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Login Sistem Qurban</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="col-md-4 mx-auto card p-4 shadow-sm">
        <h3 class="text-center mb-3">Login Qurban</h3>
        <?php if (isset($error)) : ?>
            <div class="alert alert-danger"><?= $error ?></div>
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
            <button class="btn btn-primary w-100" type="submit">Masuk</button>
        </form>
        <div class="text-center mt-3">
            <a href="register.php" class="btn btn-link">Belum punya akun? Daftar di sini</a>
        </div>
    </div>
</div>
</body>
</html>

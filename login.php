<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Login | Sistem Qurban</title>
    <link href="css/bootstrap.css" media="all" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="col-md-4 mx-auto card p-4 shadow-sm">
        <h3 class="text-center mb-3">Login Qurban</h3>
        <form method="post" action="aksi_login.php">
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

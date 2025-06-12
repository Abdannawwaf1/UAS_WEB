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
            alert($error);
        }
    } else {
        $error = "NIK / Password salah.";
        alert($error);
    }
}
function alert($msg) {
    echo "<script language='javascript'>alert('$msg');";
    echo "document.location = 'login.php'</script>";
}
?>
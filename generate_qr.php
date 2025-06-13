<?php
require_once 'asset/qrcode/qrlib.php';
include_once 'koneksi.php';

function generate_user_qr($nik, $username, $koneksi) {
    $sql = "SELECT pd.qrcode_token, p.peran 
            FROM pengambilan_daging pd
            INNER JOIN peran p ON pd.id_peran = p.id_peran
            WHERE p.nik = ?";
    $stmt = $koneksi->prepare($sql);
    $stmt->bind_param("i", $nik);
    $stmt->execute();
    $res = $stmt->get_result();

    if ($res->num_rows > 0) {
        $qr_folder = __DIR__ . '/asset/qrcode/img';
        if (!is_dir($qr_folder)) mkdir($qr_folder, 0777, true);

        while ($data = $res->fetch_assoc()) {
            $token = $data['qrcode_token'];
            $peran = $data['peran'];
            $filename = $qr_folder . '/qr_' . $username . '_' . $peran . '.png';
            if (!file_exists($filename)) {
                QRcode::png($token, $filename, QR_ECLEVEL_H, 5);
            }
        }
    }
}

if (!isset($_SESSION)) session_start();
if (!isset($_SESSION['user'])) return;

$user = $_SESSION['user'];
$nik = $user['nik'];
$username = $user['username'];

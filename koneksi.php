<?php
$host = "Localhost";
$username = "root";
$password = "1234";
$database = "db_qurban";
$koneksi = mysqli_connect($host, $username, $password, $database);
if ($koneksi) {
    echo "" ;
} else {
    echo "Server not Connected";
}
?>
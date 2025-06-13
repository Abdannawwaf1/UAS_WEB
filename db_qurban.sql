-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               9.0.0 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for db_qurban
CREATE DATABASE IF NOT EXISTS `db_qurban` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_qurban`;

-- Dumping structure for function db_qurban.generate_qrcode_token
DELIMITER //
CREATE FUNCTION `generate_qrcode_token`() RETURNS varchar(50) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
  DECLARE chars VARCHAR(62) DEFAULT 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  DECLARE token VARCHAR(50) DEFAULT '';
  DECLARE i INT DEFAULT 0;

  WHILE i < 10 DO
    SET token = CONCAT(token, SUBSTRING(chars, FLOOR(1 + RAND() * 62), 1));
    SET i = i + 1;
  END WHILE;

  RETURN token;
END//
DELIMITER ;

-- Dumping structure for table db_qurban.pengambilan_daging
CREATE TABLE IF NOT EXISTS `pengambilan_daging` (
  `id_pengambilan` int NOT NULL AUTO_INCREMENT,
  `id_peran` int NOT NULL,
  `jumlah_daging` decimal(5,2) NOT NULL,
  `status` enum('Belum Diambil','Sudah Diambil','') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `qrcode_token` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_pengambilan`),
  KEY `id_user` (`id_peran`) USING BTREE,
  CONSTRAINT `FK_pengambilan_daging_peran` FOREIGN KEY (`id_peran`) REFERENCES `peran` (`id_peran`)
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table db_qurban.pengambilan_daging: ~1 rows (approximately)
INSERT INTO `pengambilan_daging` (`id_pengambilan`, `id_peran`, `jumlah_daging`, `status`, `qrcode_token`) VALUES
	(46, 51, 2.00, 'Belum Diambil', 'dztIgLWQPb'),
	(47, 52, 2.00, 'Belum Diambil', 'eGByCtjnbV'),
	(48, 53, 2.00, 'Belum Diambil', 'Y5cgOjMS0U'),
	(49, 54, 2.00, 'Belum Diambil', 'Hmw9mHuWit'),
	(50, 55, 2.00, 'Belum Diambil', '9uwo7wD7lL'),
	(51, 56, 2.00, 'Belum Diambil', 'DukqoL8Urf'),
	(52, 57, 2.00, 'Belum Diambil', 'btSTqdSGkm'),
	(53, 58, 2.00, 'Belum Diambil', 'XA4g1vQCWq'),
	(54, 59, 2.00, 'Belum Diambil', 'Y1HD2NevVd'),
	(55, 60, 2.00, 'Belum Diambil', 'SHo7xGHREg'),
	(56, 61, 2.00, 'Belum Diambil', 'XSYDId8ed5'),
	(57, 62, 2.00, 'Belum Diambil', 'NSzR2hH6V6'),
	(58, 63, 2.00, 'Belum Diambil', 'oZGQDbEDCD'),
	(59, 64, 2.00, 'Belum Diambil', 'Hc5QjBY3Sw'),
	(60, 65, 2.00, 'Belum Diambil', 'Bx4KIIP2ni'),
	(61, 66, 2.00, 'Belum Diambil', '2tAzKTDUdY'),
	(62, 67, 2.00, 'Belum Diambil', 'iiKKWRUyCv'),
	(63, 68, 2.00, 'Belum Diambil', 'uZwtSTnORs'),
	(64, 69, 2.00, 'Belum Diambil', 'uijNU982ex'),
	(65, 70, 2.00, 'Belum Diambil', 'iYRNQnaNwS'),
	(66, 71, 2.00, 'Belum Diambil', 'FkqpQTw6YI'),
	(67, 72, 2.00, 'Belum Diambil', 'gKTDUffCnF'),
	(68, 73, 2.00, 'Belum Diambil', 'jh9Vuub9oP'),
	(69, 74, 2.00, 'Belum Diambil', 'SssZ4V7xFC'),
	(70, 75, 2.00, 'Belum Diambil', '6kGucArdR9'),
	(71, 76, 2.00, 'Belum Diambil', 'Ea4OetKpzK'),
	(72, 77, 2.00, 'Belum Diambil', 'VM7OQoebwi'),
	(73, 78, 2.00, 'Belum Diambil', 'bidqA7xGIW'),
	(74, 79, 2.00, 'Belum Diambil', 'Xx3FudHLhL'),
	(75, 80, 2.00, 'Belum Diambil', 'TBKuQEkqpS'),
	(76, 81, 2.00, 'Belum Diambil', 'fmi58Fhbkj'),
	(77, 82, 2.00, 'Belum Diambil', 'I9gmj9OOZY'),
	(78, 83, 2.00, 'Belum Diambil', 'rTdc032uEJ'),
	(79, 84, 2.00, 'Belum Diambil', 'iS1XSV2VHg'),
	(80, 85, 2.00, 'Belum Diambil', 'Qt5YKq6nW3'),
	(81, 86, 2.00, 'Belum Diambil', 'YRPYM1pv18'),
	(82, 87, 2.00, 'Belum Diambil', 'Rfov3LOkQi'),
	(83, 88, 2.00, 'Belum Diambil', '7K5JAhr3VF'),
	(84, 89, 2.00, 'Belum Diambil', 'XnAKxdAmDY'),
	(85, 90, 2.00, 'Belum Diambil', '1F2IE4WGYp'),
	(86, 91, 2.00, 'Belum Diambil', 'IqDM0ldjbe'),
	(87, 92, 2.00, 'Belum Diambil', 'KTGhXSTspI'),
	(88, 93, 2.00, 'Belum Diambil', 'tO9MFxsN7H'),
	(89, 94, 2.00, 'Belum Diambil', 'rLxbxo4lQe'),
	(90, 95, 2.00, 'Belum Diambil', 'sDLsDGYnCO'),
	(91, 96, 2.00, 'Belum Diambil', 'FueKZhexiY'),
	(92, 97, 2.00, 'Belum Diambil', 'RNOh9Tk9OK'),
	(93, 98, 2.00, 'Belum Diambil', 'LWRTtufTAJ'),
	(94, 99, 2.00, 'Belum Diambil', 'q94jG037Hp'),
	(95, 100, 2.00, 'Belum Diambil', 'CM2vOzd134'),
	(96, 101, 2.00, 'Belum Diambil', 'zcxnv3LQwF'),
	(97, 102, 2.00, 'Belum Diambil', 'GRDa9pX1KP'),
	(98, 103, 2.00, 'Belum Diambil', 'vDA0OohsA1'),
	(99, 104, 2.00, 'Belum Diambil', 'UBImrpNG2F'),
	(100, 105, 2.00, 'Belum Diambil', 'yvZviexhT7'),
	(101, 106, 2.00, 'Belum Diambil', '0VKyli9PRp'),
	(102, 107, 2.00, 'Belum Diambil', 'gmekep4g1w'),
	(103, 108, 2.00, 'Belum Diambil', 'REgZfQyR5z'),
	(104, 109, 2.00, 'Belum Diambil', 'XZ2JIMomHw'),
	(105, 110, 2.00, 'Belum Diambil', 'gS4maO3uEI'),
	(106, 111, 2.00, 'Belum Diambil', '3jNUBIllNP'),
	(107, 112, 4.00, 'Belum Diambil', 'TnPT0QwITJ'),
	(108, 113, 2.00, 'Belum Diambil', 'j6BRTsqQRj'),
	(109, 114, 2.00, 'Belum Diambil', 'wUUqbIXeR5'),
	(110, 115, 2.00, 'Belum Diambil', '9RYIhPogmj'),
	(111, 116, 2.00, 'Belum Diambil', 'VtnAHkkLKQ'),
	(112, 117, 2.00, 'Belum Diambil', '01wWaC7mRe'),
	(113, 118, 2.00, 'Belum Diambil', 'RPYMziT1WQ'),
	(114, 119, 2.00, 'Belum Diambil', 'MZcD3T0UGg'),
	(115, 120, 2.00, 'Belum Diambil', 'sHZtZz6MNc'),
	(116, 121, 2.00, 'Belum Diambil', '4qpRaSK7Uv'),
	(117, 122, 2.00, 'Belum Diambil', 'SwC0IJTItO'),
	(118, 123, 2.00, 'Belum Diambil', 'qM6GsOBcNq'),
	(119, 124, 2.00, 'Belum Diambil', 'tLpzHITJyl'),
	(120, 125, 4.00, 'Belum Diambil', 'KgF3NWLygN'),
	(121, 126, 4.00, 'Belum Diambil', 'hDqOI6V1S5'),
	(122, 127, 4.00, 'Belum Diambil', '6yQ0cuXoFe'),
	(123, 128, 4.00, 'Belum Diambil', 'kjCgdzr94g'),
	(124, 129, 4.00, 'Belum Diambil', 'Hxmu07TpX5'),
	(125, 130, 4.00, 'Belum Diambil', 'Rfq5i8NJFB'),
	(126, 131, 4.00, 'Belum Diambil', 'u8oVvytQHx'),
	(127, 132, 4.00, 'Belum Diambil', 'DgdynsqPOX'),
	(128, 133, 2.00, 'Belum Diambil', 'xo5mUw6YGX'),
	(129, 134, 2.00, 'Belum Diambil', 'S0R2hDqNEs');

-- Dumping structure for table db_qurban.peran
CREATE TABLE IF NOT EXISTS `peran` (
  `id_peran` int NOT NULL AUTO_INCREMENT,
  `nik` varchar(50) DEFAULT NULL,
  `peran` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id_peran`),
  KEY `id_user` (`nik`) USING BTREE,
  CONSTRAINT `FK_peran_warga` FOREIGN KEY (`nik`) REFERENCES `warga` (`nik`)
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_qurban.peran: ~86 rows (approximately)
INSERT INTO `peran` (`id_peran`, `nik`, `peran`) VALUES
	(50, 'admin', 'admin'),
	(51, '3276011401990001', 'warga'),
	(52, '3276011401990002', 'warga'),
	(53, '3276011401990003', 'warga'),
	(54, '3276011401990004', 'warga'),
	(55, '3276011401990005', 'warga'),
	(56, '3276011401990006', 'warga'),
	(57, '3276011401990007', 'warga'),
	(58, '3276011401990008', 'warga'),
	(59, '3276011401990009', 'warga'),
	(60, '3276011401990010', 'warga'),
	(61, '3276011401990011', 'warga'),
	(62, '3276011401990012', 'warga'),
	(63, '3276011401990013', 'warga'),
	(64, '3276011401990014', 'warga'),
	(65, '3276011401990015', 'warga'),
	(66, '3276011401990016', 'warga'),
	(67, '3276011401990017', 'warga'),
	(68, '3276011401990018', 'warga'),
	(69, '3276011401990019', 'warga'),
	(70, '3276011401990020', 'warga'),
	(71, '3276011401990021', 'warga'),
	(72, '3276011401990022', 'warga'),
	(73, '3276011401990023', 'warga'),
	(74, '3276011401990024', 'warga'),
	(75, '3276011401990025', 'warga'),
	(76, '3276011401990026', 'warga'),
	(77, '3276011401990027', 'warga'),
	(78, '3276011401990028', 'warga'),
	(79, '3276011401990029', 'warga'),
	(80, '3276011401990030', 'warga'),
	(81, '3276011401990031', 'warga'),
	(82, '3276011401990032', 'warga'),
	(83, '3276011401990033', 'warga'),
	(84, '3276011401990034', 'warga'),
	(85, '3276011401990035', 'warga'),
	(86, '3276011401990036', 'warga'),
	(87, '3276011401990037', 'warga'),
	(88, '3276011401990038', 'warga'),
	(89, '3276011401990039', 'warga'),
	(90, '3276011401990040', 'warga'),
	(91, '3276011401990041', 'warga'),
	(92, '3276011401990042', 'warga'),
	(93, '3276011401990043', 'warga'),
	(94, '3276011401990044', 'warga'),
	(95, '3276011401990045', 'warga'),
	(96, '3276011401990046', 'warga'),
	(97, '3276011401990047', 'warga'),
	(98, '3276011401990048', 'warga'),
	(99, '3276011401990049', 'warga'),
	(100, '3276011401990050', 'warga'),
	(101, '3276011401990051', 'warga'),
	(102, '3276011401990052', 'warga'),
	(103, '3276011401990053', 'warga'),
	(104, '3276011401990054', 'warga'),
	(105, '3276011401990055', 'warga'),
	(106, '3276011401990056', 'warga'),
	(107, '3276011401990057', 'warga'),
	(108, '3276011401990058', 'warga'),
	(109, '3276011401990059', 'warga'),
	(110, '3276011401990060', 'warga'),
	(111, '3276011401990009', 'panitia'),
	(112, '3276011401990054', 'berqurban'),
	(113, '3276011401990029', 'panitia'),
	(114, '3276011401990005', 'panitia'),
	(115, '3276011401990043', 'panitia'),
	(116, '3276011401990038', 'panitia'),
	(117, '3276011401990050', 'panitia'),
	(118, '3276011401990057', 'panitia'),
	(119, '3276011401990013', 'panitia'),
	(120, '3276011401990007', 'panitia'),
	(121, '3276011401990053', 'panitia'),
	(122, '3276011401990051', 'panitia'),
	(123, '3276011401990035', 'panitia'),
	(124, '3276011401990041', 'panitia'),
	(125, '3276011401990007', 'berqurban'),
	(126, '3276011401990035', 'berqurban'),
	(127, '3276011401990017', 'berqurban'),
	(128, '3276011401990055', 'berqurban'),
	(129, '3276011401990046', 'berqurban'),
	(130, '3276011401990044', 'berqurban'),
	(131, '3276011401990018', 'berqurban'),
	(132, '3276011401990050', 'berqurban'),
	(133, '3276011401990019', 'panitia'),
	(134, '3276011401990047', 'panitia');

-- Dumping structure for table db_qurban.transaksi_keuangan
CREATE TABLE IF NOT EXISTS `transaksi_keuangan` (
  `id_transaksi` int NOT NULL AUTO_INCREMENT,
  `id_peran` int DEFAULT NULL,
  `tanggal` date NOT NULL,
  `keterangan` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `tipe` enum('masuk','keluar') COLLATE utf8mb4_general_ci NOT NULL,
  `jumlah` int DEFAULT NULL,
  PRIMARY KEY (`id_transaksi`),
  KEY `id_qurban` (`id_peran`) USING BTREE,
  CONSTRAINT `FK_transaksi_keuangan_peran` FOREIGN KEY (`id_peran`) REFERENCES `peran` (`id_peran`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table db_qurban.transaksi_keuangan: ~20 rows (approximately)
INSERT INTO `transaksi_keuangan` (`id_transaksi`, `id_peran`, `tanggal`, `keterangan`, `tipe`, `jumlah`) VALUES
	(13, 104, '2025-06-13', 'Qurban Sapi', 'masuk', 3000000),
	(14, 85, '2025-06-13', 'Qurban Kambing', 'masuk', 2700000),
	(15, 104, '2025-06-14', 'Iuran Sapi', 'masuk', 100000),
	(16, 96, '2025-06-11', 'Qurban Sapi', 'masuk', 3000000),
	(17, 67, '2025-06-02', 'Qurban Sapi', 'masuk', 3000000),
	(18, 105, '2025-06-01', 'Qurban Sapi', 'masuk', 3000000),
	(19, 68, '2025-06-04', 'Qurban Sapi', 'masuk', 3000000),
	(20, 100, '2025-06-09', 'Qurban Sapi', 'masuk', 3000000),
	(21, 57, '2025-06-11', 'Qurban Sapi', 'masuk', 3000000),
	(22, 94, '2025-06-08', 'Qurban Kambing', 'masuk', 2700000),
	(23, 105, '2025-06-03', 'Iuran Sapi', 'masuk', 100000),
	(24, 67, '2025-06-06', 'Iuran Sapi', 'masuk', 100000),
	(25, 68, '2025-06-04', 'Iuran Sapi', 'masuk', 100000),
	(26, 67, '2025-06-06', 'Iuran Sapi', 'masuk', 100000),
	(27, 100, '2025-06-09', 'Iuran Sapi', 'masuk', 100000),
	(28, 96, '2025-06-11', 'Iuran Sapi', 'masuk', 100000),
	(29, 94, '2025-06-08', 'Iuran Kambing', 'masuk', 50000),
	(30, 85, '2025-06-13', 'Iuran Kambing', 'masuk', 50000),
	(31, 50, '2025-06-14', 'Beli 1 Sapi', 'keluar', 21000000),
	(32, 50, '2025-06-15', 'Beli 2 Kambing', 'keluar', 5400000),
	(33, 50, '2025-06-15', 'Tali pengikat sapi 2', 'keluar', 100000),
	(34, 50, '2025-06-15', 'Tali pengikat kambing 2', 'keluar', 60000),
	(35, 50, '2025-06-15', 'Kantong plastik (100 pcs) 1', 'keluar', 250000),
	(36, 50, '2025-06-15', 'Air minum panitia 5 dus', 'keluar', 175000),
	(37, 50, '2025-06-15', 'Pisau potong 2', 'keluar', 150000),
	(38, 50, '2025-06-15', 'Sarung tangan plastik 1 box', 'keluar', 65000);

-- Dumping structure for table db_qurban.warga
CREATE TABLE IF NOT EXISTS `warga` (
  `nik` varchar(50) NOT NULL DEFAULT '',
  `nama` varchar(50) DEFAULT NULL,
  `asal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `pekerjaan` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`nik`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_qurban.warga: ~61 rows (approximately)
INSERT INTO `warga` (`nik`, `nama`, `asal`, `pekerjaan`, `password`) VALUES
	('3276011401990001', 'Ahmad Fauzi', 'Bandung', 'Guru', NULL),
	('3276011401990002', 'Siti Aminah', 'Jakarta', 'Dokter', NULL),
	('3276011401990003', 'Budi Santoso', 'Surabaya', 'Petani', '123'),
	('3276011401990004', 'Dewi Lestari', 'Yogyakarta', 'Mahasiswa', NULL),
	('3276011401990005', 'Rudi Hartono', 'Bandung', 'Karyawan Swasta', NULL),
	('3276011401990006', 'Lina Marlina', 'Bekasi', 'Wiraswasta', NULL),
	('3276011401990007', 'Hendra Saputra', 'Bogor', 'Sopir', NULL),
	('3276011401990008', 'Putri Ayu', 'Semarang', 'Perawat', NULL),
	('3276011401990009', 'Agus Salim', 'Medan', 'Polisi', 'abc'),
	('3276011401990010', 'Nia Ramadhani', 'Depok', 'Ibu Rumah Tangga', NULL),
	('3276011401990011', 'Andi Pratama', 'Makassar', 'Nelayan', NULL),
	('3276011401990012', 'Maya Sari', 'Padang', 'Dosen', NULL),
	('3276011401990013', 'Fajar Nugroho', 'Solo', 'Mahasiswa', NULL),
	('3276011401990014', 'Mega Fitriani', 'Tangerang', 'Apoteker', NULL),
	('3276011401990015', 'Rahmat Hidayat', 'Pontianak', 'Guru', NULL),
	('3276011401990016', 'Winda Karlina', 'Malang', 'Desainer', NULL),
	('3276011401990017', 'Teguh Widodo', 'Surakarta', 'Wiraswasta', NULL),
	('3276011401990018', 'Indah Permata', 'Cirebon', 'Perawat', NULL),
	('3276011401990019', 'Slamet Riyadi', 'Pekalongan', 'PNS', NULL),
	('3276011401990020', 'Dian Safitri', 'Cilegon', 'Akuntan', NULL),
	('3276011401990021', 'Ilham Akbar', 'Karawang', 'Supir', NULL),
	('3276011401990022', 'Vina Yuliana', 'Tasikmalaya', 'Kasir', NULL),
	('3276011401990023', 'Tono Supriyadi', 'Cikampek', 'Satpam', NULL),
	('3276011401990024', 'Nurlaila Sari', 'Cianjur', 'Sekretaris', NULL),
	('3276011401990025', 'Asep Sudrajat', 'Garut', 'Petani', NULL),
	('3276011401990026', 'Ratna Dewi', 'Kuningan', 'Penjahit', NULL),
	('3276011401990027', 'Heri Susanto', 'Subang', 'Pedagang', NULL),
	('3276011401990028', 'Sri Rahayu', 'Majalengka', 'Ibu Rumah Tangga', NULL),
	('3276011401990029', 'Bayu Saputra', 'Sukabumi', 'Teknisi', NULL),
	('3276011401990030', 'Murniati', 'Banjar', 'PNS', NULL),
	('3276011401990031', 'Yusuf Maulana', 'Cileunyi', 'Sopir', NULL),
	('3276011401990032', 'Lestari Handayani', 'Cimahi', 'Kasir', NULL),
	('3276011401990033', 'Rangga Dwi', 'Cikarang', 'Montir', NULL),
	('3276011401990034', 'Selvi Indah', 'Soreang', 'Penjaga Toko', NULL),
	('3276011401990035', 'Joko Widodo', 'Kebumen', 'Pengrajin', NULL),
	('3276011401990036', 'Ayu Lestari', 'Wonosobo', 'Guru TK', NULL),
	('3276011401990037', 'Eka Saputra', 'Magelang', 'Tentara', NULL),
	('3276011401990038', 'Wahyu Adi', 'Banyumas', 'Karyawan Pabrik', NULL),
	('3276011401990039', 'Nina Salsabila', 'Purwokerto', 'Desainer', NULL),
	('3276011401990040', 'Hana Fauziah', 'Cilacap', 'Mahasiswa', NULL),
	('3276011401990041', 'Kurniawan', 'Serang', 'Pedagang', NULL),
	('3276011401990042', 'Dewi Sartika', 'Lebak', 'Penjahit', NULL),
	('3276011401990043', 'Roni Kurnia', 'Pandeglang', 'Petani', NULL),
	('3276011401990044', 'Yuliawati', 'Indramayu', 'Karyawan Swasta', NULL),
	('3276011401990045', 'Rian Hidayat', 'Tegal', 'Pelaut', NULL),
	('3276011401990046', 'Citra Maharani', 'Brebes', 'Apoteker', NULL),
	('3276011401990047', 'Edi Purnomo', 'Pemalang', 'PNS', NULL),
	('3276011401990048', 'Fitri Handayani', 'Batang', 'Ibu Rumah Tangga', NULL),
	('3276011401990049', 'Aminullah', 'Jepara', 'Kuli Bangunan', NULL),
	('3276011401990050', 'Nana Suryana', 'Kendal', 'Karyawan', NULL),
	('3276011401990051', 'Oki Setiawan', 'Purbalingga', 'Montir', NULL),
	('3276011401990052', 'Silvia Ayuningtyas', 'Boyolali', 'Guru SD', NULL),
	('3276011401990053', 'Ahmad Rofiq', 'Salatiga', 'Wiraswasta', NULL),
	('3276011401990054', 'Bella Salsabila', 'Klaten', 'Apoteker', 'jkl'),
	('3276011401990055', 'Hafidzul Hakim', 'Sragen', 'Dosen', NULL),
	('3276011401990056', 'Raisa Nurhaliza', 'Madiun', 'Dokter', NULL),
	('3276011401990057', 'Dwi Handoko', 'Ngawi', 'Petani', NULL),
	('3276011401990058', 'Lisa Febrianti', 'Blitar', 'Guru', NULL),
	('3276011401990059', 'Rizky Maulana', 'Kediri', 'Karyawan Pabrik', NULL),
	('3276011401990060', 'Yanti Pratiwi', 'Jombang', 'Ibu Rumah Tangga', NULL),
	('admin', 'administrator', '-', '-', 'admin123');

-- Dumping structure for trigger db_qurban.pengambilan_daging
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `pengambilan_daging` AFTER INSERT ON `peran` FOR EACH ROW BEGIN
  DECLARE v_jumlah_daging DECIMAL(5,2);

  -- Tentukan jumlah daging berdasarkan peran
  IF NEW.peran = 'warga' THEN
    SET v_jumlah_daging = 2.00;
  ELSEIF NEW.peran = 'panitia' THEN
    SET v_jumlah_daging = 2.00;
  ELSEIF NEW.peran = 'berqurban' THEN
    SET v_jumlah_daging = 4.00;
  ELSE
    SET v_jumlah_daging = 0.00;
  END IF;

  -- Insert ke pengambilan_daging dengan token acak
  INSERT INTO pengambilan_daging (id_peran, jumlah_daging, status, qrcode_token)
  VALUES (NEW.id_peran, v_jumlah_daging, 'Belum Diambil', generate_qrcode_token());

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger db_qurban.peran_warga
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `peran_warga` AFTER INSERT ON `warga` FOR EACH ROW BEGIN
	INSERT INTO peran
	(nik, peran) VALUES
	(NEW.nik, 'warga');
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

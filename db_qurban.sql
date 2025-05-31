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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table db_qurban.pengambilan_daging: ~6 rows (approximately)
INSERT INTO `pengambilan_daging` (`id_pengambilan`, `id_peran`, `jumlah_daging`, `status`, `qrcode_token`) VALUES
	(1, 1, 1.00, 'Belum Diambil', 'qwert'),
	(2, 2, 2.00, 'Belum Diambil', 'pooiuy'),
	(3, 3, 1.00, 'Belum Diambil', 'asddag'),
	(4, 4, 1.50, 'Belum Diambil', 'mnbvc'),
	(5, 5, 1.00, 'Belum Diambil', 'lkjhgf'),
	(6, 6, 1.00, 'Belum Diambil', 'sdfghjj');

-- Dumping structure for table db_qurban.peran
CREATE TABLE IF NOT EXISTS `peran` (
  `id_peran` int NOT NULL AUTO_INCREMENT,
  `id_user` int DEFAULT NULL,
  `peran` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id_peran`),
  KEY `id_user` (`id_user`),
  CONSTRAINT `FK__user` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_qurban.peran: ~7 rows (approximately)
INSERT INTO `peran` (`id_peran`, `id_user`, `peran`) VALUES
	(1, 1, 'warga'),
	(2, 2, 'berqurban'),
	(3, 2, 'warga'),
	(4, 3, 'panitia'),
	(5, 3, 'warga'),
	(6, 11, 'warga'),
	(11, 11, 'berqurban');

-- Dumping structure for table db_qurban.transaksi_keuangan
CREATE TABLE IF NOT EXISTS `transaksi_keuangan` (
  `id_transaksi` int NOT NULL AUTO_INCREMENT,
  `nik` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `tanggal` date NOT NULL,
  `keterangan` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `tipe` enum('masuk','keluar') COLLATE utf8mb4_general_ci NOT NULL,
  `jumlah` int DEFAULT NULL,
  PRIMARY KEY (`id_transaksi`),
  KEY `id_qurban` (`nik`) USING BTREE,
  CONSTRAINT `FK_transaksi_keuangan_warga` FOREIGN KEY (`nik`) REFERENCES `warga` (`nik`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table db_qurban.transaksi_keuangan: ~2 rows (approximately)
INSERT INTO `transaksi_keuangan` (`id_transaksi`, `nik`, `tanggal`, `keterangan`, `tipe`, `jumlah`) VALUES
	(1, '1990', '2025-05-31', 'Qurban Sapi', 'masuk', 3000000),
	(2, '1992', '2025-05-31', 'Qurban Kambing', 'masuk', 2700000);

-- Dumping structure for table db_qurban.user
CREATE TABLE IF NOT EXISTS `user` (
  `id_user` int NOT NULL AUTO_INCREMENT,
  `nik` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `password` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_user`) USING BTREE,
  KEY `nik` (`nik`),
  CONSTRAINT `FK_user_warga` FOREIGN KEY (`nik`) REFERENCES `warga` (`nik`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table db_qurban.user: ~0 rows (approximately)
INSERT INTO `user` (`id_user`, `nik`, `password`) VALUES
	(1, '1989', '123'),
	(2, '1990', '123'),
	(3, '1991', '123'),
	(11, '1992', '123');

-- Dumping structure for table db_qurban.warga
CREATE TABLE IF NOT EXISTS `warga` (
  `nik` varchar(50) NOT NULL DEFAULT '',
  `nama` varchar(50) DEFAULT NULL,
  `asal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `pekerjaan` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`nik`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_qurban.warga: ~0 rows (approximately)
INSERT INTO `warga` (`nik`, `nama`, `asal`, `pekerjaan`) VALUES
	('1989', 'Budi', 'Malang', 'Arsitek'),
	('1990', 'Toni', 'Pasuruan', 'Guru'),
	('1991', 'Doni', 'Sidoarjo', 'Pedagang'),
	('1992', 'Ari', 'Gresik', 'Buruh');

-- Dumping structure for trigger db_qurban.peran_berqurban
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `peran_berqurban` AFTER INSERT ON `transaksi_keuangan` FOR EACH ROW BEGIN
  DECLARE v_id_user INT;

  -- Hanya jalankan jika tipe masuk dan keterangan terkait qurban
  IF NEW.tipe = 'masuk' AND NEW.keterangan LIKE '%qurban%' THEN

    -- Ambil id_user dari tabel user yang nik-nya sesuai
    SELECT id_user INTO v_id_user
    FROM user
    WHERE nik = NEW.nik
    LIMIT 1;

    -- Jika ditemukan user-nya
    IF v_id_user IS NOT NULL THEN
      -- Cek apakah sudah punya peran 'berqurban'
      IF NOT EXISTS (
        SELECT 1 FROM peran
        WHERE id_user = v_id_user AND peran = 'berqurban'
      ) THEN
        -- Tambahkan peran 'berqurban'
        INSERT INTO peran (id_user, peran)
        VALUES (v_id_user, 'berqurban');
      END IF;
    END IF;

  END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger db_qurban.peran_warga
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `peran_warga` AFTER INSERT ON `user` FOR EACH ROW BEGIN
	INSERT INTO peran
	(id_user, peran) VALUES
	(NEW.id_user, 'warga');
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

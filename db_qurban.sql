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
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table db_qurban.pengambilan_daging: ~0 rows (approximately)
INSERT INTO `pengambilan_daging` (`id_pengambilan`, `id_peran`, `jumlah_daging`, `status`, `qrcode_token`) VALUES
	(45, 50, 2.00, 'Belum Diambil', 'UbP3vGP3uD');

-- Dumping structure for table db_qurban.peran
CREATE TABLE IF NOT EXISTS `peran` (
  `id_peran` int NOT NULL AUTO_INCREMENT,
  `nik` varchar(50) DEFAULT NULL,
  `peran` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id_peran`),
  KEY `id_user` (`nik`) USING BTREE,
  CONSTRAINT `FK_peran_warga` FOREIGN KEY (`nik`) REFERENCES `warga` (`nik`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_qurban.peran: ~1 rows (approximately)
INSERT INTO `peran` (`id_peran`, `nik`, `peran`) VALUES
	(50, 'admin', 'admin');

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table db_qurban.transaksi_keuangan: ~0 rows (approximately)

-- Dumping structure for table db_qurban.warga
CREATE TABLE IF NOT EXISTS `warga` (
  `nik` varchar(50) NOT NULL DEFAULT '',
  `nama` varchar(50) DEFAULT NULL,
  `asal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `pekerjaan` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`nik`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_qurban.warga: ~1 rows (approximately)
INSERT INTO `warga` (`nik`, `nama`, `asal`, `pekerjaan`, `password`) VALUES
	('admin', 'administrator', NULL, NULL, 'admin123');

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

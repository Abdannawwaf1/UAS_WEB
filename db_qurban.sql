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

-- Dumping structure for table db_qurban.detail_qurban
CREATE TABLE IF NOT EXISTS `detail_qurban` (
  `id_detail_qurban` int NOT NULL AUTO_INCREMENT,
  `id_qurban` int NOT NULL,
  `id_user` int NOT NULL,
  PRIMARY KEY (`id_detail_qurban`),
  KEY `id_qurban` (`id_qurban`),
  KEY `id_user` (`id_user`),
  CONSTRAINT `FK_detail_qurban_qurban` FOREIGN KEY (`id_qurban`) REFERENCES `qurban` (`id_qurban`),
  CONSTRAINT `FK_detail_qurban_user` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table db_qurban.hewan
CREATE TABLE IF NOT EXISTS `hewan` (
  `id_hewan` int NOT NULL AUTO_INCREMENT,
  `nama_hewan` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `harga` int NOT NULL,
  PRIMARY KEY (`id_hewan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table db_qurban.peran
CREATE TABLE IF NOT EXISTS `peran` (
  `id_peran` int NOT NULL AUTO_INCREMENT,
  `id_user` int DEFAULT NULL,
  `peran` enum('warga','panitia','berqurban') DEFAULT NULL,
  PRIMARY KEY (`id_peran`),
  KEY `id_user` (`id_user`),
  CONSTRAINT `FK__user` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

-- Dumping structure for table db_qurban.qurban
CREATE TABLE IF NOT EXISTS `qurban` (
  `id_qurban` int NOT NULL AUTO_INCREMENT,
  `id_hewan` int NOT NULL,
  `biaya_total` int NOT NULL,
  PRIMARY KEY (`id_qurban`),
  KEY `id_hewan` (`id_hewan`),
  CONSTRAINT `FK_qurban_hewan` FOREIGN KEY (`id_hewan`) REFERENCES `hewan` (`id_hewan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table db_qurban.transaksi_keuangan
CREATE TABLE IF NOT EXISTS `transaksi_keuangan` (
  `id_transaksi` int NOT NULL AUTO_INCREMENT,
  `tanggal` date NOT NULL,
  `keterangan` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `tipe` enum('masuk','keluar') COLLATE utf8mb4_general_ci NOT NULL,
  `jumlah` int DEFAULT NULL,
  `id_qurban` int DEFAULT NULL,
  PRIMARY KEY (`id_transaksi`),
  KEY `id_qurban` (`id_qurban`),
  CONSTRAINT `transaksi_keuangan_ibfk_1` FOREIGN KEY (`id_qurban`) REFERENCES `qurban` (`id_qurban`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table db_qurban.user
CREATE TABLE IF NOT EXISTS `user` (
  `id_user` int NOT NULL AUTO_INCREMENT,
  `nama` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_user`) USING BTREE,
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

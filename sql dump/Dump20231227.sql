CREATE DATABASE  IF NOT EXISTS `pvers` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `pvers`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: pvers
-- ------------------------------------------------------
-- Server version	8.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL,
  `admin_name` varchar(45) NOT NULL,
  `admin_phonenum` varchar(45) NOT NULL,
  `admin_bdate` datetime DEFAULT NULL,
  `admin_email` varchar(45) NOT NULL,
  `admin_pass` varchar(45) NOT NULL,
  `otp` varchar(7) DEFAULT NULL,
  PRIMARY KEY (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (100321,'admin','0596636128','2001-10-23 00:00:00','www.mt22arab.com@gmail.com','admin','695283');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `complainets2`
--

DROP TABLE IF EXISTS `complainets2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `complainets2` (
  `complaint_no` int NOT NULL AUTO_INCREMENT,
  `complaint_sub` text NOT NULL,
  `complaint_add_date` datetime NOT NULL,
  `complaint_description` text NOT NULL,
  `owner_id` int DEFAULT NULL,
  `renter_id` int DEFAULT NULL,
  `complaint_delete_date` datetime DEFAULT NULL,
  PRIMARY KEY (`complaint_no`),
  KEY `owner_id_2_idx` (`owner_id`),
  KEY `renter_id_2_idx` (`renter_id`),
  CONSTRAINT `owner_id_2` FOREIGN KEY (`owner_id`) REFERENCES `owner` (`owner_id`),
  CONSTRAINT `renter_id_2` FOREIGN KEY (`renter_id`) REFERENCES `renter` (`Renter_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `complainets2`
--

LOCK TABLES `complainets2` WRITE;
/*!40000 ALTER TABLE `complainets2` DISABLE KEYS */;
INSERT INTO `complainets2` VALUES (4,'asddasdas','2023-10-23 21:15:06','asdasddas',NULL,NULL,'2023-10-23 21:15:13'),(5,'asdasdasdas','2023-10-23 21:16:39','asdasdda',NULL,NULL,'2023-10-23 21:16:43'),(6,'dsa','2023-11-01 17:22:28','asd',1,NULL,'2023-11-01 17:31:54'),(7,'sdaz','2023-11-01 17:36:01','asd',1,NULL,'2023-11-01 17:38:31'),(8,'hgfd','2023-11-01 17:39:44','ghyt',1,NULL,'2023-11-01 17:39:49'),(9,'dsaq','2023-11-01 17:58:00','zxcd',1,NULL,'2023-11-01 17:58:03'),(10,'hello','2023-11-01 18:09:45','alo',1,NULL,'2023-11-01 18:05:49'),(11,'test','2023-11-01 20:31:32','the bike',1101320941,NULL,'2023-11-01 20:29:10'),(12,'troublen','2023-11-01 20:37:22','troublen',1101320941,NULL,'2023-11-01 20:31:53'),(13,'troublen','2023-11-01 20:54:26','troublen',NULL,1009154121,'2023-12-12 23:51:12');
/*!40000 ALTER TABLE `complainets2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `complaints`
--

DROP TABLE IF EXISTS `complaints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `complaints` (
  `complaint_no` int NOT NULL AUTO_INCREMENT,
  `complaint_sub` text NOT NULL,
  `complaint_date` datetime NOT NULL,
  `complaint_description` text NOT NULL,
  `owner_id` int DEFAULT NULL,
  `renter_id` int DEFAULT NULL,
  `complaint_answer` text,
  PRIMARY KEY (`complaint_no`),
  KEY `owner_id_idx` (`owner_id`),
  KEY `renter_id_idx` (`renter_id`),
  CONSTRAINT `owner_id` FOREIGN KEY (`owner_id`) REFERENCES `owner` (`owner_id`),
  CONSTRAINT `renter_id` FOREIGN KEY (`renter_id`) REFERENCES `renter` (`Renter_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `complaints`
--

LOCK TABLES `complaints` WRITE;
/*!40000 ALTER TABLE `complaints` DISABLE KEYS */;
INSERT INTO `complaints` VALUES (17,'test','2023-10-23 22:15:16','test',1000000004,NULL,'test'),(18,'asdasads','2023-10-23 22:39:39','asddasdsa',1000000004,NULL,NULL),(19,'asdadads','2023-10-23 22:45:59','asddasads',1000000004,NULL,NULL),(20,'asdadsasdasd','2023-10-24 20:32:44','sdasda',1000000004,NULL,NULL),(23,'zx','2023-10-24 20:41:04','as',NULL,1009154121,NULL),(24,'as','2023-10-24 20:41:29','zx',NULL,1009154121,NULL),(25,'zx','2023-10-24 20:49:20','adzx',NULL,1009154121,NULL),(26,'zxc','2023-10-24 20:50:27','asd',NULL,1009154121,NULL),(27,'zxc','2023-10-24 20:50:36','dsa',NULL,1009154121,NULL),(28,'aq','2023-10-24 20:51:06','ds',NULL,1009154121,NULL),(29,'gh','2023-10-24 20:51:17','hg',NULL,1009154121,NULL),(30,'gfds','2023-10-24 20:52:17','asdf',NULL,1009154121,NULL),(31,'zxc','2023-10-24 20:52:24','cxz',NULL,1009154121,NULL),(36,'dsa','2023-11-01 18:00:19','zxcda13t',1,NULL,NULL),(41,'2as','2023-12-12 23:51:44','11',NULL,1009154121,NULL),(42,'zxs','2023-12-12 23:52:09','321',NULL,1009154121,NULL),(43,'test4','2023-12-13 00:09:17','test3',NULL,1009154121,NULL);
/*!40000 ALTER TABLE `complaints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract`
--

DROP TABLE IF EXISTS `contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract` (
  `Con_No` int NOT NULL AUTO_INCREMENT,
  `Con_Date_of_issue` datetime DEFAULT NULL,
  `Con_Beginning_of_Rent_date` datetime DEFAULT NULL,
  `Con_End_of_Rent_date` datetime DEFAULT NULL,
  `Con_Rent_date` datetime DEFAULT NULL,
  `Con_ToS_agreement` tinyint DEFAULT NULL,
  `Res_num` int DEFAULT NULL,
  `Rid_contract` int DEFAULT NULL,
  `Con_status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Con_No`),
  KEY `res_num_idx` (`Res_num`),
  CONSTRAINT `res_num` FOREIGN KEY (`Res_num`) REFERENCES `reservation` (`RESno`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract`
--

LOCK TABLES `contract` WRITE;
/*!40000 ALTER TABLE `contract` DISABLE KEYS */;
INSERT INTO `contract` VALUES (10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(11,'2023-12-26 17:02:34','2023-12-26 16:52:00','2023-12-27 16:52:00',NULL,1,NULL,NULL,NULL),(12,'2023-12-26 17:03:12','2023-12-26 16:52:00','2023-12-27 16:52:00',NULL,1,NULL,NULL,NULL),(13,'2023-12-26 17:04:23','2023-12-26 16:52:00','2023-12-27 16:52:00',NULL,1,NULL,NULL,NULL),(14,'2023-12-26 17:06:37','2023-12-26 16:52:00','2023-12-27 16:52:00',NULL,1,NULL,NULL,NULL),(16,'2023-12-26 17:08:08','2023-12-26 16:52:00','2023-12-27 16:52:00',NULL,1,NULL,1009154121,NULL),(17,'2023-12-26 17:12:24','2023-12-26 16:52:00','2023-12-27 16:52:00',NULL,1,NULL,1009154121,NULL),(18,'2023-12-26 17:12:55','2023-12-26 16:52:00','2023-12-27 16:52:00',NULL,1,NULL,1009154121,NULL),(19,'2023-12-26 17:13:12','2023-12-26 16:52:00','2023-12-27 16:52:00',NULL,1,NULL,1009154121,NULL),(20,'2023-12-26 17:14:38','2023-12-26 16:52:00','2023-12-27 16:52:00',NULL,1,NULL,1009154121,NULL),(21,'2023-12-26 17:15:37','2023-12-26 16:52:00','2023-12-27 16:52:00',NULL,1,NULL,1009154121,NULL),(22,'2023-12-26 17:16:39','2023-12-26 17:16:00','2023-12-27 17:16:00',NULL,1,NULL,1009154121,NULL),(23,'2023-12-26 17:17:03','2023-12-26 17:16:00','2023-12-27 17:16:00',NULL,1,NULL,1009154121,NULL),(24,'2023-12-26 17:18:17','2023-12-26 17:16:00','2023-12-27 17:16:00',NULL,1,NULL,1009154121,NULL),(25,'2023-12-26 17:25:09','2023-12-26 17:16:00','2023-12-27 17:16:00',NULL,1,NULL,1009154121,NULL),(26,'2023-12-26 17:28:32','2023-12-26 17:16:00','2023-12-27 17:16:00',NULL,1,NULL,1009154121,NULL),(27,'2023-12-26 17:28:45','2023-12-26 17:16:00','2023-12-27 17:16:00',NULL,1,NULL,1009154121,NULL),(28,'2023-12-26 17:40:57','2023-12-26 17:40:49','2023-12-28 17:40:00',NULL,1,NULL,1009154121,NULL),(29,'2023-12-26 17:42:36','2023-12-26 17:40:49','2023-12-28 17:40:00',NULL,1,NULL,1009154121,NULL),(30,'2023-12-26 17:43:56','2023-12-26 17:40:49','2023-12-28 17:40:00',NULL,1,NULL,1009154121,NULL),(31,'2023-12-26 17:45:04','2023-12-26 17:40:49','2023-12-28 17:40:00',NULL,1,NULL,1009154121,NULL),(32,'2023-12-26 17:45:27','2023-12-26 17:40:49','2023-12-28 17:40:00',NULL,1,NULL,1009154121,NULL),(33,'2023-12-26 17:49:14','2023-12-26 17:40:49','2023-12-28 17:40:00',NULL,1,NULL,1009154121,NULL);
/*!40000 ALTER TABLE `contract` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_archive`
--

DROP TABLE IF EXISTS `contract_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract_archive` (
  `Con_No` int NOT NULL AUTO_INCREMENT,
  `Con_Date_of_issue` datetime DEFAULT NULL,
  `Con_Beginning_of_Rent_date` datetime DEFAULT NULL,
  `Con_End_of_Rent_date` datetime DEFAULT NULL,
  `Con_Rent_date` datetime DEFAULT NULL,
  `Con_ToS_agreement` tinyint DEFAULT NULL,
  `Res_num` int DEFAULT NULL,
  `Rid_contract` int DEFAULT NULL,
  `Con_status` varchar(45) DEFAULT NULL,
  `Con_No_old` int DEFAULT NULL,
  PRIMARY KEY (`Con_No`),
  KEY `res_num_idx` (`Res_num`),
  CONSTRAINT `res_num23` FOREIGN KEY (`Res_num`) REFERENCES `reservation` (`RESno`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_archive`
--

LOCK TABLES `contract_archive` WRITE;
/*!40000 ALTER TABLE `contract_archive` DISABLE KEYS */;
INSERT INTO `contract_archive` VALUES (50,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `contract_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faq`
--

DROP TABLE IF EXISTS `faq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faq` (
  `faq_content` varchar(200) NOT NULL,
  `faq_headline` varchar(200) NOT NULL,
  `faq_num` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`faq_num`)
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faq`
--

LOCK TABLES `faq` WRITE;
/*!40000 ALTER TABLE `faq` DISABLE KEYS */;
INSERT INTO `faq` VALUES ('asd','1234',1),('asad','test',12),('DSA','ASD',121),('zxds','qwase',130);
/*!40000 ALTER TABLE `faq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `invoice_num` int NOT NULL AUTO_INCREMENT,
  `invoice_date` datetime DEFAULT NULL,
  `invoice_total_price` float DEFAULT NULL,
  `conNo` int DEFAULT NULL,
  `card_number` varchar(45) DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  `CCV_card` int DEFAULT NULL,
  `invoice_VNUM` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`invoice_num`),
  KEY `con_num1_idx` (`conNo`),
  KEY `V_num2_idx` (`invoice_VNUM`),
  KEY `user_id_idx` (`user_id`),
  CONSTRAINT `con_num1` FOREIGN KEY (`conNo`) REFERENCES `contract` (`Con_No`),
  CONSTRAINT `user_id1` FOREIGN KEY (`user_id`) REFERENCES `renter` (`Renter_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
INSERT INTO `invoice` VALUES (17,'2023-12-12 22:03:44',239.83,NULL,'5555555555555555','2025-10-12',NULL,1,1009154121),(18,'2023-12-12 22:08:13',240,NULL,'1','2025-10-12',NULL,1,1009154121),(19,'2023-12-12 22:09:05',239.83,NULL,'1','2025-10-12',NULL,1,1009154121),(20,'2023-12-12 22:10:53',239.83,NULL,'1','2025-10-12',NULL,1,1009154121),(21,'2023-12-12 22:12:31',239.83,NULL,'1','2023-10-12',NULL,1,1009154121),(22,'2023-12-12 22:14:13',239.83,NULL,'1','2025-10-12',NULL,1,1009154121),(23,'2023-12-12 22:16:34',479.83,NULL,'1','2025-10-12',NULL,1,1009154121),(24,'2023-12-12 22:17:24',240,NULL,'1','2025-10-12',NULL,1514,1009154121),(25,'2023-12-12 23:50:04',239.83,NULL,'1','2025-10-12',NULL,1,1009154121),(28,'2023-12-13 02:19:43',240,NULL,'1','2025-10-13',NULL,1,1009154121),(29,'2023-12-13 07:02:21',240,NULL,'1','2025-10-13',NULL,111,1009154121),(30,'2023-12-13 19:42:37',0.33,NULL,'1','2025-05-13',NULL,12541,1009154121),(31,'2023-12-13 19:43:55',10,NULL,'1','2025-10-13',NULL,125411,1009154121),(32,'2023-12-13 22:00:24',0.5,NULL,'1','2025-10-13',NULL,145698,1009154121),(33,'2023-12-13 23:36:43',0.33,NULL,'1','2025-10-13',NULL,5874,1009154121),(34,'2023-12-14 00:25:28',240,NULL,'1','2025-10-14',NULL,147258963,1009154121),(36,'2023-12-26 17:40:15',240,NULL,'5280786589658708','2025-10-26',NULL,1,1009154121),(37,'2023-12-26 17:51:54',479.83,NULL,'5435435435435678','2025-10-26',NULL,5874,1009154121),(38,'2023-12-27 11:23:31',239.83,NULL,'6543216543215432','2025-10-27',NULL,12541,1009521612),(39,'2023-12-27 17:20:26',250,NULL,'9876543219876543','2025-10-27',NULL,1234567891,1009521612),(40,'2023-12-27 21:06:31',240,NULL,'5555555555555555','2025-10-27',NULL,123456,1009521612);
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `owner`
--

DROP TABLE IF EXISTS `owner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `owner` (
  `owner_id` int NOT NULL,
  `owner_name` varchar(45) NOT NULL,
  `owner_phonenum` varchar(45) NOT NULL,
  `owner_bdate` datetime DEFAULT NULL,
  `owner_email` varchar(45) NOT NULL,
  `owner_picture_link` text,
  `owner_pass` varchar(45) NOT NULL,
  `owner_tos_agreement` tinyint NOT NULL,
  `otp` varchar(7) DEFAULT NULL,
  PRIMARY KEY (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `owner`
--

LOCK TABLES `owner` WRITE;
/*!40000 ALTER TABLE `owner` DISABLE KEYS */;
INSERT INTO `owner` VALUES (1,'asda','+966596636118',NULL,'www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fuser%2Fnull%2F1000000039.jpg?alt=media&token=0c0ccbf6-83c8-46d7-9467-f5b37b2f9dae','1',0,'886968'),(2,'qwer12e','+966596636118',NULL,'www.mt22arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fuser%2Fnull%2F1000000039.jpg?alt=media&token=0c0ccbf6-83c8-46d7-9467-f5b37b2f9dae','2',0,'174237'),(100165,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0,NULL),(1001655,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0,NULL),(1001656,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0,NULL),(1000000000,'asd','05092451051',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0,NULL),(1000000001,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0,NULL),(1000000003,'asd','0555555555','2001-10-23 00:00:00','www.mt2arab.com@gmail.com','','qweasdzxc',1,NULL),(1000000004,'123','0587546321','2003-10-23 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2FUsers%2F1000000004%2F1000000039.jpg?alt=media&token=f625d882-e7fc-40f8-b614-cb98b84985a6','asdqwezxc',1,NULL),(1000000009,'ali','0587465875','2000-10-03 00:00:00','nawaf@gmail.com','','qweasdzxc1',0,NULL),(1000000075,'asdf','0587215987','2023-10-12 00:00:00','www.mt2arab.com@gmail.com',NULL,'qwedsazxc',1,NULL),(1000000915,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0,NULL),(1000047896,'ali ali','0596636187','2000-10-02 00:00:00','nawaf99900040@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fuser%2Fnull%2F1000000033.png?alt=media&token=3f407490-585a-4f62-81da-84215f9314e3','Qwer123#q',0,NULL),(1009196587,'aqw','0509688147','2008-10-08 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23','1234567890',1,NULL),(1009198543,'asd','0596636287','2000-10-01 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fuser%2Fnull%2F1000000039.jpg?alt=media&token=8229bd77-227e-419e-b488-5cec82d53830','asdzxcqwe',1,NULL),(1009198760,'nawaf','0551245161','2000-10-01 00:00:00','www.mt2arab.com@gmail.com','','123456789',1,NULL),(1010101011,'qwe','0505050505','2005-10-26 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2FUsers%2F1010101011%2F1000000039.jpg?alt=media&token=90db62a0-6b09-4a41-a810-5585283fbb50','qwedsazxc',1,NULL),(1010101018,'123','0505922459','2005-10-26 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2FUsers%2F1010101018%2F1000000039.jpg?alt=media&token=a511a30d-39cb-428c-8222-479a3e9d414b','qweasdzxc',1,NULL),(1045698768,'ali','0596636118','2005-11-01 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2FUsers%2F1045698768%2F1000000039.jpg?alt=media&token=cc56729d-40b9-4fa2-b3d7-496c85230928','1234567890A',1,NULL),(1095432125,'alio','0596636118','2005-11-01 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2FUsers%2F1095432125%2F1000000039.jpg?alt=media&token=5f537507-3e8b-430b-91c1-3909beba3a1b','Qwzx@12345',1,'570441'),(1101320941,'fahad','0596636118','2005-11-01 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fuser%2Fnull%2F1000000035.png?alt=media&token=99e69f7c-b6e3-4c6b-bc9e-198c8ffca33c','qwer12345',1,'924667'),(1234567887,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0,NULL),(1234567890,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0,NULL),(1234567891,'asd','5987654321','2023-10-11 00:00:00','w@w.com',NULL,'qweasdzxc1',0,NULL),(1234567899,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0,NULL),(1478526385,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0,NULL),(1478965421,'asd','0555555555','2000-10-03 00:00:00','nawaf99900040@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fuser%2F1478965421%2F1000000033.png?alt=media&token=5f203df6-939a-4d67-8f8e-bd1e22df360a','qweasdzxc',1,NULL),(1512364125,'asd','5487512415','2023-10-11 00:00:00','www.mt2arab.com@gmail.com',NULL,'qazwsxedcr',0,NULL),(1578898425,'qwe','0596872154','1990-10-17 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2FUsers%2F15788984257%2F1000000033.png?alt=media&token=7c77c112-e332-47d0-80d4-2bff15bbe6a7','1009196587',1,NULL),(1598632147,'qwe','+966596636118','2004-10-01 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2FUsers%2F1598632147%2F1000000039.jpg?alt=media&token=ac43c47b-6609-4fda-8ad6-566e00c7053c','asdzxcqwe',1,NULL),(1963210450,'nawaf','0505922041','2000-10-01 00:00:00','www.mt2arab.com@gmail.com','','0505421651',1,NULL);
/*!40000 ALTER TABLE `owner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `renter`
--

DROP TABLE IF EXISTS `renter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `renter` (
  `Renter_ID` int NOT NULL,
  `Renter_Name` varchar(45) NOT NULL,
  `Renter_Phone_No` varchar(45) NOT NULL,
  `Renter_Bdate` datetime NOT NULL,
  `Renter_Email` varchar(45) NOT NULL,
  `Renter_picture_link` text NOT NULL,
  `Renter_pass` varchar(45) NOT NULL,
  `Renter_tos_agreement` tinyint NOT NULL,
  `otp` varchar(7) DEFAULT NULL,
  PRIMARY KEY (`Renter_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `renter`
--

LOCK TABLES `renter` WRITE;
/*!40000 ALTER TABLE `renter` DISABLE KEYS */;
INSERT INTO `renter` VALUES (1009154121,'asdf','0540000000','1990-10-01 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fuser%2F1009154121%2F1000000035.png?alt=media&token=3c70417f-877b-42aa-ad9a-a06d32a1d0dd','1ghfdxczb',1,'399953'),(1009521612,'nawaf9','0596636118','2000-12-08 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2FUsers%2F1009521612%2F1000000034.png?alt=media&token=c22fc387-6a6a-4d29-b43b-ad514cd56ec7','Admin@2av2',1,'425845'),(1123658074,'Abdullah','0596636118','2005-11-01 00:00:00','aask1999s@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2FUsers%2F1123658074%2F1000000039.jpg?alt=media&token=c34d583c-882e-4dd0-93e3-a527948e2b14','Qwe123asd@',1,NULL),(1236547890,'asd','0505050505','2004-10-02 00:00:00','w@w.www','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2FUsers%2F1236547890%2F1000000039.jpg?alt=media&token=c17ec692-bd69-4e79-a4c7-a689f6b4a973','Qweasd,,,,',1,NULL);
/*!40000 ALTER TABLE `renter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `RESno` int NOT NULL AUTO_INCREMENT,
  `RES_DateTime_start` datetime NOT NULL,
  `RES_Status` varchar(45) NOT NULL,
  `V_num_RES` int DEFAULT NULL,
  `V_Renter_Id` int DEFAULT NULL,
  `RES_DateTime_end` datetime NOT NULL,
  PRIMARY KEY (`RESno`),
  KEY `v_num_R_idx` (`V_num_RES`),
  KEY `v_renter_idx` (`V_Renter_Id`),
  CONSTRAINT `v_num_R` FOREIGN KEY (`V_num_RES`) REFERENCES `vehicle` (`V_num`),
  CONSTRAINT `v_renter` FOREIGN KEY (`V_Renter_Id`) REFERENCES `renter` (`Renter_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES (1,'2023-12-12 22:16:22','canceled',1,1009154121,'2023-12-14 22:16:00'),(2,'2023-12-13 22:17:00','canceled',1514,1009154121,'2023-12-14 22:17:00'),(3,'2023-12-12 23:49:52','canceled',1,1009154121,'2023-12-13 23:49:00'),(4,'2023-12-13 02:19:00','expired',1,1009154121,'2023-12-14 02:19:00'),(6,'2023-12-13 19:42:00','expired',12541,1009154121,'2023-12-13 20:00:00'),(7,'2023-12-14 19:43:00','expired',125411,1009154121,'2023-12-14 19:43:00'),(8,'2023-12-13 22:00:00','canceled',145698,1009154121,'2023-12-13 22:00:00');
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservations_archive`
--

DROP TABLE IF EXISTS `reservations_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservations_archive` (
  `RESno` int NOT NULL AUTO_INCREMENT,
  `RES_DateTime_start` datetime NOT NULL,
  `RES_Status` varchar(45) NOT NULL,
  `V_num_RES` int DEFAULT NULL,
  `V_Renter_Id` int DEFAULT NULL,
  `RES_DateTime_end` datetime NOT NULL,
  `RESno_old` int DEFAULT NULL,
  PRIMARY KEY (`RESno`),
  KEY `v_num_R_idx` (`V_num_RES`),
  KEY `v_renter_idx` (`V_Renter_Id`),
  CONSTRAINT `v_num_R1` FOREIGN KEY (`V_num_RES`) REFERENCES `vehicle` (`V_num`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_renter1` FOREIGN KEY (`V_Renter_Id`) REFERENCES `renter` (`Renter_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations_archive`
--

LOCK TABLES `reservations_archive` WRITE;
/*!40000 ALTER TABLE `reservations_archive` DISABLE KEYS */;
INSERT INTO `reservations_archive` VALUES (13,'2023-12-27 21:05:00','active',123456,1009521612,'2023-12-28 21:05:00',15),(14,'2023-12-27 21:05:00','active',123456,1009521612,'2023-12-28 21:05:00',15),(15,'2023-12-27 21:05:00','active',123456,1009521612,'2023-12-28 21:05:00',15),(16,'2023-12-27 21:05:00','active',123456,1009521612,'2023-12-28 21:05:00',15),(17,'2023-12-27 21:05:00','active',123456,1009521612,'2023-12-28 21:05:00',15),(18,'2023-12-27 21:05:00','active',123456,1009521612,'2023-12-28 21:05:00',15),(19,'2023-12-27 21:05:00','active',123456,1009521612,'2023-12-28 21:05:00',15),(20,'2023-12-27 21:05:00','active',123456,1009521612,'2023-12-28 21:05:00',15),(21,'2023-12-27 21:05:00','active',123456,1009521612,'2023-12-28 21:05:00',15),(22,'2023-12-30 21:09:00','pending',1234567891,1009521612,'2023-12-31 21:09:00',14),(23,'2023-12-31 17:22:00','pending',12541,1009521612,'2024-01-01 17:22:00',13),(24,'2023-12-26 17:16:00','active',1,1009154121,'2023-12-27 17:16:00',11),(25,'2023-12-26 17:40:49','active',5874,1009154121,'2023-12-28 17:40:00',12),(26,'2023-12-14 00:00:00','expired',147258963,1009154121,'2023-12-17 00:25:00',10),(27,'2023-12-13 07:02:00','expired',111,1009154121,'2023-12-14 07:02:00',5),(28,'2023-12-13 23:36:00','expired',5874,1009154121,'2023-12-13 23:36:00',9);
/*!40000 ALTER TABLE `reservations_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle`
--

DROP TABLE IF EXISTS `vehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle` (
  `V_num` int NOT NULL,
  `V_Name` varchar(50) DEFAULT NULL,
  `V_Model` varchar(31) DEFAULT NULL,
  `V_Type` varchar(15) DEFAULT NULL,
  `V_Status` tinyint DEFAULT '0',
  `V_Location` varchar(100) DEFAULT NULL,
  `V_Battery` varchar(3) DEFAULT NULL,
  `V_Rate` double DEFAULT NULL,
  `V_EV` tinyint DEFAULT NULL,
  `owner_id_V` int DEFAULT NULL,
  `V_pictures_front` text,
  `V_pictures_back` text,
  `V_pictures_left` text,
  `V_pictures_right` text,
  PRIMARY KEY (`V_num`),
  KEY `owner_idx` (`owner_id_V`),
  CONSTRAINT `owner_id_V` FOREIGN KEY (`owner_id_V`) REFERENCES `owner` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle`
--

LOCK TABLES `vehicle` WRITE;
/*!40000 ALTER TABLE `vehicle` DISABLE KEYS */;
INSERT INTO `vehicle` VALUES (1,'gw','g','size-big',0,'test','1',10,1,1,'https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23'),(111,'g','g','size-big',0,NULL,NULL,10,1,NULL,NULL,NULL,NULL,NULL),(1514,'nawaf','asd','size-big',0,NULL,NULL,10,1,NULL,'https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fvheicle%2F1514%2F1%2F1000000039.jpg?alt=media&token=14b4924f-55da-427c-a616-2c4cc3eaefcf',NULL,NULL,NULL),(5236,'ghfa1g','ghj','size-big',0,NULL,NULL,10,1,1,NULL,NULL,NULL,NULL),(5874,'gyt','mnb','size-small',0,NULL,NULL,10,1,1000000075,NULL,NULL,NULL,NULL),(12541,'tre','tat','size-big',0,NULL,NULL,10,0,1478965421,NULL,NULL,NULL,NULL),(15421,'gh','gg','size-big',0,NULL,NULL,10,1,100165,NULL,NULL,NULL,NULL),(123456,'test','asdqw','size-big',0,NULL,NULL,10,1,1000000075,NULL,NULL,NULL,NULL),(125411,'tre','tat','size-big',0,NULL,NULL,10,0,1478965421,NULL,NULL,NULL,NULL),(145698,'rewq','asdzxc','size-big',0,'test','1',10,1,1000000075,NULL,NULL,NULL,NULL),(147158,'new','bike','size-big',0,NULL,NULL,10,1,1000047896,NULL,NULL,NULL,NULL),(1254114,'tre','tat','size-big',0,NULL,NULL,10,0,1478965421,NULL,NULL,NULL,NULL),(1564312,'asd','dsa','size-big',0,NULL,NULL,15,0,1,'',NULL,NULL,NULL),(12541145,'tre','tat','size-big',0,NULL,NULL,10,0,1478965421,'https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fvehicle%2F1478965421%2F1254114%2F1000000033.png?alt=media&token=197ed69e-f25c-4b8c-a775-d2fb0a153c31',NULL,NULL,NULL),(100000000,'hgfd','fghj','size-small',0,NULL,NULL,10,1,2,NULL,NULL,NULL,NULL),(125411456,'tre','tat','size-big',0,NULL,NULL,20.59,0,1478965421,'https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fvehicle%2F1478965421%2F12541145%2F1000000033.png?alt=media&token=360ff4a0-fad1-43c2-9587-2b305d5331d8',NULL,NULL,NULL),(147258963,'qwea','fsd','size-big',0,NULL,NULL,10,1,1009196587,NULL,NULL,NULL,NULL),(1000000000,'hgfd','fghj','size-big',0,NULL,NULL,10,1,2,NULL,NULL,NULL,NULL),(1009512360,'hgt','kiju','size-small',0,NULL,NULL,10,1,1009196587,NULL,NULL,NULL,NULL),(1234567891,'help','aszx','size-big',0,'Location','100',10,1,1009196587,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `vehicle` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-27 23:25:31

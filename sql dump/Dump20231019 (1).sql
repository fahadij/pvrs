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
-- Table structure for table `complaints`
--

DROP TABLE IF EXISTS `complaints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `complaints` (
  `complaint_no` int NOT NULL,
  `complaint_sub` varchar(200) NOT NULL,
  `complaint_date` varchar(200) NOT NULL,
  `complaint_description` varchar(2000) NOT NULL,
  `owner_id` int NOT NULL,
  `renter_id` int NOT NULL,
  PRIMARY KEY (`complaint_no`),
  KEY `owner_id_idx` (`owner_id`),
  KEY `renter_id_idx` (`renter_id`),
  CONSTRAINT `owner_id` FOREIGN KEY (`owner_id`) REFERENCES `owner` (`owner_id`),
  CONSTRAINT `renter_id` FOREIGN KEY (`renter_id`) REFERENCES `renter` (`Renter_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `complaints`
--

LOCK TABLES `complaints` WRITE;
/*!40000 ALTER TABLE `complaints` DISABLE KEYS */;
/*!40000 ALTER TABLE `complaints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract`
--

DROP TABLE IF EXISTS `contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract` (
  `Con_No` int NOT NULL,
  `Con_Date_of_issue` varchar(45) DEFAULT NULL,
  `Con_Beginning_of_Rent_date` varchar(45) DEFAULT NULL,
  `Con_End_of_Rent_date` varchar(45) DEFAULT NULL,
  `Conf_Rent_date` varchar(45) DEFAULT NULL,
  `Con_ToS_agreement` tinyint DEFAULT NULL,
  `Res_num` int DEFAULT NULL,
  PRIMARY KEY (`Con_No`),
  KEY `res_num_idx` (`Res_num`),
  CONSTRAINT `res_num` FOREIGN KEY (`Res_num`) REFERENCES `reservation` (`RESno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract`
--

LOCK TABLES `contract` WRITE;
/*!40000 ALTER TABLE `contract` DISABLE KEYS */;
INSERT INTO `contract` VALUES (10,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `contract` ENABLE KEYS */;
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
  `faq_num` int NOT NULL,
  PRIMARY KEY (`faq_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faq`
--

LOCK TABLES `faq` WRITE;
/*!40000 ALTER TABLE `faq` DISABLE KEYS */;
INSERT INTO `faq` VALUES ('asd','123',1),('asd','asd',2),('asad','test',12);
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
  `user_id` int DEFAULT NULL,
  `card_number` varchar(45) DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  PRIMARY KEY (`invoice_num`),
  KEY `Con_no_idx` (`conNo`),
  KEY `User_id_idx` (`user_id`),
  CONSTRAINT `conNo12` FOREIGN KEY (`conNo`) REFERENCES `contract` (`Con_No`),
  CONSTRAINT `User_id_` FOREIGN KEY (`user_id`) REFERENCES `owner` (`owner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
INSERT INTO `invoice` VALUES (3,'2023-10-18 19:36:36',3110,10,1009196587,'154789632541','2025-10-18'),(4,'2023-10-18 22:55:55',2870,NULL,1009196587,'51124120120','2035-10-18'),(5,'2023-10-18 23:11:48',3110,NULL,1009196587,'54779800','2025-10-18');
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
  PRIMARY KEY (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `owner`
--

LOCK TABLES `owner` WRITE;
/*!40000 ALTER TABLE `owner` DISABLE KEYS */;
INSERT INTO `owner` VALUES (1,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(2,'qwer12e','0512457863',NULL,'help@gmail.com',NULL,'2',0),(100165,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1001655,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1001656,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1000000000,'asd','05092451051',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1000000001,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1000000075,'asdf','0587215987','2023-10-12 00:00:00','www.mt2arab.com@gmail.com',NULL,'qwedsazxc',1),(1000000915,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1009196587,'aqw','0509688147','2008-10-08 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23','1234567890',1),(1234567887,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1234567890,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1234567891,'asd','5987654321','2023-10-11 00:00:00','w@w.com',NULL,'qweasdzxc1',0),(1234567899,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1478526385,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1512364125,'asd','5487512415','2023-10-11 00:00:00','www.mt2arab.com@gmail.com',NULL,'qazwsxedcr',0),(1578898425,'qwe','0596872154','1990-10-17 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2FUsers%2F15788984257%2F1000000033.png?alt=media&token=7c77c112-e332-47d0-80d4-2bff15bbe6a7','1009196587',1);
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
  `Renter_ID_Pic` blob NOT NULL,
  PRIMARY KEY (`Renter_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `renter`
--

LOCK TABLES `renter` WRITE;
/*!40000 ALTER TABLE `renter` DISABLE KEYS */;
/*!40000 ALTER TABLE `renter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `RESno` int NOT NULL,
  `RES_Time` datetime NOT NULL,
  `RES_Date` datetime NOT NULL,
  `RES_Status` varchar(45) NOT NULL,
  `V_num_RES` int DEFAULT NULL,
  `V_Renter_Id` int DEFAULT NULL,
  PRIMARY KEY (`RESno`),
  KEY `v_num_R_idx` (`V_num_RES`),
  KEY `v_renter_idx` (`V_Renter_Id`),
  CONSTRAINT `v_num_R` FOREIGN KEY (`V_num_RES`) REFERENCES `vehicle` (`V_num`),
  CONSTRAINT `v_renter` FOREIGN KEY (`V_Renter_Id`) REFERENCES `renter` (`Renter_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
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
  `V_Status` varchar(31) DEFAULT NULL,
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
INSERT INTO `vehicle` VALUES (1,'g','g','size-big','test','test','1',10,1,1,'https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23'),(111,'g','g','size-big',NULL,NULL,NULL,10,1,NULL,NULL,NULL,NULL,NULL),(1514,'nawaf','asd','size-big',NULL,NULL,NULL,10,1,NULL,NULL,NULL,NULL,NULL),(5236,'ghf','ghj','size-big',NULL,NULL,NULL,10,1,1,NULL,NULL,NULL,NULL),(5874,'gyt','mnb','size-small',NULL,NULL,NULL,10,1,1000000075,NULL,NULL,NULL,NULL),(15421,'gh','gg','size-big',NULL,NULL,NULL,10,1,100165,NULL,NULL,NULL,NULL),(123456,'test','asdqw','size-big',NULL,NULL,NULL,10,1,1000000075,NULL,NULL,NULL,NULL),(145698,'rewq','asdzxc','size-big','test','test','1',10,1,1000000075,NULL,NULL,NULL,NULL),(100000000,'hgfd','fghj','size-small',NULL,NULL,NULL,10,1,2,NULL,NULL,NULL,NULL),(147258963,'qwea','fsd','size-big',NULL,NULL,NULL,10,1,1009196587,NULL,NULL,NULL,NULL),(1000000000,'hgfd','fghj','size-big',NULL,NULL,NULL,10,1,2,NULL,NULL,NULL,NULL),(1009512360,'hgt','kiju','size-small',NULL,NULL,NULL,10,1,1009196587,NULL,NULL,NULL,NULL),(1234567891,'help','aszx','size-big','A','Location','100',10,1,1009196587,NULL,NULL,NULL,NULL);
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

-- Dump completed on 2023-10-19  1:11:55

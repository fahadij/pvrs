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
  `complaint_no` int NOT NULL AUTO_INCREMENT,
  `complaint_sub` text NOT NULL,
  `complaint_date` datetime NOT NULL,
  `complaint_description` varchar(2000) NOT NULL,
  `owner_id` int DEFAULT NULL,
  `renter_id` int DEFAULT NULL,
  PRIMARY KEY (`complaint_no`),
  KEY `owner_id_idx` (`owner_id`),
  KEY `renter_id_idx` (`renter_id`),
  CONSTRAINT `owner_id` FOREIGN KEY (`owner_id`) REFERENCES `owner` (`owner_id`),
  CONSTRAINT `renter_id` FOREIGN KEY (`renter_id`) REFERENCES `renter` (`Renter_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `complaints`
--

LOCK TABLES `complaints` WRITE;
/*!40000 ALTER TABLE `complaints` DISABLE KEYS */;
INSERT INTO `complaints` VALUES (1,'asasdasdads','2023-10-20 13:30:39','asas',1,NULL),(2,'1234','2023-10-20 13:40:00','test',1,NULL),(3,'asdadsadsads','2023-10-20 20:05:57','adsdasads',1478965421,NULL);
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
  PRIMARY KEY (`Con_No`),
  KEY `res_num_idx` (`Res_num`),
  CONSTRAINT `res_num` FOREIGN KEY (`Res_num`) REFERENCES `reservation` (`RESno`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `faq_num` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`faq_num`)
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faq`
--

LOCK TABLES `faq` WRITE;
/*!40000 ALTER TABLE `faq` DISABLE KEYS */;
INSERT INTO `faq` VALUES ('asd','123',1),('asad','test',12),('DSA','ASD',121),('zxds','qwas',130);
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
  `CCV_card` int DEFAULT NULL,
  `invoice_VNUM` int DEFAULT NULL,
  PRIMARY KEY (`invoice_num`),
  KEY `User_id_idx` (`user_id`),
  KEY `con_num1_idx` (`conNo`),
  KEY `V_num2_idx` (`invoice_VNUM`),
  CONSTRAINT `con_num1` FOREIGN KEY (`conNo`) REFERENCES `contract` (`Con_No`),
  CONSTRAINT `User_id_` FOREIGN KEY (`user_id`) REFERENCES `owner` (`owner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
INSERT INTO `invoice` VALUES (3,'2023-10-18 19:36:36',3110,10,1009196587,'154789632541','2025-10-18',NULL,NULL),(4,'2023-10-18 22:55:55',2870,NULL,1009196587,'51124120120','2035-10-18',NULL,NULL),(5,'2023-10-18 23:11:48',3110,NULL,1009196587,'54779800','2025-10-18',NULL,NULL),(6,'2023-10-19 17:09:00',2870,NULL,1578898425,'5432123456','2027-10-19',NULL,NULL),(7,'2023-10-19 21:28:45',249.67,NULL,1000047896,'4594785789657855','2023-10-19',NULL,NULL),(8,'2023-10-21 21:12:27',9.83,NULL,1,'231321312312312312','2023-10-21',NULL,NULL),(9,'2023-10-22 12:51:05',9.83,NULL,1,'3212312322311111','2022-10-22',NULL,NULL),(10,'2023-10-22 12:56:25',9.83,NULL,1,'3212312322311112','2022-10-22',NULL,NULL),(11,'2023-10-22 21:10:23',9.83,NULL,1,'1321323123213211','2021-10-22',NULL,1),(12,'2023-10-22 22:08:46',9.83,NULL,1,'5425212121212514','2022-10-22',NULL,1514);
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
INSERT INTO `owner` VALUES (1,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fuser%2Fnull%2F1000000039.jpg?alt=media&token=0c0ccbf6-83c8-46d7-9467-f5b37b2f9dae','1',0),(2,'qwer12e','0512457863',NULL,'help@gmail.com',NULL,'2',0),(100165,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1001655,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1001656,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1000000000,'asd','05092451051',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1000000001,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1000000009,'ali','0587465875','2000-10-03 00:00:00','nawaf@gmail.com','','qweasdzxc1',0),(1000000075,'asdf','0587215987','2023-10-12 00:00:00','www.mt2arab.com@gmail.com',NULL,'qwedsazxc',1),(1000000915,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1000047896,'ali ali','0596636187','2000-10-02 00:00:00','nawaf99900040@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fuser%2Fnull%2F1000000033.png?alt=media&token=3f407490-585a-4f62-81da-84215f9314e3','Qwer123#q',0),(1009196587,'aqw','0509688147','2008-10-08 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23','1234567890',1),(1234567887,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1234567890,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1234567891,'asd','5987654321','2023-10-11 00:00:00','w@w.com',NULL,'qweasdzxc1',0),(1234567899,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1478526385,'asd','0509245105',NULL,'www.mt2arab.com@gmail.com',NULL,'asdfghjkl;',0),(1478965421,'asd','0555555555','2000-10-03 00:00:00','nawaf99900040@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fuser%2F1478965421%2F1000000033.png?alt=media&token=5f203df6-939a-4d67-8f8e-bd1e22df360a','qweasdzxc',1),(1512364125,'asd','5487512415','2023-10-11 00:00:00','www.mt2arab.com@gmail.com',NULL,'qazwsxedcr',0),(1578898425,'qwe','0596872154','1990-10-17 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2FUsers%2F15788984257%2F1000000033.png?alt=media&token=7c77c112-e332-47d0-80d4-2bff15bbe6a7','1009196587',1);
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
  `Renter_tos_agreement` varchar(45) NOT NULL,
  PRIMARY KEY (`Renter_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `renter`
--

LOCK TABLES `renter` WRITE;
/*!40000 ALTER TABLE `renter` DISABLE KEYS */;
INSERT INTO `renter` VALUES (1009154121,'asdf','05056875421','1990-10-01 00:00:00','www.mt2arab.com@gmail.com','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fuser%2F1009154121%2F1000000035.png?alt=media&token=3c70417f-877b-42aa-ad9a-a06d32a1d0dd','1qwertyui','1');
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
INSERT INTO `vehicle` VALUES (1,'g','g','size-big',0,'test','1',10,1,1,'https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23','https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fnull%2F1000000034.png?alt=media&token=529b684c-2a6a-4d11-9a3a-ea7202c5ad23'),(111,'g','g','size-big',0,NULL,NULL,10,1,NULL,NULL,NULL,NULL,NULL),(1514,'nawaf','asd','size-big',0,NULL,NULL,10,1,NULL,'https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fvheicle%2F1514%2F1%2F1000000039.jpg?alt=media&token=14b4924f-55da-427c-a616-2c4cc3eaefcf',NULL,NULL,NULL),(5236,'ghf','ghj','size-big',0,NULL,NULL,10,1,1,NULL,NULL,NULL,NULL),(5874,'gyt','mnb','size-small',0,NULL,NULL,10,1,1000000075,NULL,NULL,NULL,NULL),(12541,'tre','tat','size-big',0,NULL,NULL,10,0,1478965421,NULL,NULL,NULL,NULL),(15421,'gh','gg','size-big',0,NULL,NULL,10,1,100165,NULL,NULL,NULL,NULL),(123456,'test','asdqw','size-big',0,NULL,NULL,10,1,1000000075,NULL,NULL,NULL,NULL),(125411,'tre','tat','size-big',0,NULL,NULL,10,0,1478965421,NULL,NULL,NULL,NULL),(145698,'rewq','asdzxc','size-big',0,'test','1',10,1,1000000075,NULL,NULL,NULL,NULL),(147158,'new','bike','size-big',0,NULL,NULL,10,1,1000047896,NULL,NULL,NULL,NULL),(1254114,'tre','tat','size-big',0,NULL,NULL,10,0,1478965421,NULL,NULL,NULL,NULL),(12541145,'tre','tat','size-big',0,NULL,NULL,10,0,1478965421,'https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fvehicle%2F1478965421%2F1254114%2F1000000033.png?alt=media&token=197ed69e-f25c-4b8c-a775-d2fb0a153c31',NULL,NULL,NULL),(100000000,'hgfd','fghj','size-small',0,NULL,NULL,10,1,2,NULL,NULL,NULL,NULL),(125411456,'tre','tat','size-big',0,NULL,NULL,20.59,0,1478965421,'https://firebasestorage.googleapis.com/v0/b/pvre-1425a.appspot.com/o/images%2Fvehicle%2F1478965421%2F12541145%2F1000000033.png?alt=media&token=360ff4a0-fad1-43c2-9587-2b305d5331d8',NULL,NULL,NULL),(147258963,'qwea','fsd','size-big',0,NULL,NULL,10,1,1009196587,NULL,NULL,NULL,NULL),(1000000000,'hgfd','fghj','size-big',0,NULL,NULL,10,1,2,NULL,NULL,NULL,NULL),(1009512360,'hgt','kiju','size-small',0,NULL,NULL,10,1,1009196587,NULL,NULL,NULL,NULL),(1234567891,'help','aszx','size-big',0,'Location','100',10,1,1009196587,NULL,NULL,NULL,NULL);
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

-- Dump completed on 2023-10-22 22:26:11

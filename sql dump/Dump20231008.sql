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
  `complaint_sub` int NOT NULL,
  `complaint_date` int NOT NULL,
  `complaint_description` int NOT NULL,
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
  `Con_ToS_agreement` varchar(45) DEFAULT NULL,
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
/*!40000 ALTER TABLE `contract` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faq`
--

DROP TABLE IF EXISTS `faq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faq` (
  `FAQ_No` int NOT NULL,
  `FAQ_Content` varchar(200) NOT NULL,
  PRIMARY KEY (`FAQ_No`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faq`
--

LOCK TABLES `faq` WRITE;
/*!40000 ALTER TABLE `faq` DISABLE KEYS */;
/*!40000 ALTER TABLE `faq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `invoice_num` int NOT NULL,
  `invoice_time` int NOT NULL,
  `invoice_date` int NOT NULL,
  `invoice_total_price` int NOT NULL,
  `conNo` int NOT NULL,
  PRIMARY KEY (`invoice_num`),
  KEY `Con_no_idx` (`conNo`),
  CONSTRAINT `Con_no` FOREIGN KEY (`conNo`) REFERENCES `contract` (`Con_No`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
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
  `owner_name` varchar(45) DEFAULT NULL,
  `owner_phonenum` varchar(45) DEFAULT NULL,
  `owner_bdate` datetime DEFAULT NULL,
  `owner_email` varchar(45) DEFAULT NULL,
  `owner_id_picture` blob,
  `owner_pass` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `owner`
--

LOCK TABLES `owner` WRITE;
/*!40000 ALTER TABLE `owner` DISABLE KEYS */;
INSERT INTO `owner` VALUES (1001,'nawaf','5874',NULL,'www.mt2arab.com@gmail.com',NULL,NULL),(100165,'nawaf','5874',NULL,'www.mt22arab.com@gmail.com',NULL,NULL),(1001655,'nawaf','58746',NULL,'www.mt22arab.com@gmail.com',NULL,'asad'),(1001656,'nawaf','58746',NULL,'www.mt22arab.com@gmail.com',NULL,NULL);
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
  `V_Name` varchar(50) NOT NULL,
  `V_Model` varchar(31) NOT NULL,
  `V_Type` varchar(15) NOT NULL,
  `V_Status` varchar(31) NOT NULL,
  `V_Location` varchar(100) NOT NULL,
  `V_Battery` varchar(3) NOT NULL,
  `V_Rate` varchar(7) NOT NULL,
  `V_EV` tinyint DEFAULT NULL,
  `owner_id_V` int DEFAULT NULL,
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
/*!40000 ALTER TABLE `vehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'pvers'
--

--
-- Dumping routines for database 'pvers'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-08 18:20:10

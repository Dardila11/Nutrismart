CREATE DATABASE  IF NOT EXISTS `db_nutrismart` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `db_nutrismart`;
-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: localhost    Database: db_nutrismart
-- ------------------------------------------------------
-- Server version	5.7.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `CARENCIAS`
--

DROP TABLE IF EXISTS `CARENCIAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CARENCIAS` (
  `car_id` int(11) NOT NULL AUTO_INCREMENT,
  `nut_id` int(11) NOT NULL,
  `car_numpersonas` int(11) DEFAULT NULL,
  `com_id` int(11) DEFAULT NULL,
  `car_porcentaje` int(11) DEFAULT NULL,
  `tipo_persona` int(11) DEFAULT NULL,
  PRIMARY KEY (`car_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CARENCIAS`
--

LOCK TABLES `CARENCIAS` WRITE;
/*!40000 ALTER TABLE `CARENCIAS` DISABLE KEYS */;
/*!40000 ALTER TABLE `CARENCIAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COMUNAS`
--

DROP TABLE IF EXISTS `COMUNAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `COMUNAS` (
  `com_id` int(11) NOT NULL,
  `com_nombre` varchar(45) NOT NULL,
  PRIMARY KEY (`com_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COMUNAS`
--

LOCK TABLES `COMUNAS` WRITE;
/*!40000 ALTER TABLE `COMUNAS` DISABLE KEYS */;
INSERT INTO `COMUNAS` VALUES (1,'comuna1');
INSERT INTO `COMUNAS` VALUES (2,'comuna2');
INSERT INTO `COMUNAS` VALUES (3,'comuna3');
INSERT INTO `COMUNAS` VALUES (4,'comuna4');
/*!40000 ALTER TABLE `COMUNAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DATOSCOM`
--

DROP TABLE IF EXISTS `DATOSCOM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DATOSCOM` (
  `datcom_id` int(11) NOT NULL AUTO_INCREMENT,
  `com_id` int(11) DEFAULT NULL,
  `com_cantidad_total` int(11) DEFAULT NULL,
  `com_cant_ninos` int(11) DEFAULT NULL,
  `com_cant_ninosdes` int(11) DEFAULT NULL,
  `com_cant_ancianos` int(11) DEFAULT NULL,
  `com_cant_ancianosdes` int(11) DEFAULT NULL,
  PRIMARY KEY (`datcom_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DATOSCOM`
--

LOCK TABLES `DATOSCOM` WRITE;
/*!40000 ALTER TABLE `DATOSCOM` DISABLE KEYS */;
INSERT INTO `DATOSCOM` VALUES (1,2,1000,300,150,200,180);
INSERT INTO `DATOSCOM` VALUES (2,1,1000,200,150,300,200);
INSERT INTO `DATOSCOM` VALUES (3,1,1000,300,150,200,100);
/*!40000 ALTER TABLE `DATOSCOM` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DATOSGAL`
--

DROP TABLE IF EXISTS `DATOSGAL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DATOSGAL` (
  `dat_id` int(11) NOT NULL AUTO_INCREMENT,
  `gal_id` int(11) DEFAULT NULL,
  `fru_id` int(11) DEFAULT NULL,
  `dat_ingresa` int(11) DEFAULT NULL,
  `dat_desperdicia` int(11) DEFAULT NULL,
  PRIMARY KEY (`dat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DATOSGAL`
--

LOCK TABLES `DATOSGAL` WRITE;
/*!40000 ALTER TABLE `DATOSGAL` DISABLE KEYS */;
INSERT INTO `DATOSGAL` VALUES (1,2,1,100,50);
INSERT INTO `DATOSGAL` VALUES (2,2,2,150,20);
INSERT INTO `DATOSGAL` VALUES (3,1,4,200,100);
INSERT INTO `DATOSGAL` VALUES (4,2,3,1223,23434);
INSERT INTO `DATOSGAL` VALUES (5,1,6,100,20);
/*!40000 ALTER TABLE `DATOSGAL` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DATOSNUT`
--

DROP TABLE IF EXISTS `DATOSNUT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DATOSNUT` (
  `datnut_id` int(11) NOT NULL AUTO_INCREMENT,
  `nut_id` int(11) DEFAULT NULL,
  `nut_aporte` decimal(10,2) DEFAULT NULL,
  `fru_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`datnut_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DATOSNUT`
--

LOCK TABLES `DATOSNUT` WRITE;
/*!40000 ALTER TABLE `DATOSNUT` DISABLE KEYS */;
INSERT INTO `DATOSNUT` VALUES (1,2,900.00,6);
/*!40000 ALTER TABLE `DATOSNUT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FRUTAS`
--

DROP TABLE IF EXISTS `FRUTAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FRUTAS` (
  `fru_id` int(11) NOT NULL AUTO_INCREMENT,
  `fru_nombre` varchar(45) NOT NULL,
  PRIMARY KEY (`fru_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FRUTAS`
--

LOCK TABLES `FRUTAS` WRITE;
/*!40000 ALTER TABLE `FRUTAS` DISABLE KEYS */;
INSERT INTO `FRUTAS` VALUES (1,'manzana');
INSERT INTO `FRUTAS` VALUES (2,'naranja');
INSERT INTO `FRUTAS` VALUES (3,'banano');
INSERT INTO `FRUTAS` VALUES (4,'papaya');
INSERT INTO `FRUTAS` VALUES (5,'mango');
INSERT INTO `FRUTAS` VALUES (6,'queso');
/*!40000 ALTER TABLE `FRUTAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GALERIAS`
--

DROP TABLE IF EXISTS `GALERIAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GALERIAS` (
  `gal_id` int(11) NOT NULL AUTO_INCREMENT,
  `gal_nombre` varchar(45) NOT NULL,
  PRIMARY KEY (`gal_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GALERIAS`
--

LOCK TABLES `GALERIAS` WRITE;
/*!40000 ALTER TABLE `GALERIAS` DISABLE KEYS */;
INSERT INTO `GALERIAS` VALUES (1,'Bolivar');
INSERT INTO `GALERIAS` VALUES (2,'Esmeralda');
/*!40000 ALTER TABLE `GALERIAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `NUTRIENTES`
--

DROP TABLE IF EXISTS `NUTRIENTES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `NUTRIENTES` (
  `nut_id` int(11) NOT NULL AUTO_INCREMENT,
  `nut_nombre` varchar(45) NOT NULL,
  PRIMARY KEY (`nut_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NUTRIENTES`
--

LOCK TABLES `NUTRIENTES` WRITE;
/*!40000 ALTER TABLE `NUTRIENTES` DISABLE KEYS */;
INSERT INTO `NUTRIENTES` VALUES (1,'potasio');
INSERT INTO `NUTRIENTES` VALUES (2,'calcio');
INSERT INTO `NUTRIENTES` VALUES (3,'magnesio');
/*!40000 ALTER TABLE `NUTRIENTES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PERSONAS`
--

DROP TABLE IF EXISTS `PERSONAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PERSONAS` (
  `per_id` int(11) NOT NULL AUTO_INCREMENT,
  `per_tipo` varchar(45) NOT NULL,
  PRIMARY KEY (`per_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PERSONAS`
--

LOCK TABLES `PERSONAS` WRITE;
/*!40000 ALTER TABLE `PERSONAS` DISABLE KEYS */;
INSERT INTO `PERSONAS` VALUES (1,'niño');
INSERT INTO `PERSONAS` VALUES (2,'anciano');
/*!40000 ALTER TABLE `PERSONAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REFERENCIAS`
--

DROP TABLE IF EXISTS `REFERENCIAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `REFERENCIAS` (
  `ref_id` int(11) NOT NULL AUTO_INCREMENT,
  `per_id` int(11) DEFAULT NULL,
  `nut_id` int(11) DEFAULT NULL,
  `ref_referencia` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ref_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REFERENCIAS`
--

LOCK TABLES `REFERENCIAS` WRITE;
/*!40000 ALTER TABLE `REFERENCIAS` DISABLE KEYS */;
INSERT INTO `REFERENCIAS` VALUES (1,1,1,3800.00);
INSERT INTO `REFERENCIAS` VALUES (2,2,1,4700.00);
INSERT INTO `REFERENCIAS` VALUES (3,1,2,800.00);
INSERT INTO `REFERENCIAS` VALUES (4,2,2,1200.00);
INSERT INTO `REFERENCIAS` VALUES (5,1,3,130.00);
INSERT INTO `REFERENCIAS` VALUES (6,2,3,350.00);
/*!40000 ALTER TABLE `REFERENCIAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USERS`
--

DROP TABLE IF EXISTS `USERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USERS` (
  `usu_id` int(11) NOT NULL AUTO_INCREMENT,
  `usu_nombre` varchar(45) NOT NULL,
  `usu_email` varchar(255) NOT NULL,
  `usu_pass` varchar(32) NOT NULL,
  `usu_estado` varchar(45) NOT NULL,
  `gal_id` int(11) DEFAULT NULL,
  `com_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`usu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USERS`
--

LOCK TABLES `USERS` WRITE;
/*!40000 ALTER TABLE `USERS` DISABLE KEYS */;
INSERT INTO `USERS` VALUES (1,'Daniel','dan@hotmail.com','dan12345','Activo',1,1);
INSERT INTO `USERS` VALUES (2,'grace','grace@hotmail.com','grace12345','Activo',1,1);
INSERT INTO `USERS` VALUES (4,'Alejandro','alejandro@hotmail.com','alejandro12345','Activo',4,6);
/*!40000 ALTER TABLE `USERS` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-11-25 14:46:52

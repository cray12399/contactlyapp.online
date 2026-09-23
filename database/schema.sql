-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: contactsdb
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */; 

--
-- Table structure for table `Contacts`
--


-- added indexes on normalized email/phone numbers for faster lookup

DROP TABLE IF EXISTS `Contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Contacts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userID` int NOT NULL,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `userID` (`userID`),
  KEY contactsEmailNormalizedUK (email),
  KEY contactsPhoneNormalizedUK (phoneNumber),
  CONSTRAINT `Contacts_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `Users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `userName` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  `password` varchar(250) NOT NULL,
  `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
  `dateUpdated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `role` int NOT NULL DEFAULT '1', -- 0 = Disabled, 1 = User, 2 = Admin
  PRIMARY KEY (`id`),
  UNIQUE KEY usersEmailNormalizedUK (email),
  KEY usersPhoneNormalizedUK (phoneNumber),
  UNIQUE KEY `userName` (`userName`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


-- Dump completed on 2026-09-12 20:58:16

-- normalize email and phone number 
-- (this is before anything is inserted, if table contains data already it wont be normalized)
-- `password` is hashed (argon2id) by the API before it reaches these triggers, not here

-- make '$$' a delimiter so trigger block isn't broken up by semicolons
DELIMITER $$ 
 
CREATE TRIGGER normalizeUsersInsert
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(TRIM(NEW.email));
    SET NEW.phoneNumber = REGEXP_REPLACE(NEW.phoneNumber, '[^0-9]', '');
END$$
 
CREATE TRIGGER normalizeUsersUpdate
BEFORE UPDATE ON Users
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(TRIM(NEW.email));
    SET NEW.phoneNumber = REGEXP_REPLACE(NEW.phoneNumber, '[^0-9]', '');
END$$
 
CREATE TRIGGER normalizeContactsInsert
BEFORE INSERT ON Contacts
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(TRIM(NEW.email));
    SET NEW.phoneNumber = REGEXP_REPLACE(NEW.phoneNumber, '[^0-9]', '');
END$$
 
CREATE TRIGGER normalizeContactsUpdate
BEFORE UPDATE ON Contacts
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(TRIM(NEW.email));
    SET NEW.phoneNumber = REGEXP_REPLACE(NEW.phoneNumber, '[^0-9]', '');
END$$
 
DELIMITER ;

-- RECOMMENDATION QUERY COMMAND
-- Ranked by how many of my saved contacts (who are also real users) have also saved this candidate.
DROP PROCEDURE IF EXISTS GetRecommendations;

DELIMITER $$

CREATE PROCEDURE GetRecommendations(IN targetUserId INT)
BEGIN
    SELECT STRAIGHT_JOIN
    candidate.email, candidate.firstName, candidate.lastName,
    COUNT(DISTINCT matches.connectionId) AS mutualCount
FROM (
    SELECT myConnection.id AS connectionId
    FROM Contacts mySavedContact
    JOIN Users myConnection ON myConnection.email = mySavedContact.email
    WHERE mySavedContact.userID = targetUserId
    UNION
    SELECT myConnection.id AS connectionId
    FROM Contacts mySavedContact
    JOIN Users myConnection ON myConnection.phoneNumber = mySavedContact.phoneNumber
    WHERE mySavedContact.userID = targetUserId
) AS matches
JOIN Contacts candidate ON candidate.userID = matches.connectionId
WHERE matches.connectionId <> targetUserId
  AND candidate.email <> (SELECT email FROM Users WHERE id = targetUserId)
  AND NOT EXISTS (
      SELECT 1 FROM Contacts alreadySavedEmail
      WHERE alreadySavedEmail.userID = targetUserId AND alreadySavedEmail.email = candidate.email
  )
  AND NOT EXISTS (
      SELECT 1 FROM Contacts alreadySavedPhone
      WHERE alreadySavedPhone.userID = targetUserId AND alreadySavedPhone.phoneNumber = candidate.phoneNumber
  )
GROUP BY candidate.email, candidate.firstName, candidate.lastName
ORDER BY mutualCount DESC
LIMIT 20;
END$$

DELIMITER ;
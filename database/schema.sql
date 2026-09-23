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
 


-- Seed data: 120 Users, 570 Contacts
-- Names are pulled in order from "most common name" lists 
-- Users - 75 US-common-name users, then ~30 foreign, ~15  edge-case users
-- Contacts - 15 user recommendation cluster, one user with 220 contacts, at least one with same person shared by 2 owners,
-- then regular users (1-5 contacts each), and edge-case contacts
-- Assumes `Users` and `Contacts` are both empty

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
START TRANSACTION;

-- -------------------------------------------------------------------------
-- USERS
-- -------------------------------------------------------------------------

-- US common-name users
INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(1, 'James', 'Smith', 'xX_jim0_Xx', 'james.smith@gmail.com', '12121000000', '$2b$12$oBxONf/zJelvee0IUfmJJz.RRTACAJccxaE0NX8D0D5c'),
(2, 'Mary', 'Davis', 'mary', 'marydavis@yahoo.com', '13051007919', '$argon2id$v=19$m=65536,t=3,p=4$sl4ePyOUiRFH$sl4ePyOUiRFHnf34sMWw/1CQiF7OQVhp'),
(3, 'Michael', 'Johnson', 'michael', 'mjohnson@hotmail.com', '14071015838', 'SHA1$=Vt)89#g7#dz)AB:V7_EF#1m<vd{$rQgDYw'),
(4, 'Patricia', 'Rodriguez', 'pat', 'patricia_rodriguez@outlook.com', '14151023757', '$2b$12$urweJiFh2nngxWyGVR4uvl.ytGeBKJt45U7TCjpGZLf0'),
(5, 'Robert', 'Williams', 'robert', 'robert.williams4@icloud.com', '15121031676', '$argon2id$v=19$m=65536,t=3,p=4$i5Du+hNl6IlV$i5Du+hNl6IlVYyAMoW+3ISibpsr585YO'),
(6, 'Jennifer', 'Martinez', 'jennifer', 'jennifer.martinez@aol.com', '16171039595', 'SHA1$-Cv_Pj*P8]F8^fJ]bX^Lx>/6*T4+$3bSjNY'),
(7, 'John', 'Brown', 'john', 'johnbrown@live.com', '17021047514', '$2b$12$JHyQFJJ3vjr0yGE+MnQhCw.xWaj0KmPi4UwSzll0CwUE'),
(8, 'Linda', 'Hernandez', 'linda', 'lhernandez@msn.com', '17181055433', '$argon2id$v=19$m=65536,t=3,p=4$XMZgDRZVsY2V$XMZgDRZVsY2VS08LMqNA5xpzuu4pf08E'),
(9, 'David', 'Jones', 'david', 'david_jones@comcast.net', '13121063352', 'SHA1$(Jd;e5%aU(Wc?t5|zc/4r{M3#IJ>$Pkvwvw'),
(10, 'Elizabeth', 'Lopez', 'liz', 'elizabeth.lopez9@verizon.net', '12131071271', '$2b$12$ExwL3JyzvVN1gxws+5bp7a.TQajbjYFJB+ZHR+xfvn7U'),
(11, 'William', 'Garcia', 'william', 'william.garcia@att.net', '14041079190', '$argon2id$v=19$m=65536,t=3,p=4$J2To/c/3WNd8$J2To/c/3WNd8OD9PBvYdnvKoyIw61tMS'),
(12, 'Barbara', 'Gonzalez', '~barbara~11', 'barbaragonzalez@sbcglobal.net', '12061087109', 'SHA1$=xg!NF>hS*3U(79=CO}zJ^uy-cb*$5x6Km8'),
(13, 'Richard', 'Miller', 'rick', 'rmiller@protonmail.com', '12141095028', '$2b$12$zV1Pn0+yuQSsVMIrgThkOc.InULrED2lrYyPDCcN4sm8'),
(14, 'Susan', 'Wilson', 'susan', 'susan_wilson@gmx.com', '13031102947', '$argon2id$v=19$m=65536,t=3,p=4$9JFUSHaqFoBw$9JFUSHaqFoBwt0pFJqHrwmitV5ExvRPS'),
(15, 'Joseph', 'Davis', 'joseph', 'joseph.davis14@mail.com', '14801110866', 'SHA1$=z4}4U[yk>yx*A/}8Z%C+~b9[BV^$fkpxo8'),
(16, 'Jessica', 'Anderson', 'jessica', 'jessica.anderson@zoho.com', '16021118785', '$2b$12$DPUvD12j+DYOl12az7sM5Q.GcHYlDbBdlB6JRUgRvW1w'),
(17, 'Thomas', 'Rodriguez', 'thomas', 'thomasrodriguez@fastmail.com', '16461126704', '$argon2id$v=19$m=65536,t=3,p=4$sUfV59xfXuQV$sUfV59xfXuQVmZP5SVwHEJAgo3tuw8zB'),
(18, 'Sarah', 'Thomas', 'sarah', 'sthomas@earthlink.net', '17731134623', 'SHA1$;3i!nP_+9/+v@KU$T1|+U>uy~N1{$ocmFTU'),
(19, 'Christopher', 'Martinez', 'chris', 'christopher_martinez@juno.com', '18321142542', '$2b$12$R7VWGB1ZyZl0hPFQAqKByZ.mEMYc0eTCVngQKcZMRHkc'),
(20, 'Karen', 'Taylor', 'karen', 'karen.taylor19@netzero.net', '19041150461', '$argon2id$v=19$m=65536,t=3,p=4$+zZiFwe+d0NN$+zZiFwe+d0NNnWLqRFNaPKpS0Bgi0OjG'),
(21, 'Charles', 'Hernandez', 'charles', 'charles.hernandez@lycos.com', '16151158380', 'SHA1$:DD}RS(Ti-Tx=AI-W/!0j)Q0=lz=$aPlF1k'),
(22, 'Nancy', 'Moore', 'nancy', 'nancymoore@gmail.com', '19011166299', '$2b$12$yBK5VqjURkmxIZunsx0r7i.fugaZlic2x2mc8oUh+gXU'),
(23, 'Daniel', 'Lopez', 'd_a_n_i', 'dlopez@yahoo.com', '12161174218', '$argon2id$v=19$m=65536,t=3,p=4$QbAYMUVj2Vjw$QbAYMUVj2VjwLfhiiAw9kaWSSkSQd1Dk'),
(24, 'Lisa', 'Jackson', 'lisa', 'lisa_jackson@hotmail.com', '14121182137', 'SHA1$+y+[KG/jZ|r5}g9!X8;l6#G3_+H[$Ef+BlU'),
(25, 'Matthew', 'Gonzalez', 'matt', 'matthew.gonzalez24@outlook.com', '15031190056', '$2b$12$iP559GmAKjw24j3rjcWsFV.0Goox2K0NAc9ZqWCFKWYA'),
(26, 'Margaret', 'Martin', 'margaret', 'margaret.martin@icloud.com', '16191197975', '$argon2id$v=19$m=65536,t=3,p=4$Qna5ogVSFWPz$Qna5ogVSFWPz3PRY4jJHsspaD2cQNaKw'),
(27, 'Anthony', 'Wilson', 'anthony', 'anthonywilson@aol.com', '12101205894', 'SHA1$!mY?Zb!Un]a6+UY<wb;6L[G3}zt=$3Gwn2M'),
(28, 'Betty', 'Lee', 'betty', 'blee@live.com', '14691213813', '$2b$12$9NF/SV2uKxEx9Rnq1qr+y4.W4WfH2Y3UPk622hJcEnEY'),
(29, 'Mark', 'Anderson', 'mark', 'mark_anderson@msn.com', '18131221732', '$argon2id$v=19$m=65536,t=3,p=4$r7YCvziTr3K0$r7YCvziTr3K0MteH04u4IqnSSSoJaJzb'),
(30, 'Sandra', 'Perez', 'sandra', 'sandra.perez29@comcast.net', '19411229651', 'SHA1$^0U}kw^aU%pJ_G/_JH?QP>nc@1y#$hXocHA'),
(31, 'Donald', 'Thomas', 'don', 'donald.thomas@verizon.net', '18501237570', '$2b$12$fprnB5ix8d4gNhABinb/+y.U9tDo1Az8LnyBi8MbtJYc'),
(32, 'Ashley', 'Thompson', 'ashley', 'ashleythompson@att.net', '17271245489', '$argon2id$v=19$m=65536,t=3,p=4$+wsh1tWudz9Q$+wsh1tWudz9Q+lUSvehTKQDUsXvPPaIo'),
(33, 'Steven', 'Taylor', 'steven', 'staylor@sbcglobal.net', '19411253408', 'SHA1$|LI+P8[Aq;57^T3?U5/Fz!eC;KS/$DlGBo8'),
(34, 'Dorothy', 'White', 'd0ot_33', 'dorothy_white@protonmail.com', '15611261327', '$2b$12$WE6o6DnjyPJnPuwQ0yOUB0.tnPCmzlO1Dy+X0+dDGJ6c'),
(35, 'Paul', 'Moore', 'paul', 'paul.moore34@gmx.com', '19541269246', '$argon2id$v=19$m=65536,t=3,p=4$diBcLwTOglm/$diBcLwTOglm/N71axo0qqq4k+sYIZVVQ'),
(36, 'Kimberly', 'Harris', 'kimberly', 'kimberly.harris@mail.com', '17861277165', 'SHA1$/km^1U!7G~o+]6I&Q1<oB$BN[b+_$MsPuS0'),
(37, 'Andrew', 'Jackson', 'andrew', 'andrewjackson@zoho.com', '13211285084', '$2b$12$JZOuUdcGm0k+Tlmj7HsoJs.8b7nJ1X/48Fi8FVgEYoto'),
(38, 'Emily', 'Sanchez', 'emily', 'esanchez@fastmail.com', '13521293003', '$argon2id$v=19$m=65536,t=3,p=4$RnKuRD8aJ8BJ$RnKuRD8aJ8BJfgadI8nsZ3iBEcHYtKa4'),
(39, 'Joshua', 'Martin', 'joshua', 'joshua_martin@earthlink.net', '13861300922', 'SHA1$*ZU>MA(ZV>Vy?AJ~zd[zg/sR#IE($PvSExE'),
(40, 'Donna', 'Clark', 'donna', 'donna.clark39@juno.com', '12121308841', '$2b$12$Cn9aSiOq44bNKIMN1bdc27.iMPwJKLJG4C042zPCkzqg');

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(41, 'Kenneth', 'Lee', 'kenneth', 'kenneth.lee@netzero.net', '13051316760', '$argon2id$v=19$m=65536,t=3,p=4$L1fCW2LpqPsX$L1fCW2LpqPsX87SlqOc0tcCTrd5JBsfV'),
(42, 'Michelle', 'Ramirez', 'michelle', 'michelleramirez@lycos.com', '14071324679', 'SHA1$?ZA+JS~TZ^mQ_Wi*9J-Rv[7S_Mg*$ebknGg'),
(43, 'Kevin', 'Perez', 'kevin', 'kperez@gmail.com', '14151332598', '$2b$12$N3xSkflnA/wKFmnJpUP8+u.zYXRQWEpVCktK3gCmy9R4'),
(44, 'Carol', 'Lewis', 'carol', 'carol_lewis@yahoo.com', '15121340517', '$argon2id$v=19$m=65536,t=3,p=4$8S+Ra2QiqtVO$8S+Ra2QiqtVOkVwWCAJJ2M29FI1tKBTl'),
(45, 'Brian', 'Thompson', 'brian_55', 'brian.thompson44@hotmail.com', '16171348436', 'SHA1$_Aa-wh;1l@AM{xM-Ks!yj?27~N/]$fmYi+0'),
(46, 'Amanda', 'Robinson', 'amanda', 'amanda.robinson@outlook.com', '17021356355', '$2b$12$fSoxncct9dB4e11s7WuOFS.TFoB7cwhOSfAO/iKEHxsc'),
(47, 'George', 'White', 'george', 'georgewhite@icloud.com', '17181364274', '$argon2id$v=19$m=65536,t=3,p=4$KDOV1aYwqjjz$KDOV1aYwqjjzU1tzvFDFYvdik7F8X9ZN'),
(48, 'Melissa', 'Walker', 'melissa', 'mwalker@aol.com', '13121372193', 'SHA1$;8l{kh?o5&Sn:Oq<li_Uf_1u[Gg)$9l56hk'),
(49, 'Timothy', 'Harris', 'tim', 'timothy_harris@live.com', '12131380112', '$2b$12$kYxRK1i6epp9p5Bhr2ibAy.L3JpmgqxRqnprR6aPMdso'),
(50, 'Deborah', 'Young', 'deborah', 'deborah.young49@msn.com', '14041388031', '$argon2id$v=19$m=65536,t=3,p=4$d8r+1h3CWhmD$d8r+1h3CWhmDPouOXQ6qznR2D1LL4PLi'),
(51, 'Ronald', 'Sanchez', 'ronald', 'ronald.sanchez@comcast.net', '12061395950', 'SHA1$]/S^bd$Rn]F6_0R/WE[hz$6v&uc]$0osnhY'),
(52, 'Stephanie', 'Allen', 'steph', 'stephanieallen@verizon.net', '12141403869', '$2b$12$2u+FrI43EXu+UlSbmxLso3.rpDmk3qNFwenOJLAd5QJA'),
(53, 'Edward', 'Clark', 'edward', 'eclark@att.net', '13031411788', '$argon2id$v=19$m=65536,t=3,p=4$ObcxNuWpBhZF$ObcxNuWpBhZFpGDNyNY2ktOab8WnpZ+Y'),
(54, 'Rebecca', 'King', 'rebecca', 'rebecca_king@sbcglobal.net', '14801419707', 'SHA1$:Ng(cJ^Ou%hq;DC-E9]fW/jS$cc]$fSdkEc'),
(55, 'Jason', 'Ramirez', 'jason', 'jason.ramirez54@protonmail.com', '16021427626', '$2b$12$fR/dWjQIXSuAwDm7tkGNAc.OE5Yjuf915J/jcFdBMNlk'),
(56, 'Sharon', 'Wright', '!!sharon!!', 'sharon.wright@gmx.com', '16461435545', '$argon2id$v=19$m=65536,t=3,p=4$TfsGqIIv8ldv$TfsGqIIv8ldvsrmRO2EKCIL0tbZLsSMH'),
(57, 'Jeffrey', 'Lewis', 'jeffrey', 'jeffreylewis@mail.com', '17731443464', 'SHA1$?+s[Dh%0U-vK}tK<ef$+F(RG(YB]$dk5kgk'),
(58, 'Laura', 'Scott', 'laura', 'lscott@zoho.com', '18321451383', '$2b$12$y94Idj2hgJmnbv9UR+I/j9.pNi9Li7VYuBzPmhvEVjco'),
(59, 'Ryan', 'Robinson', 'ryan', 'ryan_robinson@fastmail.com', '19041459302', '$argon2id$v=19$m=65536,t=3,p=4$4lsNL3jVm+jX$4lsNL3jVm+jXyO0MMK1bRTwbUbYhmAK1'),
(60, 'Cynthia', 'Torres', 'cynthia', 'cynthia.torres59@earthlink.net', '16151467221', 'SHA1$:EV$03#za#9n(o1&CM?vB*WN;41}$X8xejA'),
(61, 'Jacob', 'Walker', 'jacob', 'jacob.walker@juno.com', '19011475140', '$2b$12$UfITodZAg7cA15Y0xvYHVI.Gw7KtlYxAG0lVGN3hExjs'),
(62, 'Kathleen', 'Nguyen', 'kathleen', 'kathleennguyen@netzero.net', '12161483059', '$argon2id$v=19$m=65536,t=3,p=4$77F+Tr/3MuG+$77F+Tr/3MuG+P+6OBNOqHqnO9jNXdQoZ'),
(63, 'Gary', 'Young', 'gary', 'gyoung@lycos.com', '14121490978', 'SHA1$*YY>Sj~zz{WK%K5$oD)rh>E0]3q+$/M7LFA'),
(64, 'Amy', 'Hill', 'amy', 'amy_hill@gmail.com', '15031498897', '$2b$12$f/FWM9gO/4LBO/ldcxWqlO.NO0OxIrWq/ASeME16JfE0'),
(65, 'Nicholas', 'Allen', 'nicholas', 'nicholas.allen64@yahoo.com', '16191506816', '$argon2id$v=19$m=65536,t=3,p=4$DVoWcuQC0VnZ$DVoWcuQC0VnZzlRNPFs8oKUjewixJEo1'),
(66, 'Shirley', 'Flores', 'shirley', 'shirley.flores@hotmail.com', '12101514735', 'SHA1$*Tb|ei{wR+KD=eC%w0+Io$gA)/1)$+Wi6gs'),
(67, 'Eric', 'King', 'xX_eric66_Xx', 'ericking@outlook.com', '14691522654', '$2b$12$4BhoCiXkTiuh0XWlTOh8CS.P+9MiW97FczKy6h5oGpjQ'),
(68, 'Angela', 'Green', 'angela', 'agreen@icloud.com', '18131530573', '$argon2id$v=19$m=65536,t=3,p=4$hZT8HQThmcRJ$hZT8HQThmcRJwgA8+T8agdnyUvKATItX'),
(69, 'Jonathan', 'Wright', 'jonathan', 'jonathan_wright@aol.com', '19411538492', 'SHA1$$Xj~td^+7<gT[al=XA)oQ>hM)5N+$wl+1ac'),
(70, 'Helen', 'Adams', 'helen', 'helen.adams69@live.com', '18501546411', '$2b$12$All1D6c6Nkem7+Pz6kzG1o.slNYcHR/q2SPLsNNyb+Do'),
(71, 'Stephen', 'Scott', 'stephen', 'stephen.scott@msn.com', '17271554330', '$argon2id$v=19$m=65536,t=3,p=4$qHWb2xhdpMEu$qHWb2xhdpMEuihKimfE8SbeTN5cDngaP'),
(72, 'Anna', 'Nelson', 'anna', 'annanelson@comcast.net', '19411562249', 'SHA1$?e3#7J;Gl}rU/w7%Zs]wO:jn@x2=$aWca98'),
(73, 'Larry', 'Torres', 'larry', 'ltorres@verizon.net', '15611570168', '$2b$12$5QnEBx4Vjzxr8/Dm5J6FF/./Zq8tD9T+HDoHFj0KZ/cA'),
(74, 'Brenda', 'Baker', 'brenda', 'brenda_baker@att.net', '19541578087', '$argon2id$v=19$m=65536,t=3,p=4$dgCyPH4RVmLl$dgCyPH4RVmLlTIlXf5mXTLo+PWkzBXFw'),
(75, 'Justin', 'Nguyen', 'justin', 'justin.nguyen74@sbcglobal.net', '17861586006', 'SHA1$?yt-DH~9M]wO}9w/RZ%rm!Fd<O9)$1a1zzA');

-- Foreign-culture users Languages represented: Japanese, Chinese, Korean, Vietnamese, Hindi,
-- Arabic, Hebrew, Yiddish, Russian, German, French, Spanish, Irish, Nigerian, Polish. 
INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(76, '隼人', '佐藤', 'h0ayato_75', 'hayato.sato@protonmail.com', '13211593925', '$2b$12$DwjU3ONZLGcILDQHmIKDk9.VhdI9LPZhPs7mcF7Ou3wo'),
(77, 'Yuki', 'Tanaka', 'yuki', 'yukitanaka@gmx.com', '13521601844', '$argon2id$v=19$m=65536,t=3,p=4$JBXVsmFfLZq2$JBXVsmFfLZq2w6cHzRW9GWwR2TLjOMgJ'),
(78, 'Wei', 'Chen', 'wei', 'wchen@mail.com', '13861609763', 'SHA1$+U4)pT}BK)9a$4V{Hd~Qk>dj;XD{$PRCsXI'),
(79, 'Mei', 'Wang', 'mei', 'mei_wang@outlook.com', '12121617682', '$2b$12$UZBzvwWE/kBqXbR94Cs/Ht.bem1CmkWBxuwkTdV4AhQA'),
(80, 'Jun', 'Li', 'jun', 'jun.li79@fastmail.com', '13051625601', '$argon2id$v=19$m=65536,t=3,p=4$6px0SFxRR65o$6px0SFxRR65oM4tiA8rTzkZRjno7kirV'),
(81, '李', '伟', 'li', 'li.wei@earthlink.net', '14071633520', 'SHA1$!so?Zb%K1!Ah!sz!Gt$+t[e5~Qy{$Cc170g'),
(82, 'Xiu', 'Huang', 'xiu', 'xiuhuang@live.com', '14151641439', '$2b$12$ccnGZZ20+fyLf4A9q4N4TL.pfpRsbx5cw49NqDqwgL5A'),
(83, '张', '丽', 'zhang', 'zli@netzero.net', '15121649358', '$argon2id$v=19$m=65536,t=3,p=4$+KZOsUvUjYd0$+KZOsUvUjYd0kMDW+RtSTsScZC19GitI'),
(84, '민준', '김', 'minjun', 'minjun_kim@lycos.com', '16171657277', 'SHA1$]3q>5h!3G#jk<iC|Sf{c4+wj|CV[$CtBxEE'),
(85, 'Ji-woo', 'Park', 'xX_jiwoo84_Xx', 'jiwoo.park84@gmx.com', '17021665196', '$2b$12$aRqXeo4Y5uqRI00L94yrQf.dLskwO5i83jH4HWhVsIz4'),
(86, 'Nguyễn', 'Văn An', 'nguyen', 'nguyen.vanan@yahoo.com', '17181673115', '$argon2id$v=19$m=65536,t=3,p=4$n81IA7He0FLb$n81IA7He0FLbXXZqXKu6KymoZ5dzZlIj'),
(87, 'Trần', 'Thị Hoa', 'tran', 'tranthihoa@hotmail.com', '13121681034', 'SHA1$|lK-jl}P+/Pu?EV{Fx$9r@MU<Ql%$tPSIBE'),
(88, 'Aarav', 'Sharma', 'aarav', 'asharma@fastmail.com', '12131688953', '$2b$12$uLBMG7xBa9cXhBTtWSFw6U.rCpQDXKdlhSLrIZ4aoqEs'),
(89, 'Priya', 'Patel', 'priya', 'priya_patel@icloud.com', '14041696872', '$argon2id$v=19$m=65536,t=3,p=4$C0e51wYJYqCD$C0e51wYJYqCD/TUmffO/H5HQALPc/7W5'),
(90, 'Rohan', 'Mehta', 'rohan', 'rohan.mehta89@aol.com', '12061704791', 'SHA1$%G+(CD:dy_kZ|DT)LB?kC@Z8&de#$qWrcXE'),
(91, 'محمد', 'الفارسي', 'mohammed', 'mohammed.alfarsi@live.com', '12141712710', '$2b$12$RfQQMHcNA2yBG2HG7HkGWy.YE3E3RmwLEYmnkOclgGHc'),
(92, 'Fatima', 'Hassan', 'fatima', 'fatimahassan@msn.com', '13031720629', '$argon2id$v=19$m=65536,t=3,p=4$DMg5pjVL6dY6$DMg5pjVL6dY68f4gy8fY7r86lgQrnS1+'),
(93, 'נועה', 'כהן', 'noa', 'ncohen@comcast.net', '14801728548', 'SHA1$=U6&Bh]VX~8J%5C#oA!0N$R/[AB_$iX5o6A'),
(94, 'Itai', 'Levi', 'i0tai_93', 'itai_levi@verizon.net', '16021736467', '$2b$12$Drs36BxvFmokBNi300OyZb.ZvBZ9qFQRpGlrLTsW2pAg'),
(95, 'משה', 'כץ', 'moishe', 'moishe.katz94@att.net', '16461744386', '$argon2id$v=19$m=65536,t=3,p=4$aVtoV0huDCu9$aVtoV0huDCu9Jr6laIV+VbWVTVqokosq'),
(96, 'Дмитрий', 'Иванов', 'dmitri', 'dmitri.ivanov@sbcglobal.net', '17731752305', 'SHA1$!Ht>mL:fY}wO@Wq!ac;PT(bq+aB&$r8k5Ng'),
(97, 'Anastasia', 'Petrova', 'anastasia', 'anastasiapetrova@hotmail.com', '18321760224', '$2b$12$WzrJCpuoeHwzUqVIaMxbJg.Iy7Uji20dBnkTvlaYddGw'),
(98, 'Hans', 'Müller', 'hans', 'hmuller@gmx.com', '19041768143', '$argon2id$v=19$m=65536,t=3,p=4$dvBp+YCgBN0h$dvBp+YCgBN0hULuG5SG14dLTsLHoYJka'),
(99, 'Ingrid', 'Fischer', 'ingrid', 'ingrid_fischer@mail.com', '16151776062', 'SHA1$!td_2h/am_ZV>gP>Sp!us$9X:OL)$yLe/Rw'),
(100, 'André', 'Dubois', 'andre', 'andre.dubois99@aol.com', '19011783981', '$2b$12$5c8EZagl5hBb42V3Z1A0cp.2/5TChocpZjUAgulHwXFs'),
(101, 'José', 'Muñoz', 'jose', 'jose.munoz@fastmail.com', '12161791900', '$argon2id$v=19$m=65536,t=3,p=4$aNLjXQIS0GhZ$aNLjXQIS0GhZmmDNHCrdtOUx4JSOOWJA'),
(102, 'Siobhán', 'O''Brien', 'siobhan', 'siobhanobrien@earthlink.net', '14121799819', 'SHA1$(J1}EU+fp@WD*UL>O6(FF>/g#kf<$RtDqZA'),
(103, 'Chinedu', 'Okafor', 'xX_chinedu102_Xx', 'cokafor@juno.com', '15031807738', '$2b$12$J4xZyQrgSoa/tucCq/jDsC.w7w2IdHA58PPeCfHkNHHQ'),
(104, 'Katarzyna', 'Kowalska', 'katarzyna', 'katarzyna_kowalska@netzero.net', '16191815657', '$argon2id$v=19$m=65536,t=3,p=4$qVwgduZvfjfQ$qVwgduZvfjfQbq9WYYKG5Yawh9/zWxS1');

--  edge-case users
-- Split into one INSERT per row on purpose: with 'mysql --force' an error on one row now only aborts that single statement
INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(105, 'Amelia', 'Stone', 'amelia.stone', 'amelia.stone@gmail.com', '14158127100', '$2b$12$HoVHis6gNWryzdsq2chu8F.uCCCRpMNrRkpvpRdn8zS8');  -- dup-email-case A

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(107, 'Omar', 'Delacroix-Reyes', 'omar.d', 'omar.delacroix@outlook.com', '(407) 555-0199', 'SHA1$%li@NU;Fl*Zl>16}MI#cX#RO>sn-$juIiYI');  -- dup-phone-format A

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(108, 'Farid', 'Boone', 'farid.boone', 'farid.boone@zoho.com', '+1-407-555-0199', '$2b$12$h4guQMDiM2DAxA+kcHAJD7.Yk4o+v9PMdj5q4cYXeoP4');  -- dup-phone-format B (same number as above)

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(109, '  Grace', 'Holloway  ', ' gws', ' grace.holloway@yahoo.com ', '16178142938', '$argon2id$v=19$m=65536,t=3,p=4$MB8bh3uAymUt$MB8bh3uAymUtU0Nz3c8cyFdMp8HUgpyF');  -- whitespace in name/username/email

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(110, 'Bo', 'Xu', 'bo.xu', 'bo.xu@qq.com', '17028150857', 'SHA1$!FX{Xv|8Y_V9)Dw=v8:Dd+6q_vK;$w8ofvc');  -- very short name

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(111, 'Al', 'O', 'al.o', 'al.o@gmail.com', '17188158776', '$2b$12$trQ3essDmJkAPYHKWXnDx9.r1ZoFZFoWcVnOQ4UMxQYM');  -- very short name (1-char surname)

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(112, 'Bartholomew', 'Montgomery-Fitzgerald-Worthington-Ashcroft-Pemberton-Radcliffe-Beaumont-Thornbury-Winterbourne-Castellane-Hollingsworth-Abernathy-Featherstonehaugh-Ravensworth-Chetwynd-Devereux-Montgomery-Fitzgerald-Worthington-Ashcroft-Pemberton-Radcliffe-Beaumont-', 'bartholomew.long', 'bartholomew.long@protonmail.com', '13128166695', '$argon2id$v=19$m=65536,t=3,p=4$ia00X4IC2vNM$ia00X4IC2vNMdtKICPWmPCcVRthxFmgn');  -- long lastName, 250 chars (limit 255)

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(113, 'Declan', 'O''Connor', 'declan.oconnor', 'declan.oconnor@aol.com', '12138174614', 'SHA1$;a1~Z1|9l*aS@cb/T2<Cg]Wb&Qm:$KO14CM');  -- apostrophe surname

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(114, 'Ava', 'Smith-Jones', 'ava.smithjones', 'ava.smith-jones@icloud.com', '14048182533', '$2b$12$1qgmTXFxisN9LK1wUwvvEY.MNa/O1hwBe+U48Kx4x5ww');  -- hyphenated surname

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(115, 'Freya', 'Andersen', 'freya.andersen', 'freya.andersen@gmx.com', '+44 20 7946 0958', '$argon2id$v=19$m=65536,t=3,p=4$1zqmFlX5oZ85$1zqmFlX5oZ85ZRVp3VXlea0psGsWIsfD');  -- international phone, raw UK format

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(116, 'Arjun', 'Rao', 'arjun.rao', 'arjun.rao@rediffmail.com', '+91 98765 43210', 'SHA1${k9*Ve!Q6*Fk$aD&a1]D8^1d?9a[$GP4V2Q');  -- international phone, raw India format

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(117, 'Lin', 'Fang', 'lin.fang', 'lin.fang@163.com', '+86 138 0013 8000', '$2b$12$938IZiuCTa465KP5GZEme0.Gw65Phx275S2q8MIQSD28');  -- international phone, raw China format

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(118, 'Isla', 'Brennan', 'isla.brennan', 'isla.brennan@fastmail.com', NULL, '$argon2id$v=19$m=65536,t=3,p=4$wV4dnnInTLpC$wV4dnnInTLpCuJihitt35TnUPDpg4+/C');  -- NULL phone number

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(119, 'Tobias', 'Kern', 'tobias.kern', 'tobias.kern@web.de', '', 'SHA1$*+t[Dl#qh$ue]f2/KX/mg]Yu;h0!$DerSIM');  -- empty-string phone number

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`) VALUES
(120, 'Trinity', 'Vance', 'xX_Tr1n1ty_Xx99', 'trinity.vance@lycos.com', '12068190452', '!!!$2b$12$zEXklumDpSgkkm84hF6LZD.ZH4AcSxuoALAE+t/RCtiM~~~');  -- strange username + extra-obscure password chars

-- CONTACTS

-- Mutual-recommendation cluster: Users 1-15 each add ~6 of the other cluster members as a Contact, using
-- the target's real (or deliberately case/format-mismatched) email/phone. This  soft 'relates to' mutual-contacts recommendations
INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(1, 1, 'Mary', 'Davis', 'marydavis@yahoo.com', '13051007919'),
(2, 1, 'Michael', 'Johnson', 'mjohnson@hotmail.com', '14071015838'),
(3, 1, 'Patricia', 'Rodriguez', 'patricia_rodriguez@outlook.com', '14151023757'),
(4, 1, 'Robert', 'Williams', 'robert.williams4@icloud.com', '15121031676'),
(5, 1, 'Jennifer', 'Martinez', 'jennifer.martinez@aol.com', '16171039595'),
(6, 1, 'John', 'Brown', 'johnbrown@live.com', '17021047514'),
(7, 2, 'Michael', 'Johnson', 'mjohnson@hotmail.com', '14071015838'),
(8, 2, 'Patricia', 'Rodriguez', 'patricia_rodriguez@outlook.com', '14151023757'),
(9, 2, 'Robert', 'Williams', 'ROBERT.WILLIAMS4@ICLOUD.COM', '15121031676'),  -- cluster link, email case-mismatched vs target User
(10, 2, 'Jennifer', 'Martinez', 'jennifer.martinez@aol.com', '16171039595'),
(11, 2, 'John', 'Brown', 'johnbrown@live.com', '17021047514'),
(12, 2, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(13, 3, 'Patricia', 'Rodriguez', 'patricia_rodriguez@outlook.com', '+1 (415) 102-3757'),  -- cluster link, phone format-mismatched vs target User
(14, 3, 'Robert', 'Williams', 'robert.williams4@icloud.com', '15121031676'),
(15, 3, 'Jennifer', 'Martinez', 'jennifer.martinez@aol.com', '16171039595'),
(16, 3, 'John', 'Brown', 'johnbrown@live.com', '17021047514'),
(17, 3, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(18, 3, 'David', 'Jones', 'DAVID_JONES@COMCAST.NET', '13121063352'),  -- cluster link, email case-mismatched vs target User
(19, 4, 'Robert', 'Williams', 'robert.williams4@icloud.com', '15121031676'),
(20, 4, 'Jennifer', 'Martinez', 'jennifer.martinez@aol.com', '16171039595'),
(21, 4, 'John', 'Brown', 'johnbrown@live.com', '17021047514'),
(22, 4, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(23, 4, 'David', 'Jones', 'david_jones@comcast.net', '13121063352'),
(24, 4, 'Elizabeth', 'Lopez', 'elizabeth.lopez9@verizon.net', '12131071271'),
(25, 5, 'Jennifer', 'Martinez', 'jennifer.martinez@aol.com', '16171039595'),
(26, 5, 'John', 'Brown', 'johnbrown@live.com', '+1 (702) 104-7514'),  -- cluster link, phone format-mismatched vs target User
(27, 5, 'Linda', 'Hernandez', 'LHERNANDEZ@MSN.COM', '17181055433'),  -- cluster link, email case-mismatched vs target User
(28, 5, 'David', 'Jones', 'david_jones@comcast.net', '13121063352'),
(29, 5, 'Elizabeth', 'Lopez', 'elizabeth.lopez9@verizon.net', '12131071271'),
(30, 5, 'William', 'Garcia', 'william.garcia@att.net', '14041079190'),
(31, 6, 'John', 'Brown', 'johnbrown@live.com', '17021047514'),
(32, 6, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(33, 6, 'David', 'Jones', 'david_jones@comcast.net', '13121063352'),
(34, 6, 'Elizabeth', 'Lopez', 'elizabeth.lopez9@verizon.net', '12131071271'),
(35, 6, 'William', 'Garcia', 'william.garcia@att.net', '14041079190'),
(36, 6, 'Barbara', 'Gonzalez', 'BARBARAGONZALEZ@SBCGLOBAL.NET', '12061087109'),  -- cluster link, email case-mismatched vs target User
(37, 7, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(38, 7, 'David', 'Jones', 'david_jones@comcast.net', '13121063352'),
(39, 7, 'Elizabeth', 'Lopez', 'elizabeth.lopez9@verizon.net', '+1 (213) 107-1271'),  -- cluster link, phone format-mismatched vs target User
(40, 7, 'William', 'Garcia', 'william.garcia@att.net', '14041079190');

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(41, 7, 'Barbara', 'Gonzalez', 'barbaragonzalez@sbcglobal.net', '12061087109'),
(42, 7, 'Richard', 'Miller', 'rmiller@protonmail.com', '12141095028'),
(43, 8, 'David', 'Jones', 'david_jones@comcast.net', '13121063352'),
(44, 8, 'Elizabeth', 'Lopez', 'elizabeth.lopez9@verizon.net', '12131071271'),
(45, 8, 'William', 'Garcia', 'WILLIAM.GARCIA@ATT.NET', '14041079190'),  -- cluster link, email case-mismatched vs target User
(46, 8, 'Barbara', 'Gonzalez', 'barbaragonzalez@sbcglobal.net', '12061087109'),
(47, 8, 'Richard', 'Miller', 'rmiller@protonmail.com', '12141095028'),
(48, 8, 'Susan', 'Wilson', 'susan_wilson@gmx.com', '13031102947'),
(49, 9, 'Elizabeth', 'Lopez', 'elizabeth.lopez9@verizon.net', '12131071271'),
(50, 9, 'William', 'Garcia', 'william.garcia@att.net', '14041079190'),
(51, 9, 'Barbara', 'Gonzalez', 'barbaragonzalez@sbcglobal.net', '12061087109'),
(52, 9, 'Richard', 'Miller', 'rmiller@protonmail.com', '+1 (214) 109-5028'),  -- cluster link, phone format-mismatched vs target User
(53, 9, 'Susan', 'Wilson', 'susan_wilson@gmx.com', '13031102947'),
(54, 9, 'Joseph', 'Davis', 'JOSEPH.DAVIS14@MAIL.COM', '14801110866'),  -- cluster link, email case-mismatched vs target User
(55, 10, 'William', 'Garcia', 'william.garcia@att.net', '14041079190'),
(56, 10, 'Barbara', 'Gonzalez', 'barbaragonzalez@sbcglobal.net', '12061087109'),
(57, 10, 'Richard', 'Miller', 'rmiller@protonmail.com', '12141095028'),
(58, 10, 'Susan', 'Wilson', 'susan_wilson@gmx.com', '13031102947'),
(59, 10, 'Joseph', 'Davis', 'joseph.davis14@mail.com', '14801110866'),
(60, 10, 'James', 'Smith', 'james.smith@gmail.com', '12121000000'),
(61, 11, 'Barbara', 'Gonzalez', 'barbaragonzalez@sbcglobal.net', '12061087109'),
(62, 11, 'Richard', 'Miller', 'rmiller@protonmail.com', '12141095028'),
(63, 11, 'Susan', 'Wilson', 'SUSAN_WILSON@GMX.COM', '13031102947'),  -- cluster link, email case-mismatched vs target User
(64, 11, 'Joseph', 'Davis', 'joseph.davis14@mail.com', '14801110866'),
(65, 11, 'James', 'Smith', 'james.smith@gmail.com', '+1 (212) 100-0000'),  -- cluster link, phone format-mismatched vs target User
(66, 11, 'Mary', 'Davis', 'marydavis@yahoo.com', '13051007919'),
(67, 12, 'Richard', 'Miller', 'rmiller@protonmail.com', '12141095028'),
(68, 12, 'Susan', 'Wilson', 'susan_wilson@gmx.com', '13031102947'),
(69, 12, 'Joseph', 'Davis', 'joseph.davis14@mail.com', '14801110866'),
(70, 12, 'James', 'Smith', 'james.smith@gmail.com', '12121000000'),
(71, 12, 'Mary', 'Davis', 'marydavis@yahoo.com', '13051007919'),
(72, 12, 'Michael', 'Johnson', 'MJOHNSON@HOTMAIL.COM', '14071015838'),  -- cluster link, email case-mismatched vs target User
(73, 13, 'Susan', 'Wilson', 'susan_wilson@gmx.com', '13031102947'),
(74, 13, 'Joseph', 'Davis', 'joseph.davis14@mail.com', '14801110866'),
(75, 13, 'James', 'Smith', 'james.smith@gmail.com', '12121000000'),
(76, 13, 'Mary', 'Davis', 'marydavis@yahoo.com', '13051007919'),
(77, 13, 'Michael', 'Johnson', 'mjohnson@hotmail.com', '14071015838'),
(78, 13, 'Patricia', 'Rodriguez', 'patricia_rodriguez@outlook.com', '+1 (415) 102-3757'),  -- cluster link, phone format-mismatched vs target User
(79, 14, 'Joseph', 'Davis', 'joseph.davis14@mail.com', '14801110866'),
(80, 14, 'James', 'Smith', 'james.smith@gmail.com', '12121000000');

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(81, 14, 'Mary', 'Davis', 'MARYDAVIS@YAHOO.COM', '13051007919'),  -- cluster link, email case-mismatched vs target User
(82, 14, 'Michael', 'Johnson', 'mjohnson@hotmail.com', '14071015838'),
(83, 14, 'Patricia', 'Rodriguez', 'patricia_rodriguez@outlook.com', '14151023757'),
(84, 14, 'Robert', 'Williams', 'robert.williams4@icloud.com', '15121031676'),
(85, 15, 'James', 'Smith', 'james.smith@gmail.com', '12121000000'),
(86, 15, 'Mary', 'Davis', 'marydavis@yahoo.com', '13051007919'),
(87, 15, 'Michael', 'Johnson', 'mjohnson@hotmail.com', '14071015838'),
(88, 15, 'Patricia', 'Rodriguez', 'patricia_rodriguez@outlook.com', '14151023757'),
(89, 15, 'Robert', 'Williams', 'robert.williams4@icloud.com', '15121031676'),
(90, 15, 'Jennifer', 'Martinez', 'JENNIFER.MARTINEZ@AOL.COM', '16171039595');  -- cluster link, email case-mismatched vs target User

-- Power user: User 76 owns 220 contacts, ~2/3 referencing real Users
INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(91, 76, 'James', 'Lopez', 'james.lopez0@gmail.com', '12122000000'),
(92, 76, 'Mary', 'Davis', 'marydavis@yahoo.com', '13051007919'),  -- power-user contact, references real User
(93, 76, 'Michael', 'Johnson', 'mjohnson@hotmail.com', '14071015838'),
(94, 76, 'Patricia', 'Anderson', 'patricia.anderson@yahoo.com', '13032006247'),
(95, 76, 'Robert', 'Williams', 'robert.williams4@icloud.com', '15121031676'),
(96, 76, 'Jennifer', 'Martinez', 'jennifer.martinez@aol.com', '16171039595'),
(97, 76, 'Robert', 'Moore', 'robert.moore@hotmail.com', '12102012494'),
(98, 76, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(99, 76, 'David', 'Jones', 'david_jones@comcast.net', '13121063352'),
(100, 76, 'Linda', 'Lee', 'linda.lee@outlook.com', '12122018741'),
(101, 76, 'William', 'Garcia', 'william.garcia@att.net', '14041079190'),
(102, 76, 'Barbara', 'Gonzalez', 'barbaragonzalez@sbcglobal.net', '12061087109'),
(103, 76, 'David', 'White', 'david.white@icloud.com', '13032024988'),
(104, 76, 'Susan', 'Wilson', 'susan_wilson@gmx.com', '13031102947'),
(105, 76, 'Joseph', 'Davis', 'joseph.davis14@mail.com', '14801110866'),
(106, 76, 'Barbara', 'Clark', 'barbara.clark5@aol.com', '12102031235'),
(107, 76, 'Thomas', 'Rodriguez', 'thomasrodriguez@fastmail.com', '16461126704'),
(108, 76, 'Sarah', 'Thomas', 'sthomas@earthlink.net', '17731134623'),
(109, 76, 'Richard', 'Robinson', 'richard.robinson@live.com', '12122037482'),
(110, 76, 'Karen', 'Taylor', 'karen.taylor19@netzero.net', '19041150461'),
(111, 76, 'Charles', 'Hernandez', 'charles.hernandez@lycos.com', '16151158380'),
(112, 76, 'Jessica', 'Allen', 'jessica.allen@msn.com', '13032043729'),
(113, 76, 'Daniel', 'Lopez', 'dlopez@yahoo.com', '12161174218'),
(114, 76, 'Lisa', 'Jackson', 'lisa_jackson@hotmail.com', '14121182137'),
(115, 76, 'Thomas', 'Scott', 'thomas.scott@comcast.net', '12102049976'),
(116, 76, 'Margaret', 'Martin', 'margaret.martin@icloud.com', '16191197975'),
(117, 76, 'Anthony', 'Wilson', 'anthonywilson@aol.com', '12101205894'),
(118, 76, 'Karen', 'Hill', 'karen.hill@verizon.net', '12122056223'),
(119, 76, 'Mark', 'Anderson', 'mark_anderson@msn.com', '18131221732'),
(120, 76, 'Sandra', 'Perez', 'sandra.perez29@comcast.net', '19411229651'),
(121, 76, 'Charles', 'Adams', 'charles.adams10@att.net', '13032062470'),
(122, 76, 'Ashley', 'Thompson', 'ashleythompson@att.net', '17271245489'),
(123, 76, 'Steven', 'Taylor', 'staylor@sbcglobal.net', '19411253408'),
(124, 76, 'Lisa', 'Hall', 'lisa.hall@sbcglobal.net', '12102068717'),
(125, 76, 'Paul', 'Moore', 'paul.moore34@gmx.com', '19541269246'),
(126, 76, 'Kimberly', 'Harris', 'kimberly.harris@mail.com', '17861277165'),
(127, 76, 'Matthew', 'Mitchell', 'matthew.mitchell@protonmail.com', '12122074964'),
(128, 76, 'Emily', 'Sanchez', 'esanchez@fastmail.com', '13521293003'),
(129, 76, 'Joshua', 'Martin', 'joshua_martin@earthlink.net', '13861300922'),
(130, 76, 'Betty', 'Smith', 'betty.smith@gmx.com', '13032081211');

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(131, 76, 'Kenneth', 'Lee', 'kenneth.lee@netzero.net', '13051316760'),
(132, 76, 'Michelle', 'Ramirez', 'michelleramirez@lycos.com', '14071324679'),
(133, 76, 'Mark', 'Brown', 'mark.brown@mail.com', '12102087458'),
(134, 76, 'Carol', 'Lewis', 'carol_lewis@yahoo.com', '15121340517'),
(135, 76, 'Brian', 'Thompson', 'brian.thompson44@hotmail.com', '16171348436'),
(136, 76, 'Ashley', 'Miller', 'ashley.miller15@zoho.com', '12122093705'),
(137, 76, 'George', 'White', 'georgewhite@icloud.com', '17181364274'),
(138, 76, 'Melissa', 'Walker', 'mwalker@aol.com', '13121372193'),
(139, 76, 'Steven', 'Martinez', 'steven.martinez@fastmail.com', '13032099952'),
(140, 76, 'Deborah', 'Young', 'deborah.young49@msn.com', '14041388031'),
(141, 76, 'Ronald', 'Sanchez', 'ronald.sanchez@comcast.net', '12061395950'),
(142, 76, 'Kimberly', 'Gonzalez', 'kimberly.gonzalez@earthlink.net', '12102106199'),
(143, 76, 'Edward', 'Clark', 'eclark@att.net', '13031411788'),
(144, 76, 'Rebecca', 'King', 'rebecca_king@sbcglobal.net', '14801419707'),
(145, 76, 'Andrew', 'Thomas', 'andrew.thomas@juno.com', '12122112446'),
(146, 76, 'Sharon', 'Wright', 'sharon.wright@gmx.com', '16461435545'),
(147, 76, 'Jeffrey', 'Lewis', 'jeffreylewis@mail.com', '17731443464'),
(148, 76, 'Donna', 'Jackson', 'donna.jackson@netzero.net', '13032118693'),
(149, 76, 'Ryan', 'Robinson', 'ryan_robinson@fastmail.com', '19041459302'),
(150, 76, 'Cynthia', 'Torres', 'cynthia.torres59@earthlink.net', '16151467221'),
(151, 76, 'Kenneth', 'Perez', 'kenneth.perez20@lycos.com', '12102124940'),
(152, 76, 'Kathleen', 'Nguyen', 'kathleennguyen@netzero.net', '12161483059'),
(153, 76, 'Gary', 'Young', 'gyoung@lycos.com', '14121490978'),
(154, 76, 'Carol', 'Harris', 'carol.harris@gmail.com', '12122131187'),
(155, 76, 'Nicholas', 'Allen', 'nicholas.allen64@yahoo.com', '16191506816'),
(156, 76, 'Shirley', 'Flores', 'shirley.flores@hotmail.com', '12101514735'),
(157, 76, 'Brian', 'Ramirez', 'brian.ramirez@yahoo.com', '13032137434'),
(158, 76, 'Angela', 'Green', 'agreen@icloud.com', '18131530573'),
(159, 76, 'Jonathan', 'Wright', 'jonathan_wright@aol.com', '19411538492'),
(160, 76, 'Melissa', 'Walker', 'melissa.walker@hotmail.com', '12102143681'),
(161, 76, 'Stephen', 'Scott', 'stephen.scott@msn.com', '17271554330'),
(162, 76, 'Anna', 'Nelson', 'annanelson@comcast.net', '19411562249'),
(163, 76, 'Timothy', 'King', 'timothy.king@outlook.com', '12122149928'),
(164, 76, 'Brenda', 'Baker', 'brenda_baker@att.net', '19541578087'),
(165, 76, 'Justin', 'Nguyen', 'justin.nguyen74@sbcglobal.net', '17861586006'),
(166, 76, 'Stephanie', 'Torres', 'stephanie.torres25@icloud.com', '13032156175'),
(167, 76, 'Wei', 'Chen', 'wchen@mail.com', '13861609763'),
(168, 76, 'Mei', 'Wang', 'mei_wang@outlook.com', '12121617682'),
(169, 76, 'Edward', 'Flores', 'edward.flores@aol.com', '12102162422'),
(170, 76, '李', '伟', 'li.wei@earthlink.net', '14071633520');

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(171, 76, 'Xiu', 'Huang', 'xiuhuang@live.com', '14151641439'),
(172, 76, 'Sharon', 'Nelson', 'sharon.nelson@live.com', '12122168669'),
(173, 76, '민준', '김', 'minjun_kim@lycos.com', '16171657277'),
(174, 76, 'Ji-woo', 'Park', 'jiwoo.park84@gmx.com', '17021665196'),
(175, 76, 'Jeffrey', 'Rivera', 'jeffrey.rivera@msn.com', '13032174916'),
(176, 76, 'Trần', 'Thị Hoa', 'tranthihoa@hotmail.com', '13121681034'),
(177, 76, 'Aarav', 'Sharma', 'asharma@fastmail.com', '12131688953'),
(178, 76, 'Cynthia', 'Carter', 'cynthia.carter@comcast.net', '12102181163'),
(179, 76, 'Rohan', 'Mehta', 'rohan.mehta89@aol.com', '12061704791'),
(180, 76, 'محمد', 'الفارسي', 'mohammed.alfarsi@live.com', '12141712710'),
(181, 76, 'Jacob', 'Johnson', 'jacob.johnson30@verizon.net', '12122187410'),
(182, 76, 'נועה', 'כהן', 'ncohen@comcast.net', '14801728548'),
(183, 76, 'Itai', 'Levi', 'itai_levi@verizon.net', '16021736467'),
(184, 76, 'Amy', 'Jones', 'amy.jones@att.net', '13032193657'),
(185, 76, 'Дмитрий', 'Иванов', 'dmitri.ivanov@sbcglobal.net', '17731752305'),
(186, 76, 'Anastasia', 'Petrova', 'anastasiapetrova@hotmail.com', '18321760224'),
(187, 76, 'Nicholas', 'Davis', 'nicholas.davis@sbcglobal.net', '12102199904'),
(188, 76, 'Ingrid', 'Fischer', 'ingrid_fischer@mail.com', '16151776062'),
(189, 76, 'André', 'Dubois', 'andre.dubois99@aol.com', '19011783981'),
(190, 76, 'Angela', 'Hernandez', 'angela.hernandez@protonmail.com', '12122206151'),
(191, 76, 'Siobhán', 'O''Brien', 'siobhanobrien@earthlink.net', '14121799819'),
(192, 76, 'Chinedu', 'Okafor', 'cokafor@juno.com', '15031807738'),
(193, 76, 'Jonathan', 'Wilson', 'jonathan.wilson@gmx.com', '13032212398'),
(194, 76, 'Amelia', 'Stone', 'amelia.stone@gmail.com', '14158127100'),
(195, 76, 'Amelia', 'Stone', 'Amelia.Stone@GMAIL.com', '15128135019'),
(196, 76, 'Anna', 'Taylor', 'anna.taylor35@mail.com', '12102218645'),
(197, 76, 'Farid', 'Boone', 'farid.boone@zoho.com', '+1-407-555-0199'),
(198, 76, '  Grace', 'Holloway  ', ' grace.holloway@yahoo.com ', '16178142938'),
(199, 76, 'Larry', 'Martin', 'larry.martin@zoho.com', '12122224892'),
(200, 76, 'Al', 'O', 'al.o@gmail.com', '17188158776'),
(201, 76, 'Bartholomew', 'Montgomery-Fitzgerald-Worthington-Ashcroft-Pemberton-Radcliffe-Beaumont-Thornbury-Winterbourne-Castellane-Hollingsworth-Abernathy-Featherstonehaugh-Ravensworth-Chetwynd-Devereux-Montgomery-Fitzgerald-Worthington-Ashcroft-Pemberton-Radcliffe-Beaumont-', 'bartholomew.long@protonmail.com', '13128166695'),
(202, 76, 'Pamela', 'Thompson', 'pamela.thompson@fastmail.com', '13032231139'),
(203, 76, 'Ava', 'Smith-Jones', 'ava.smith-jones@icloud.com', '14048182533'),
(204, 76, 'Freya', 'Andersen', 'freya.andersen@gmx.com', '+44 20 7946 0958'),
(205, 76, 'Scott', 'Sanchez', 'scott.sanchez@earthlink.net', '12102237386'),
(206, 76, 'Lin', 'Fang', 'lin.fang@163.com', '+86 138 0013 8000'),
(207, 76, 'Isla', 'Brennan', 'isla.brennan@fastmail.com', NULL),
(208, 76, 'Samantha', 'Lewis', 'samantha.lewis@juno.com', '12122243633'),
(209, 76, 'Trinity', 'Vance', 'trinity.vance@lycos.com', '12068190452'),
(210, 76, 'Benjamin', 'Young', 'benjamin.young3@netzero.net', '13032249880');

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(211, 76, 'Emma', 'Wright', 'emma.wright@lycos.com', '12102256127'),
(212, 76, 'Gregory', 'Nguyen', 'gregory.nguyen@gmail.com', '12122262374'),
(213, 76, 'Christine', 'Green', 'christine.green@yahoo.com', '13032268621'),
(214, 76, 'Alexander', 'Baker', 'alexander.baker@hotmail.com', '12102274868'),
(215, 76, 'Debra', 'Campbell', 'debra.campbell8@outlook.com', '12122281115'),
(216, 76, 'Patrick', 'Roberts', 'patrick.roberts@icloud.com', '13032287362'),
(217, 76, 'Carolyn', 'Williams', 'carolyn.williams@aol.com', '12102293609'),
(218, 76, 'Dennis', 'Garcia', 'dennis.garcia@live.com', '12122299856'),
(219, 76, 'Virginia', 'Rodriguez', 'virginia.rodriguez@msn.com', '13032306103'),
(220, 76, 'James', 'Lopez', 'james.lopez13@comcast.net', '12102312350'),
(221, 76, 'Patricia', 'Anderson', 'patricia.anderson@verizon.net', '12122318597'),
(222, 76, 'Robert', 'Moore', 'robert.moore@att.net', '13032324844'),
(223, 76, 'Linda', 'Lee', 'linda.lee@sbcglobal.net', '12102331091'),
(224, 76, 'David', 'White', 'david.white@protonmail.com', '12122337338'),
(225, 76, 'Barbara', 'Clark', 'barbara.clark18@gmx.com', '13032343585'),
(226, 76, 'Richard', 'Robinson', 'richard.robinson@mail.com', '12102349832'),
(227, 76, 'Jessica', 'Allen', 'jessica.allen@zoho.com', '12122356079'),
(228, 76, 'Thomas', 'Scott', 'thomas.scott@fastmail.com', '13032362326'),
(229, 76, 'Karen', 'Hill', 'karen.hill@earthlink.net', '12102368573'),
(230, 76, 'Charles', 'Adams', 'charles.adams23@juno.com', '12122374820'),
(231, 76, 'Lisa', 'Hall', 'lisa.hall@netzero.net', '13032381067'),
(232, 76, 'Matthew', 'Mitchell', 'matthew.mitchell@lycos.com', '12102387314'),
(233, 76, 'Betty', 'Smith', 'betty.smith@gmail.com', '12122393561'),
(234, 76, 'Mark', 'Brown', 'mark.brown@yahoo.com', '13032399808'),
(235, 76, 'Ashley', 'Miller', 'ashley.miller28@hotmail.com', '12102406055'),
(236, 76, 'Steven', 'Martinez', 'steven.martinez@outlook.com', '12122412302'),
(237, 76, 'Kimberly', 'Gonzalez', 'kimberly.gonzalez@icloud.com', '13032418549'),
(238, 76, 'Andrew', 'Thomas', 'andrew.thomas@aol.com', '12102424796'),
(239, 76, 'Donna', 'Jackson', 'donna.jackson@live.com', '12122431043'),
(240, 76, 'Kenneth', 'Perez', 'kenneth.perez33@msn.com', '13032437290'),
(241, 76, 'Carol', 'Harris', 'carol.harris@comcast.net', '12102443537'),
(242, 76, 'Brian', 'Ramirez', 'brian.ramirez@verizon.net', '12122449784'),
(243, 76, 'Melissa', 'Walker', 'melissa.walker@att.net', '13032456031'),
(244, 76, 'Timothy', 'King', 'timothy.king@sbcglobal.net', '12102462278'),
(245, 76, 'Stephanie', 'Torres', 'stephanie.torres1@protonmail.com', '12122468525'),
(246, 76, 'Edward', 'Flores', 'edward.flores@gmx.com', '13032474772'),
(247, 76, 'Sharon', 'Nelson', 'sharon.nelson@mail.com', '12102481019'),
(248, 76, 'Jeffrey', 'Rivera', 'jeffrey.rivera@zoho.com', '12122487266'),
(249, 76, 'Cynthia', 'Carter', 'cynthia.carter@fastmail.com', '13032493513'),
(250, 76, 'Jacob', 'Johnson', 'jacob.johnson6@earthlink.net', '12102499760');

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(251, 76, 'Amy', 'Jones', 'amy.jones@juno.com', '12122506007'),
(252, 76, 'Nicholas', 'Davis', 'nicholas.davis@netzero.net', '13032512254'),
(253, 76, 'Angela', 'Hernandez', 'angela.hernandez@lycos.com', '12102518501'),
(254, 76, 'Jonathan', 'Wilson', 'jonathan.wilson@gmail.com', '12122524748'),
(255, 76, 'Anna', 'Taylor', 'anna.taylor11@yahoo.com', '13032530995'),
(256, 76, 'Larry', 'Martin', 'larry.martin@hotmail.com', '12102537242'),
(257, 76, 'Pamela', 'Thompson', 'pamela.thompson@outlook.com', '12122543489'),
(258, 76, 'Scott', 'Sanchez', 'scott.sanchez@icloud.com', '13032549736'),
(259, 76, 'Samantha', 'Lewis', 'samantha.lewis@aol.com', '12102555983'),
(260, 76, 'Benjamin', 'Young', 'benjamin.young16@live.com', '12122562230'),
(261, 76, 'Emma', 'Wright', 'emma.wright@msn.com', '13032568477'),
(262, 76, 'Gregory', 'Nguyen', 'gregory.nguyen@comcast.net', '12102574724'),
(263, 76, 'Christine', 'Green', 'christine.green@verizon.net', '12122580971'),
(264, 76, 'Alexander', 'Baker', 'alexander.baker@att.net', '13032587218'),
(265, 76, 'Debra', 'Campbell', 'debra.campbell21@sbcglobal.net', '12102593465'),
(266, 76, 'Patrick', 'Roberts', 'patrick.roberts@protonmail.com', '12122599712'),
(267, 76, 'Carolyn', 'Williams', 'carolyn.williams@gmx.com', '13032605959'),
(268, 76, 'Dennis', 'Garcia', 'dennis.garcia@mail.com', '12102612206'),
(269, 76, 'Virginia', 'Rodriguez', 'virginia.rodriguez@zoho.com', '12122618453'),
(270, 76, 'James', 'Lopez', 'james.lopez26@fastmail.com', '13032624700'),
(271, 76, 'Patricia', 'Anderson', 'patricia.anderson@earthlink.net', '12102630947'),
(272, 76, 'Robert', 'Moore', 'robert.moore@juno.com', '12122637194'),
(273, 76, 'Linda', 'Lee', 'linda.lee@netzero.net', '13032643441'),
(274, 76, 'David', 'White', 'david.white@lycos.com', '12102649688'),
(275, 76, 'Barbara', 'Clark', 'barbara.clark31@gmail.com', '12122655935'),
(276, 76, 'Richard', 'Robinson', 'richard.robinson@yahoo.com', '13032662182'),
(277, 76, 'Jessica', 'Allen', 'jessica.allen@hotmail.com', '12102668429'),
(278, 76, 'Thomas', 'Scott', 'thomas.scott@outlook.com', '12122674676'),
(279, 76, 'Karen', 'Hill', 'karen.hill@icloud.com', '13032680923'),
(280, 76, 'Charles', 'Adams', 'charles.adams36@aol.com', '12102687170'),
(281, 76, 'Lisa', 'Hall', 'lisa.hall@live.com', '12122693417'),
(282, 76, 'Matthew', 'Mitchell', 'matthew.mitchell@msn.com', '13032699664'),
(283, 76, 'Betty', 'Smith', 'betty.smith@comcast.net', '12102705911'),
(284, 76, 'Mark', 'Brown', 'mark.brown@verizon.net', '12122712158'),
(285, 76, 'Ashley', 'Miller', 'ashley.miller4@att.net', '13032718405'),
(286, 76, 'Steven', 'Martinez', 'steven.martinez@sbcglobal.net', '12102724652'),
(287, 76, 'Kimberly', 'Gonzalez', 'kimberly.gonzalez@protonmail.com', '12122730899'),
(288, 76, 'Andrew', 'Thomas', 'andrew.thomas@gmx.com', '13032737146'),
(289, 76, 'Donna', 'Jackson', 'donna.jackson@mail.com', '12102743393'),
(290, 76, 'Kenneth', 'Perez', 'kenneth.perez9@zoho.com', '12122749640');

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(291, 76, 'Carol', 'Harris', 'carol.harris@fastmail.com', '13032755887'),
(292, 76, 'Brian', 'Ramirez', 'brian.ramirez@earthlink.net', '12102762134'),
(293, 76, 'Melissa', 'Walker', 'melissa.walker@juno.com', '12122768381'),
(294, 76, 'Timothy', 'King', 'timothy.king@netzero.net', '13032774628'),
(295, 76, 'Stephanie', 'Torres', 'stephanie.torres14@lycos.com', '12102780875'),
(296, 76, 'Edward', 'Flores', 'edward.flores@gmail.com', '12122787122'),
(297, 76, 'Sharon', 'Nelson', 'sharon.nelson@yahoo.com', '13032793369'),
(298, 76, 'Jeffrey', 'Rivera', 'jeffrey.rivera@hotmail.com', '12102799616'),
(299, 76, 'Cynthia', 'Carter', 'cynthia.carter@outlook.com', '12122805863'),
(300, 76, 'Jacob', 'Johnson', 'jacob.johnson19@icloud.com', '13032812110'),
(301, 76, 'Amy', 'Jones', 'amy.jones@aol.com', '12102818357'),
(302, 76, 'Nicholas', 'Davis', 'nicholas.davis@live.com', '12122824604'),
(303, 76, 'Angela', 'Hernandez', 'angela.hernandez@msn.com', '13032830851'),
(304, 76, 'Jonathan', 'Wilson', 'jonathan.wilson@comcast.net', '12102837098'),
(305, 76, 'Anna', 'Taylor', 'anna.taylor24@verizon.net', '12122843345'),
(306, 76, 'Larry', 'Martin', 'larry.martin@att.net', '13032849592'),
(307, 76, 'Pamela', 'Thompson', 'pamela.thompson@sbcglobal.net', '12102855839'),
(308, 76, 'Scott', 'Sanchez', 'scott.sanchez@protonmail.com', '12122862086'),
(309, 76, 'Samantha', 'Lewis', 'samantha.lewis@gmx.com', '13032868333'),
(310, 76, 'Benjamin', 'Young', 'benjamin.young29@mail.com', '12102874580');

-- Same person case: one external contact (not a User) added identically by two unrelated owners (Users 20 and 45).
INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(311, 20, 'Priyanka', 'Iyer', 'priyanka.iyer.friend@gmail.com', '14075559981'),  -- same-person case: shared external contact, owner A
(312, 45, 'Priyanka', 'Iyer', 'priyanka.iyer.friend@gmail.com', '14075559981');  -- same-person case: shared external contact, owner B

-- Regular users: 1-5 contacts each Users [16, 25, 34, 43, 52, 61, 70] are  given ZERO contacts
INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(313, 17, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(314, 18, 'Emma', 'Wright', 'emma.wright@zoho.com', '12122880827'),
(315, 18, 'Margaret', 'Martin', 'margaret.martin@icloud.com', '16191197975'),
(316, 19, 'Emily', 'Sanchez', 'esanchez@fastmail.com', '13521293003'),
(317, 19, 'Gregory', 'Nguyen', 'gregory.nguyen@fastmail.com', '13032887074'),
(318, 19, 'Carol', 'Lewis', 'carol_lewis@yahoo.com', '15121340517'),
(319, 20, 'Christine', 'Green', 'christine.green@earthlink.net', '12102893321'),
(320, 20, 'Sharon', 'Wright', 'sharon.wright@gmx.com', '16461435545'),
(321, 20, 'Alexander', 'Baker', 'alexander.baker@juno.com', '12122899568'),
(322, 20, 'Kathleen', 'Nguyen', 'kathleennguyen@netzero.net', '12161483059'),
(323, 21, 'Angela', 'Green', 'agreen@icloud.com', '18131530573'),
(324, 21, 'Debra', 'Campbell', 'debra.campbell34@netzero.net', '13032905815'),
(325, 21, 'Brenda', 'Baker', 'brenda_baker@att.net', '19541578087'),
(326, 21, 'Patrick', 'Roberts', 'patrick.roberts@lycos.com', '12102912062'),
(327, 21, 'Jun', 'Li', 'jun.li79@fastmail.com', '13051625601'),
(328, 22, 'Carolyn', 'Williams', 'carolyn.williams@gmail.com', '12122918309'),
(329, 23, 'Hans', 'Müller', 'hmuller@gmx.com', '19041768143'),
(330, 23, 'Dennis', 'Garcia', 'dennis.garcia@yahoo.com', '13032924556'),
(331, 24, 'Virginia', 'Rodriguez', 'virginia.rodriguez@hotmail.com', '12102930803'),
(332, 24, 'Arjun', 'Rao', 'arjun.rao@rediffmail.com', '+91 98765 43210'),
(333, 24, 'James', 'Lopez', 'james.lopez2@outlook.com', '12122937050'),
(334, 26, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(335, 26, 'Patricia', 'Anderson', 'patricia.anderson@icloud.com', '13032943297'),
(336, 26, 'Susan', 'Wilson', 'susan_wilson@gmx.com', '13031102947'),
(337, 26, 'Robert', 'Moore', 'robert.moore@aol.com', '12102949544'),
(338, 27, 'Linda', 'Lee', 'linda.lee@live.com', '12122955791'),
(339, 27, 'Margaret', 'Martin', 'margaret.martin@icloud.com', '16191197975'),
(340, 27, 'David', 'White', 'david.white@msn.com', '13032962038'),
(341, 27, 'Ashley', 'Thompson', 'ashleythompson@att.net', '17271245489'),
(342, 27, 'Barbara', 'Clark', 'barbara.clark7@comcast.net', '12102968285'),
(343, 28, 'Emily', 'Sanchez', 'esanchez@fastmail.com', '13521293003'),
(344, 29, 'Richard', 'Robinson', 'richard.robinson@verizon.net', '12122974532'),
(345, 29, 'Sharon', 'Wright', 'sharon.wright@gmx.com', '16461435545'),
(346, 30, 'Angela', 'Green', 'agreen@icloud.com', '18131530573'),
(347, 30, 'Jessica', 'Allen', 'jessica.allen@att.net', '13032980779'),
(348, 30, 'Brenda', 'Baker', 'brenda_baker@att.net', '19541578087'),
(349, 31, 'Thomas', 'Scott', 'thomas.scott@sbcglobal.net', '12102987026'),
(350, 31, 'Nguyễn', 'Văn An', 'nguyen.vanan@yahoo.com', '17181673115'),
(351, 31, 'Karen', 'Hill', 'karen.hill@protonmail.com', '12122993273'),
(352, 31, 'Fatima', 'Hassan', 'fatimahassan@msn.com', '13031720629');

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(353, 32, 'Hans', 'Müller', 'hmuller@gmx.com', '19041768143'),
(354, 32, 'Charles', 'Adams', 'charles.adams12@gmx.com', '13032999520'),
(355, 32, 'Katarzyna', 'Kowalska', 'katarzyna_kowalska@netzero.net', '16191815657'),
(356, 32, 'Lisa', 'Hall', 'lisa.hall@mail.com', '12103005767'),
(357, 32, 'Bo', 'Xu', 'bo.xu@qq.com', '17028150857'),
(358, 33, 'Matthew', 'Mitchell', 'matthew.mitchell@zoho.com', '12123012014'),
(359, 35, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(360, 35, 'Betty', 'Smith', 'betty.smith@fastmail.com', '13033018261'),
(361, 36, 'Mark', 'Brown', 'mark.brown@earthlink.net', '12103024508'),
(362, 36, 'Margaret', 'Martin', 'margaret.martin@icloud.com', '16191197975'),
(363, 36, 'Ashley', 'Miller', 'ashley.miller17@juno.com', '12123030755'),
(364, 37, 'Emily', 'Sanchez', 'esanchez@fastmail.com', '13521293003'),
(365, 37, 'Steven', 'Martinez', 'steven.martinez@netzero.net', '13033037002'),
(366, 37, 'Carol', 'Lewis', 'carol_lewis@yahoo.com', '15121340517'),
(367, 37, 'Kimberly', 'Gonzalez', 'kimberly.gonzalez@lycos.com', '12103043249'),
(368, 38, 'Andrew', 'Thomas', 'andrew.thomas@gmail.com', '12123049496'),
(369, 38, 'Sharon', 'Wright', 'sharon.wright@gmx.com', '16461435545'),
(370, 38, 'Donna', 'Jackson', 'donna.jackson@yahoo.com', '13033055743'),
(371, 38, 'Kathleen', 'Nguyen', 'kathleennguyen@netzero.net', '12161483059'),
(372, 38, 'Kenneth', 'Perez', 'kenneth.perez22@hotmail.com', '12103061990'),
(373, 39, 'Angela', 'Green', 'agreen@icloud.com', '18131530573'),
(374, 40, 'Carol', 'Harris', 'carol.harris@outlook.com', '12123068237'),
(375, 40, 'Nguyễn', 'Văn An', 'nguyen.vanan@yahoo.com', '17181673115'),
(376, 41, 'Hans', 'Müller', 'hmuller@gmx.com', '19041768143'),
(377, 41, 'Brian', 'Ramirez', 'brian.ramirez@icloud.com', '13033074484'),
(378, 41, 'Katarzyna', 'Kowalska', 'katarzyna_kowalska@netzero.net', '16191815657'),
(379, 42, 'Melissa', 'Walker', 'melissa.walker@aol.com', '12103080731'),
(380, 42, 'Arjun', 'Rao', 'arjun.rao@rediffmail.com', '+91 98765 43210'),
(381, 42, 'Timothy', 'King', 'timothy.king@live.com', '12123086978'),
(382, 42, 'Mary', 'Davis', 'marydavis@yahoo.com', '13051007919'),
(383, 44, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(384, 44, 'Stephanie', 'Torres', 'stephanie.torres27@msn.com', '13033093225'),
(385, 44, 'Susan', 'Wilson', 'susan_wilson@gmx.com', '13031102947'),
(386, 44, 'Edward', 'Flores', 'edward.flores@comcast.net', '12103099472'),
(387, 44, 'Karen', 'Taylor', 'karen.taylor19@netzero.net', '19041150461'),
(388, 45, 'Sharon', 'Nelson', 'sharon.nelson@verizon.net', '12123105719'),
(389, 46, 'Emily', 'Sanchez', 'esanchez@fastmail.com', '13521293003'),
(390, 46, 'Jeffrey', 'Rivera', 'jeffrey.rivera@att.net', '13033111966'),
(391, 47, 'Cynthia', 'Carter', 'cynthia.carter@sbcglobal.net', '12103118213'),
(392, 47, 'Sharon', 'Wright', 'sharon.wright@gmx.com', '16461435545');

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(393, 47, 'Jacob', 'Johnson', 'jacob.johnson32@protonmail.com', '12123124460'),
(394, 48, 'Angela', 'Green', 'agreen@icloud.com', '18131530573'),
(395, 48, 'Amy', 'Jones', 'amy.jones@gmx.com', '13033130707'),
(396, 48, 'Brenda', 'Baker', 'brenda_baker@att.net', '19541578087'),
(397, 48, 'Nicholas', 'Davis', 'nicholas.davis@mail.com', '12103136954'),
(398, 49, 'Angela', 'Hernandez', 'angela.hernandez@zoho.com', '12123143201'),
(399, 49, 'Nguyễn', 'Văn An', 'nguyen.vanan@yahoo.com', '17181673115'),
(400, 49, 'Jonathan', 'Wilson', 'jonathan.wilson@fastmail.com', '13033149448'),
(401, 49, 'Fatima', 'Hassan', 'fatimahassan@msn.com', '13031720629'),
(402, 49, 'Anna', 'Taylor', 'anna.taylor0@earthlink.net', '12103155695'),
(403, 50, 'Hans', 'Müller', 'hmuller@gmx.com', '19041768143'),
(404, 51, 'Larry', 'Martin', 'larry.martin@juno.com', '12123161942'),
(405, 51, 'Arjun', 'Rao', 'arjun.rao@rediffmail.com', '+91 98765 43210'),
(406, 53, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(407, 53, 'Pamela', 'Thompson', 'pamela.thompson@netzero.net', '13033168189'),
(408, 53, 'Susan', 'Wilson', 'susan_wilson@gmx.com', '13031102947'),
(409, 54, 'Scott', 'Sanchez', 'scott.sanchez@lycos.com', '12103174436'),
(410, 54, 'Margaret', 'Martin', 'margaret.martin@icloud.com', '16191197975'),
(411, 54, 'Samantha', 'Lewis', 'samantha.lewis@gmail.com', '12123180683'),
(412, 54, 'Ashley', 'Thompson', 'ashleythompson@att.net', '17271245489'),
(413, 55, 'Emily', 'Sanchez', 'esanchez@fastmail.com', '13521293003'),
(414, 55, 'Benjamin', 'Young', 'benjamin.young5@yahoo.com', '13033186930'),
(415, 55, 'Carol', 'Lewis', 'carol_lewis@yahoo.com', '15121340517'),
(416, 55, 'Emma', 'Wright', 'emma.wright@hotmail.com', '12103193177'),
(417, 55, 'Deborah', 'Young', 'deborah.young49@msn.com', '14041388031'),
(418, 56, 'Gregory', 'Nguyen', 'gregory.nguyen@outlook.com', '12123199424'),
(419, 57, 'Angela', 'Green', 'agreen@icloud.com', '18131530573'),
(420, 57, 'Christine', 'Green', 'christine.green@icloud.com', '13033205671'),
(421, 58, 'Alexander', 'Baker', 'alexander.baker@aol.com', '12103211918'),
(422, 58, 'Nguyễn', 'Văn An', 'nguyen.vanan@yahoo.com', '17181673115'),
(423, 58, 'Debra', 'Campbell', 'debra.campbell10@live.com', '12123218165'),
(424, 59, 'Hans', 'Müller', 'hmuller@gmx.com', '19041768143'),
(425, 59, 'Patrick', 'Roberts', 'patrick.roberts@msn.com', '13033224412'),
(426, 59, 'Katarzyna', 'Kowalska', 'katarzyna_kowalska@netzero.net', '16191815657'),
(427, 59, 'Carolyn', 'Williams', 'carolyn.williams@comcast.net', '12103230659'),
(428, 60, 'Dennis', 'Garcia', 'dennis.garcia@verizon.net', '12123236906'),
(429, 60, 'Arjun', 'Rao', 'arjun.rao@rediffmail.com', '+91 98765 43210'),
(430, 60, 'Virginia', 'Rodriguez', 'virginia.rodriguez@att.net', '13033243153'),
(431, 60, 'Mary', 'Davis', 'marydavis@yahoo.com', '13051007919'),
(432, 60, 'James', 'Lopez', 'james.lopez15@sbcglobal.net', '12103249400');

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(433, 62, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(434, 63, 'Patricia', 'Anderson', 'patricia.anderson@protonmail.com', '12123255647'),
(435, 63, 'Margaret', 'Martin', 'margaret.martin@icloud.com', '16191197975'),
(436, 64, 'Emily', 'Sanchez', 'esanchez@fastmail.com', '13521293003'),
(437, 64, 'Robert', 'Moore', 'robert.moore@gmx.com', '13033261894'),
(438, 64, 'Carol', 'Lewis', 'carol_lewis@yahoo.com', '15121340517'),
(439, 65, 'Linda', 'Lee', 'linda.lee@mail.com', '12103268141'),
(440, 65, 'Sharon', 'Wright', 'sharon.wright@gmx.com', '16461435545'),
(441, 65, 'David', 'White', 'david.white@zoho.com', '12123274388'),
(442, 65, 'Kathleen', 'Nguyen', 'kathleennguyen@netzero.net', '12161483059'),
(443, 66, 'Angela', 'Green', 'agreen@icloud.com', '18131530573'),
(444, 66, 'Barbara', 'Clark', 'barbara.clark20@fastmail.com', '13033280635'),
(445, 66, 'Brenda', 'Baker', 'brenda_baker@att.net', '19541578087'),
(446, 66, 'Richard', 'Robinson', 'richard.robinson@earthlink.net', '12103286882'),
(447, 66, 'Jun', 'Li', 'jun.li79@fastmail.com', '13051625601'),
(448, 67, 'Jessica', 'Allen', 'jessica.allen@juno.com', '12123293129'),
(449, 68, 'Hans', 'Müller', 'hmuller@gmx.com', '19041768143'),
(450, 68, 'Thomas', 'Scott', 'thomas.scott@netzero.net', '13033299376'),
(451, 69, 'Karen', 'Hill', 'karen.hill@lycos.com', '12103305623'),
(452, 69, 'Arjun', 'Rao', 'arjun.rao@rediffmail.com', '+91 98765 43210'),
(453, 69, 'Charles', 'Adams', 'charles.adams25@gmail.com', '12123311870'),
(454, 71, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(455, 71, 'Lisa', 'Hall', 'lisa.hall@yahoo.com', '13033318117'),
(456, 71, 'Susan', 'Wilson', 'susan_wilson@gmx.com', '13031102947'),
(457, 71, 'Matthew', 'Mitchell', 'matthew.mitchell@hotmail.com', '12103324364'),
(458, 72, 'Betty', 'Smith', 'betty.smith@outlook.com', '12123330611'),
(459, 72, 'Margaret', 'Martin', 'margaret.martin@icloud.com', '16191197975'),
(460, 72, 'Mark', 'Brown', 'mark.brown@icloud.com', '13033336858'),
(461, 72, 'Ashley', 'Thompson', 'ashleythompson@att.net', '17271245489'),
(462, 72, 'Ashley', 'Miller', 'ashley.miller30@aol.com', '12103343105'),
(463, 73, 'Emily', 'Sanchez', 'esanchez@fastmail.com', '13521293003'),
(464, 74, 'Steven', 'Martinez', 'steven.martinez@live.com', '12123349352'),
(465, 74, 'Sharon', 'Wright', 'sharon.wright@gmx.com', '16461435545'),
(466, 75, 'Angela', 'Green', 'agreen@icloud.com', '18131530573'),
(467, 75, 'Kimberly', 'Gonzalez', 'kimberly.gonzalez@msn.com', '13033355599'),
(468, 75, 'Brenda', 'Baker', 'brenda_baker@att.net', '19541578087'),
(469, 77, 'Andrew', 'Thomas', 'andrew.thomas@comcast.net', '12103361846'),
(470, 77, 'Nguyễn', 'Văn An', 'nguyen.vanan@yahoo.com', '17181673115'),
(471, 77, 'Donna', 'Jackson', 'donna.jackson@verizon.net', '12123368093'),
(472, 77, 'Fatima', 'Hassan', 'fatimahassan@msn.com', '13031720629');

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(473, 78, 'Hans', 'Müller', 'hmuller@gmx.com', '19041768143'),
(474, 78, 'Kenneth', 'Perez', 'kenneth.perez35@att.net', '13033374340'),
(475, 78, 'Katarzyna', 'Kowalska', 'katarzyna_kowalska@netzero.net', '16191815657'),
(476, 78, 'Carol', 'Harris', 'carol.harris@sbcglobal.net', '12103380587'),
(477, 78, 'Bo', 'Xu', 'bo.xu@qq.com', '17028150857'),
(478, 79, 'Brian', 'Ramirez', 'brian.ramirez@protonmail.com', '12123386834'),
(479, 80, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(480, 80, 'Melissa', 'Walker', 'melissa.walker@gmx.com', '13033393081'),
(481, 81, 'Timothy', 'King', 'timothy.king@mail.com', '12103399328'),
(482, 81, 'Margaret', 'Martin', 'margaret.martin@icloud.com', '16191197975'),
(483, 81, 'Stephanie', 'Torres', 'stephanie.torres3@zoho.com', '12123405575'),
(484, 82, 'Emily', 'Sanchez', 'esanchez@fastmail.com', '13521293003'),
(485, 82, 'Edward', 'Flores', 'edward.flores@fastmail.com', '13033411822'),
(486, 82, 'Carol', 'Lewis', 'carol_lewis@yahoo.com', '15121340517'),
(487, 82, 'Sharon', 'Nelson', 'sharon.nelson@earthlink.net', '12103418069'),
(488, 83, 'Jeffrey', 'Rivera', 'jeffrey.rivera@juno.com', '12123424316'),
(489, 83, 'Sharon', 'Wright', 'sharon.wright@gmx.com', '16461435545'),
(490, 83, 'Cynthia', 'Carter', 'cynthia.carter@netzero.net', '13033430563'),
(491, 83, 'Kathleen', 'Nguyen', 'kathleennguyen@netzero.net', '12161483059'),
(492, 83, 'Jacob', 'Johnson', 'jacob.johnson8@lycos.com', '12103436810'),
(493, 84, 'Angela', 'Green', 'agreen@icloud.com', '18131530573'),
(494, 85, 'Amy', 'Jones', 'amy.jones@gmail.com', '12123443057'),
(495, 85, 'Nguyễn', 'Văn An', 'nguyen.vanan@yahoo.com', '17181673115'),
(496, 86, 'Hans', 'Müller', 'hmuller@gmx.com', '19041768143'),
(497, 86, 'Nicholas', 'Davis', 'nicholas.davis@yahoo.com', '13033449304'),
(498, 86, 'Katarzyna', 'Kowalska', 'katarzyna_kowalska@netzero.net', '16191815657'),
(499, 87, 'Angela', 'Hernandez', 'angela.hernandez@hotmail.com', '12103455551'),
(500, 87, 'Arjun', 'Rao', 'arjun.rao@rediffmail.com', '+91 98765 43210'),
(501, 87, 'Jonathan', 'Wilson', 'jonathan.wilson@outlook.com', '12123461798'),
(502, 87, 'Mary', 'Davis', 'marydavis@yahoo.com', '13051007919'),
(503, 88, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(504, 88, 'Anna', 'Taylor', 'anna.taylor13@icloud.com', '13033468045'),
(505, 88, 'Susan', 'Wilson', 'susan_wilson@gmx.com', '13031102947'),
(506, 88, 'Larry', 'Martin', 'larry.martin@aol.com', '12103474292'),
(507, 88, 'Karen', 'Taylor', 'karen.taylor19@netzero.net', '19041150461'),
(508, 89, 'Pamela', 'Thompson', 'pamela.thompson@live.com', '12123480539'),
(509, 90, 'Emily', 'Sanchez', 'esanchez@fastmail.com', '13521293003'),
(510, 90, 'Scott', 'Sanchez', 'scott.sanchez@msn.com', '13033486786'),
(511, 91, 'Samantha', 'Lewis', 'samantha.lewis@comcast.net', '12103493033'),
(512, 91, 'Sharon', 'Wright', 'sharon.wright@gmx.com', '16461435545');

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(513, 91, 'Benjamin', 'Young', 'benjamin.young18@verizon.net', '12123499280'),
(514, 92, 'Angela', 'Green', 'agreen@icloud.com', '18131530573'),
(515, 92, 'Emma', 'Wright', 'emma.wright@att.net', '13033505527'),
(516, 92, 'Brenda', 'Baker', 'brenda_baker@att.net', '19541578087'),
(517, 92, 'Gregory', 'Nguyen', 'gregory.nguyen@sbcglobal.net', '12103511774'),
(518, 93, 'Christine', 'Green', 'christine.green@protonmail.com', '12123518021'),
(519, 93, 'Nguyễn', 'Văn An', 'nguyen.vanan@yahoo.com', '17181673115'),
(520, 93, 'Alexander', 'Baker', 'alexander.baker@gmx.com', '13033524268'),
(521, 93, 'Fatima', 'Hassan', 'fatimahassan@msn.com', '13031720629'),
(522, 93, 'Debra', 'Campbell', 'debra.campbell23@mail.com', '12103530515'),
(523, 94, 'Hans', 'Müller', 'hmuller@gmx.com', '19041768143'),
(524, 95, 'Patrick', 'Roberts', 'patrick.roberts@zoho.com', '12123536762'),
(525, 95, 'Arjun', 'Rao', 'arjun.rao@rediffmail.com', '+91 98765 43210'),
(526, 96, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433'),
(527, 96, 'Carolyn', 'Williams', 'carolyn.williams@fastmail.com', '13033543009'),
(528, 96, 'Susan', 'Wilson', 'susan_wilson@gmx.com', '13031102947'),
(529, 97, 'Dennis', 'Garcia', 'dennis.garcia@earthlink.net', '12103549256'),
(530, 97, 'Margaret', 'Martin', 'margaret.martin@icloud.com', '16191197975'),
(531, 97, 'Virginia', 'Rodriguez', 'virginia.rodriguez@juno.com', '12123555503'),
(532, 97, 'Ashley', 'Thompson', 'ashleythompson@att.net', '17271245489'),
(533, 98, 'Emily', 'Sanchez', 'esanchez@fastmail.com', '13521293003'),
(534, 98, 'James', 'Lopez', 'james.lopez28@netzero.net', '13033561750'),
(535, 98, 'Carol', 'Lewis', 'carol_lewis@yahoo.com', '15121340517'),
(536, 98, 'Patricia', 'Anderson', 'patricia.anderson@lycos.com', '12103567997'),
(537, 98, 'Deborah', 'Young', 'deborah.young49@msn.com', '14041388031'),
(538, 99, 'Robert', 'Moore', 'robert.moore@gmail.com', '12123574244'),
(539, 100, 'Angela', 'Green', 'agreen@icloud.com', '18131530573'),
(540, 100, 'Linda', 'Lee', 'linda.lee@yahoo.com', '13033580491'),
(541, 101, 'David', 'White', 'david.white@hotmail.com', '12103586738'),
(542, 101, 'Nguyễn', 'Văn An', 'nguyen.vanan@yahoo.com', '17181673115'),
(543, 101, 'Barbara', 'Clark', 'barbara.clark33@outlook.com', '12123592985'),
(544, 102, 'Hans', 'Müller', 'hmuller@gmx.com', '19041768143'),
(545, 102, 'Richard', 'Robinson', 'richard.robinson@icloud.com', '13033599232'),
(546, 102, 'Katarzyna', 'Kowalska', 'katarzyna_kowalska@netzero.net', '16191815657'),
(547, 102, 'Jessica', 'Allen', 'jessica.allen@aol.com', '12103605479'),
(548, 103, 'Thomas', 'Scott', 'thomas.scott@live.com', '12123611726'),
(549, 103, 'Arjun', 'Rao', 'arjun.rao@rediffmail.com', '+91 98765 43210'),
(550, 103, 'Karen', 'Hill', 'karen.hill@msn.com', '13033617973'),
(551, 103, 'Mary', 'Davis', 'marydavis@yahoo.com', '13051007919'),
(552, 103, 'Charles', 'Adams', 'charles.adams1@comcast.net', '12103624220');

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(553, 104, 'Linda', 'Hernandez', 'lhernandez@msn.com', '17181055433');

--  edge-case contacts
INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(554, 3, 'Marcus', 'Whitfield', 'marcus.whitfield@hotmail.com', '14808523050');  -- dup-email-case A (Contacts)

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(555, 22, 'Marcus', 'Whitfield', 'MARCUS.WHITFIELD@HOTMAIL.COM', '16028530969');  -- dup-email-case B (Contacts, same email different case)

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(556, 7, 'Deja', 'Osei', 'deja.osei@aol.com', '4075559090');  -- dup-phone-format A (Contacts)

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(557, 31, 'D.', 'Osei', 'd.osei@aol.com', '(407) 555-9090');  -- dup-phone-format B (Contacts, same number)

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(558, 9, '  Harold', 'Beckett ', '  harold.beckett@verizon.net  ', '  4075557766  ');  -- whitespace in name/email/phone

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(559, 14, 'Vy', 'O', 'vy.o@gmail.com', '16468538888');  -- very short name

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(560, 38, 'Q', 'Li', 'q.li@163.com', '17738546807');  -- very short single-letter first name

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(561, 50, 'WolfgangdietrichWolfgangdietrichWolfgangdietrichWolfgangdietrichWolfgangdietrichWolfgangdietrichWolfgangdietrichWolfgangdietrichWolfgangdietrichWolfgangdietrichWolfgangdietrichWolfgangdietrich', 'Habsburg', 'wolfgang.habsburg@gmx.com', '18328554726');  -- long firstName, 192 chars (limit 255)

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(562, 18, 'Sean', 'O''Malley', 'sean.omalley@icloud.com', '19048562645');  -- apostrophe surname (Contacts)

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(563, 41, 'Lucia', 'Alvarez-Ruiz', 'lucia.alvarez-ruiz@yahoo.com', '16158570564');  -- hyphenated surname (Contacts)

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(564, 65, 'Kwame', 'Mensah', 'kwame.mensah@gmail.com', '+233 24 123 4567');  -- international phone, raw Ghana format

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(565, 60, 'Elif', 'Yildiz', 'elif.yildiz@hotmail.com', '+90 532 123 45 67');  -- international phone, raw Turkey format

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(566, 33, 'Nadia', 'Farouk', 'nadia.farouk@outlook.com', NULL);  -- NULL phone number (Contacts)

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(567, 48, 'Emeka', 'Nnamdi', 'emeka.nnamdi@aol.com', '');  -- empty-string phone number (Contacts)

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(568, 29, 'José', 'García', 'jose.garcia@gmail.com', '19018578483');  -- unicode name example (Jose)

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(569, 44, 'Anneliese', 'Müller', 'anneliese.muller@gmx.de', '12168586402');  -- unicode name example (Muller)

INSERT INTO `Contacts` (`id`, `userID`, `firstName`, `lastName`, `email`, `phoneNumber`) VALUES
(570, 11, '李', '雷', 'li.lei@163.com', '14128594321');  -- unicode name example (native Chinese script, Li Lei)


-- RECOMMENDATION QUERY COMMAND
-- Ranked by how many of my saved contacts (who are also real users) have also saved this candidate.
DROP PROCEDURE IF EXISTS GetRecommendations;

DELIMITER $$

CREATE PROCEDURE GetRecommendations(IN targetUserId INT)
BEGIN
    SELECT
        candidate.email,
        candidate.firstName,
        candidate.lastName,
        COUNT(DISTINCT myConnection.id) AS mutualCount
    FROM Contacts mySavedContact
    JOIN Users myConnection
        ON myConnection.email = mySavedContact.email
        OR myConnection.phoneNumber = mySavedContact.phoneNumber
    JOIN Contacts candidate
        ON candidate.userID = myConnection.id
    LEFT JOIN Contacts alreadySaved
        ON alreadySaved.userID = targetUserId
       AND (alreadySaved.email = candidate.email
            OR alreadySaved.phoneNumber = candidate.phoneNumber)
    WHERE mySavedContact.userID = targetUserId
      AND myConnection.id <> targetUserId
      AND candidate.email <> (SELECT email FROM Users WHERE id = targetUserId)
      AND alreadySaved.id IS NULL
    GROUP BY candidate.email, candidate.firstName, candidate.lastName
    ORDER BY mutualCount DESC
    LIMIT 20;
END$$
 
DELIMITER ;

COMMIT;
SET FOREIGN_KEY_CHECKS = 1;
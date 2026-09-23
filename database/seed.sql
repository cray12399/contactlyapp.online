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
INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(1, 'James', 'Smith', 'xX_jim0_Xx', 'james.smith@gmail.com', '12121000000', '$argon2id$v=19$m=65536,t=3,p=4$PtYgjmUhBel31iEl$2hpChYgCfrL1spNxnyVmihA/2O76UMFx', 1),
(2, 'Mary', 'Davis', 'mary', 'marydavis@yahoo.com', '13051007919', '$argon2id$v=19$m=65536,t=3,p=4$FkM/R5Kjp1vRt+1f$jORS/6ilI8ihN5KXSc7Tvo/hBKqFYY/k', 2),
(3, 'Michael', 'Johnson', 'michael', 'mjohnson@hotmail.com', '14071015838', '$argon2id$v=19$m=65536,t=3,p=4$v5ZJr3J1TWDtkwtD$Db+xHKas1VOqg6YYZYn9ZhyiA4uoRgna', 1),
(4, 'Patricia', 'Rodriguez', 'pat', 'patricia_rodriguez@outlook.com', '14151023757', '$argon2id$v=19$m=65536,t=3,p=4$tmUdjAWtGSU8po+7$99NksnRH9ucAUsdMlHUvTCQCyEZDz/Td', 1),
(5, 'Robert', 'Williams', 'robert', 'robert.williams4@icloud.com', '15121031676', '$argon2id$v=19$m=65536,t=3,p=4$dJ8HyS5SUkCnD8zR$A9a9SkpXz9w3QlY7Zkuvqdt7s8Stqcbn', 1),
(6, 'Jennifer', 'Martinez', 'jennifer', 'jennifer.martinez@aol.com', '16171039595', '$argon2id$v=19$m=65536,t=3,p=4$r3yBdGBLEPH1qhT6$1qtc4xatws8phP9nhFyJfm5di4PzJ59F', 1),
(7, 'John', 'Brown', 'john', 'johnbrown@live.com', '17021047514', '$argon2id$v=19$m=65536,t=3,p=4$Hz5r1pY4OjE2jBMp$tUsGr7CmY+uCu3ZR1zTOlUcR64cXQLio', 1),
(8, 'Linda', 'Hernandez', 'linda', 'lhernandez@msn.com', '17181055433', '$argon2id$v=19$m=65536,t=3,p=4$DnkHIfxIq2HZt/Pl$Jhx2jIclHkCiHp6bR1IqfEouHgxzNNAL', 1),
(9, 'David', 'Jones', 'david', 'david_jones@comcast.net', '13121063352', '$argon2id$v=19$m=65536,t=3,p=4$5wIScGebcy8F5n3/$YNBDRzrZSgqbjG3uhkWKFLf6xuI5aHUQ', 1),
(10, 'Elizabeth', 'Lopez', 'liz', 'elizabeth.lopez9@verizon.net', '12131071271', '$argon2id$v=19$m=65536,t=3,p=4$PFeNBTxaQWk8JzFa$lHlsZfYcMMDktXP/tKsf2rcDkdfrUnW5', 0),
(11, 'William', 'Garcia', 'william', 'william.garcia@att.net', '14041079190', '$argon2id$v=19$m=65536,t=3,p=4$gcF+Ha6ili8GjHEA$D6/Wj9KfzjsQGMrb9h+ImB+LK777pzNk', 1),
(12, 'Barbara', 'Gonzalez', '~barbara~11', 'barbaragonzalez@sbcglobal.net', '12061087109', '$argon2id$v=19$m=65536,t=3,p=4$8cL6j5IXAAjlsHUq$JoUD/+Ydua+5ZMs1SWOpQaPRYpzbLGVi', 1),
(13, 'Richard', 'Miller', 'rick', 'rmiller@protonmail.com', '12141095028', '$argon2id$v=19$m=65536,t=3,p=4$YXjU2JgJngKtFI3O$yV2dZAkg05rK+gqv81RKMGHZEM9Ypvuj', 1),
(14, 'Susan', 'Wilson', 'susan', 'susan_wilson@gmx.com', '13031102947', '$argon2id$v=19$m=65536,t=3,p=4$A/C5Q52ryFlwRlOE$VHzc0X0AWIRh/JUqBlIFXZ53Ncqe28+a', 1),
(15, 'Joseph', 'Davis', 'joseph', 'joseph.davis14@mail.com', '14801110866', '$argon2id$v=19$m=65536,t=3,p=4$jY75FnCttn6kfaqD$eMqG3omjMyXHCabM6JOF8EFd0Nhcy/1k', 1),
(16, 'Jessica', 'Anderson', 'jessica', 'jessica.anderson@zoho.com', '16021118785', '$argon2id$v=19$m=65536,t=3,p=4$GD2VD/eR1UYzaLiA$/zNyD7CHLn/xC+1hsYgBds1ghxY5Ookv', 0),
(17, 'Thomas', 'Rodriguez', 'thomas', 'thomasrodriguez@fastmail.com', '16461126704', '$argon2id$v=19$m=65536,t=3,p=4$Qyx7eNWVQ4vnakJk$S1pAWTN3lg8zV5yPU8d0FZfWe7ihGyiR', 1),
(18, 'Sarah', 'Thomas', 'sarah', 'sthomas@earthlink.net', '17731134623', '$argon2id$v=19$m=65536,t=3,p=4$UIQfHOJMaidDn87X$G3/q/xbMtEPO6UkzYuF0ie9Pu2njHkAm', 1),
(19, 'Christopher', 'Martinez', 'chris', 'christopher_martinez@juno.com', '18321142542', '$argon2id$v=19$m=65536,t=3,p=4$1/5wDr16EpLLJIVG$Hz4FxFEtKyPiYGFDm7ena8D5VfLDpgyy', 1),
(20, 'Karen', 'Taylor', 'karen', 'karen.taylor19@netzero.net', '19041150461', '$argon2id$v=19$m=65536,t=3,p=4$jVw5HanSBeVRsfAG$eAbP0VxNjAe/9i0mYtluYI0KN1gNT11c', 1),
(21, 'Charles', 'Hernandez', 'charles', 'charles.hernandez@lycos.com', '16151158380', '$argon2id$v=19$m=65536,t=3,p=4$UzYZAa3u2olZU6uq$bgsYlVvsSKuvinX+zMqf9OgXluCZz8xB', 1),
(22, 'Nancy', 'Moore', 'nancy', 'nancymoore@gmail.com', '19011166299', '$argon2id$v=19$m=65536,t=3,p=4$fZuXTptFyfePpX6N$1NF2XV54wca+7E56w8ZniqT3Ul4ffqkO', 1),
(23, 'Daniel', 'Lopez', 'd_a_n_i', 'dlopez@yahoo.com', '12161174218', '$argon2id$v=19$m=65536,t=3,p=4$kgWrdioyq+KvCiSG$uPJ6sG9AHEOVezxZuJPWvHogU5nGYVHW', 1),
(24, 'Lisa', 'Jackson', 'lisa', 'lisa_jackson@hotmail.com', '14121182137', '$argon2id$v=19$m=65536,t=3,p=4$VsUQk4DwgLGNOaeC$tL31Ugq+DfcgaTMnTC0MrAU8urbFt5mi', 1),
(25, 'Matthew', 'Gonzalez', 'matt', 'matthew.gonzalez24@outlook.com', '15031190056', '$argon2id$v=19$m=65536,t=3,p=4$sIZHbhS4/FvafhdZ$xEuhnbzs0z1wNiMg9aW37k5wCnHDepQH', 1),
(26, 'Margaret', 'Martin', 'margaret', 'margaret.martin@icloud.com', '16191197975', '$argon2id$v=19$m=65536,t=3,p=4$gI3HLBkbvHEzuPyX$QEW88ad3DNBYjvsedonuSsddfrfifiUz', 1),
(27, 'Anthony', 'Wilson', 'anthony', 'anthonywilson@aol.com', '12101205894', '$argon2id$v=19$m=65536,t=3,p=4$iXnFAAoeelK9mqmA$LOR2HcSGKgVP8Kd0d3mS8gBlKv3azKga', 1),
(28, 'Betty', 'Lee', 'betty', 'blee@live.com', '14691213813', '$argon2id$v=19$m=65536,t=3,p=4$S+m+x/SHuKBD/vok$+nPTmZYl2dVAMH2vWD6qeSPt5Pv74GDq', 1),
(29, 'Mark', 'Anderson', 'mark', 'mark_anderson@msn.com', '18131221732', '$argon2id$v=19$m=65536,t=3,p=4$Q7EyIMttFPSuEPyH$nvnzXtsMM3JznnJAX7ebZ3CL7csGZaF3', 1),
(30, 'Sandra', 'Perez', 'sandra', 'sandra.perez29@comcast.net', '19411229651', '$argon2id$v=19$m=65536,t=3,p=4$1DDxp63OHm1FZuG2$96c0xPbX+neGBuzSm6A8cVR06AxYpThG', 1),
(31, 'Donald', 'Thomas', 'don', 'donald.thomas@verizon.net', '18501237570', '$argon2id$v=19$m=65536,t=3,p=4$JWZhbj11THnCMZCY$7Bvqiy8CsT07Lq8TDIWG2x9aJTFMP9+2', 1),
(32, 'Ashley', 'Thompson', 'ashley', 'ashleythompson@att.net', '17271245489', '$argon2id$v=19$m=65536,t=3,p=4$kUtMXhkPrSbbAjLG$msDx5StAZvlMz/Bk4opH1Dr8/h97s+F/', 1),
(33, 'Steven', 'Taylor', 'steven', 'staylor@sbcglobal.net', '19411253408', '$argon2id$v=19$m=65536,t=3,p=4$vauP7/L7V21jxUdc$fQm9+seB1qRmUR8AK3R2GgLLT/ZQISA/', 1),
(34, 'Dorothy', 'White', 'd0ot_33', 'dorothy_white@protonmail.com', '15611261327', '$argon2id$v=19$m=65536,t=3,p=4$pQyOMqlfZZgZMnaf$y8hWskBf6wmxe1mbVrNHMx1eOc3g/fp1', 1),
(35, 'Paul', 'Moore', 'paul', 'paul.moore34@gmx.com', '19541269246', '$argon2id$v=19$m=65536,t=3,p=4$Z5ibXt80nk8Btb2a$bplBpq8cJF5xgUskL/6GgebhbkXNNv+h', 1),
(36, 'Kimberly', 'Harris', 'kimberly', 'kimberly.harris@mail.com', '17861277165', '$argon2id$v=19$m=65536,t=3,p=4$OV48vsoUu19X5IQL$JhQbtN2FWXWD5KaPHI2ufKssJ/Sk+WzD', 1),
(37, 'Andrew', 'Jackson', 'andrew', 'andrewjackson@zoho.com', '13211285084', '$argon2id$v=19$m=65536,t=3,p=4$NhY7AGbX6lTiDYHP$9zyBylxLUTZtFf/VnV7ktOdSJcmeA+BH', 1),
(38, 'Emily', 'Sanchez', 'emily', 'esanchez@fastmail.com', '13521293003', '$argon2id$v=19$m=65536,t=3,p=4$J2m5qGeRzxWkdgeV$6+iYplGODlYx5uVECweGThdgH9hmsOaz', 1),
(39, 'Joshua', 'Martin', 'joshua', 'joshua_martin@earthlink.net', '13861300922', '$argon2id$v=19$m=65536,t=3,p=4$M4n8PVGXpV9Wv4Es$b7yeuCjVr5mXcj5RPD9oUsQChx5s4tI1', 1),
(40, 'Donna', 'Clark', 'donna', 'donna.clark39@juno.com', '12121308841', '$argon2id$v=19$m=65536,t=3,p=4$0FtdILQvH+nO69ot$hB9KpGzU3HEEmXL1uhLsc4Rr4aKxU3f0', 1);

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(41, 'Kenneth', 'Lee', 'kenneth', 'kenneth.lee@netzero.net', '13051316760', '$argon2id$v=19$m=65536,t=3,p=4$BJxrxDwzkl/JwAry$Nzbi0hSQK/lb09rIFxUeuVaT5jpTFPWh', 1),
(42, 'Michelle', 'Ramirez', 'michelle', 'michelleramirez@lycos.com', '14071324679', '$argon2id$v=19$m=65536,t=3,p=4$Ln/5drcFlCxvnNGd$cmyHc7E4nSmwfIp7/JoppZrDDs7YvcX1', 1),
(43, 'Kevin', 'Perez', 'kevin', 'kperez@gmail.com', '14151332598', '$argon2id$v=19$m=65536,t=3,p=4$eYgURZEQ3PZgPsTF$2bUnxiP3zcCr1Y6ffeIIemGpb3EfKoNS', 0),
(44, 'Carol', 'Lewis', 'carol', 'carol_lewis@yahoo.com', '15121340517', '$argon2id$v=19$m=65536,t=3,p=4$vphIk7s4pqL0KJFl$K6CXzU6M98NdFQCyXYbTuEPP+IKBLhcu', 1),
(45, 'Brian', 'Thompson', 'brian_55', 'brian.thompson44@hotmail.com', '16171348436', '$argon2id$v=19$m=65536,t=3,p=4$iS4hX4TnCt1RTrzJ$m8Iq0na0p/Yt1JoW56KTLTYXPa/W4MxM', 1),
(46, 'Amanda', 'Robinson', 'amanda', 'amanda.robinson@outlook.com', '17021356355', '$argon2id$v=19$m=65536,t=3,p=4$s3WDlQPFPA2bdgG/$MN33X7TfS5biDm0VZty1+Z4RlvUOUjNw', 1),
(47, 'George', 'White', 'george', 'georgewhite@icloud.com', '17181364274', '$argon2id$v=19$m=65536,t=3,p=4$oLR1uLAy0xhnTf0b$aNaMYmbdzw/Isz0psundmjv+73hbPsET', 1),
(48, 'Melissa', 'Walker', 'melissa', 'mwalker@aol.com', '13121372193', '$argon2id$v=19$m=65536,t=3,p=4$JveImiSy5XcgCYf4$gEFCfuwOa6M1G/iFXC0NZ+cFlwvTWxaL', 1),
(49, 'Timothy', 'Harris', 'tim', 'timothy_harris@live.com', '12131380112', '$argon2id$v=19$m=65536,t=3,p=4$YUoQXQZip2SFXy7K$SE3eJdRtEqlzIq47EuVTBZWAM8AD5qH4', 1),
(50, 'Deborah', 'Young', 'deborah', 'deborah.young49@msn.com', '14041388031', '$argon2id$v=19$m=65536,t=3,p=4$VFZBqplIXdsNbXlw$DPyniUMyiNlCKqZKTZ7qJwdUS0d7FZTm', 1),
(51, 'Ronald', 'Sanchez', 'ronald', 'ronald.sanchez@comcast.net', '12061395950', '$argon2id$v=19$m=65536,t=3,p=4$xLoICfZfu3zMtWfN$wD/G3SaoKfgFoeOASl1YCJlS24R5gA2q', 1),
(52, 'Stephanie', 'Allen', 'steph', 'stephanieallen@verizon.net', '12141403869', '$argon2id$v=19$m=65536,t=3,p=4$+yfHwuEHFhvTS0lz$Nrr+9EEa4rSMrsEQp2vt7ZAoLbU+AfhJ', 1),
(53, 'Edward', 'Clark', 'edward', 'eclark@att.net', '13031411788', '$argon2id$v=19$m=65536,t=3,p=4$MzoN5ouP47ULvjfb$7+kQHn+3+yPbTlKGFkrddYsLVxvnNPWx', 1),
(54, 'Rebecca', 'King', 'rebecca', 'rebecca_king@sbcglobal.net', '14801419707', '$argon2id$v=19$m=65536,t=3,p=4$TODVrVGEhfnZgB/2$/uMksDur4Zlf49yBVae2sKjh1Ri4bwvW', 1),
(55, 'Jason', 'Ramirez', 'jason', 'jason.ramirez54@protonmail.com', '16021427626', '$argon2id$v=19$m=65536,t=3,p=4$La4Sz8kP62tZkhQM$1V9rMRdyC5ksV1UE4YHoDxzoCGmyG+D6', 1),
(56, 'Sharon', 'Wright', '!!sharon!!', 'sharon.wright@gmx.com', '16461435545', '$argon2id$v=19$m=65536,t=3,p=4$Cok0j4ron6Yvy8lr$VhZEgVfbB6Mpr2lzoTvURbGpEVT+fTmT', 1),
(57, 'Jeffrey', 'Lewis', 'jeffrey', 'jeffreylewis@mail.com', '17731443464', '$argon2id$v=19$m=65536,t=3,p=4$PoeFGTy5c4oc+ojH$xtLWsGI4bdRt+9eejxY8u5YDjUQBNqfB', 1),
(58, 'Laura', 'Scott', 'laura', 'lscott@zoho.com', '18321451383', '$argon2id$v=19$m=65536,t=3,p=4$vU7Q7XTOaQ9QDcF6$fssIXIiHTremz2mUKEsjMRUFSZQhRP9V', 1),
(59, 'Ryan', 'Robinson', 'ryan', 'ryan_robinson@fastmail.com', '19041459302', '$argon2id$v=19$m=65536,t=3,p=4$FEStrAa6Z5YMvisM$NGRjykwMT7T2i+OwJGcvIEcBgZ5zKmzE', 0),
(60, 'Cynthia', 'Torres', 'cynthia', 'cynthia.torres59@earthlink.net', '16151467221', '$argon2id$v=19$m=65536,t=3,p=4$hqgkjRrayIbPdBPP$d+ZRwh1flQ/ZG7bdOOh1QulctAslTU2S', 1),
(61, 'Jacob', 'Walker', 'jacob', 'jacob.walker@juno.com', '19011475140', '$argon2id$v=19$m=65536,t=3,p=4$tQDH9eN6JUJqGb8m$UtDZldrphAxHUtwudSF4/BSX6BPdnbiZ', 1),
(62, 'Kathleen', 'Nguyen', 'kathleen', 'kathleennguyen@netzero.net', '12161483059', '$argon2id$v=19$m=65536,t=3,p=4$ShDW0WCdGcH3EDTA$P2JM/Bu9IrMKlQa+FuO5BgAUf4x3rMdo', 1),
(63, 'Gary', 'Young', 'gary', 'gyoung@lycos.com', '14121490978', '$argon2id$v=19$m=65536,t=3,p=4$tbrMtTmv7Yl1RYQe$EzberD3ncgOiop+r2awCsoT/jSBCjIwb', 1),
(64, 'Amy', 'Hill', 'amy', 'amy_hill@gmail.com', '15031498897', '$argon2id$v=19$m=65536,t=3,p=4$HIifzg0UIbPf6KQ0$IZ2O1XtXX0saEGWEzolegZP4O6a88RWE', 1),
(65, 'Nicholas', 'Allen', 'nicholas', 'nicholas.allen64@yahoo.com', '16191506816', '$argon2id$v=19$m=65536,t=3,p=4$WTiYIPjCHH8S9Csi$UAvUEwt6wfPWU2p0tGWnUTM5lJYL5o59', 1),
(66, 'Shirley', 'Flores', 'shirley', 'shirley.flores@hotmail.com', '12101514735', '$argon2id$v=19$m=65536,t=3,p=4$wtaqU+EVRWGczaHh$wNJPGEH4l/lzq2LVf4WUfL03GTEXqyVi', 0),
(67, 'Eric', 'King', 'xX_eric66_Xx', 'ericking@outlook.com', '14691522654', '$argon2id$v=19$m=65536,t=3,p=4$AQjk5WY1/dn77318$wi4Y+rbDzZfLQX6plCjbn/lB6hzQ9h1r', 1),
(68, 'Angela', 'Green', 'angela', 'agreen@icloud.com', '18131530573', '$argon2id$v=19$m=65536,t=3,p=4$0gsPQyaxJHlOXGMY$1gNMFW3GNzqgAV7+sURz6gObi0PeJC4L', 1),
(69, 'Jonathan', 'Wright', 'jonathan', 'jonathan_wright@aol.com', '19411538492', '$argon2id$v=19$m=65536,t=3,p=4$zA6Z4AAhx3pgrj/x$bv/CLBusAm7mzlg1CG42thrfu5LDOtNH', 1),
(70, 'Helen', 'Adams', 'helen', 'helen.adams69@live.com', '18501546411', '$argon2id$v=19$m=65536,t=3,p=4$PBtDYePWtLClz7tx$3QZoeTpAjL+Sc/lz+JMlzr8IDMemaSyt', 1),
(71, 'Stephen', 'Scott', 'stephen', 'stephen.scott@msn.com', '17271554330', '$argon2id$v=19$m=65536,t=3,p=4$MgwQS59FQUwoMi6m$ouY7eefm0q1TjVuUvlQa9MtHmnEot/Ip', 1),
(72, 'Anna', 'Nelson', 'anna', 'annanelson@comcast.net', '19411562249', '$argon2id$v=19$m=65536,t=3,p=4$P7FufGUzKZAqEEmb$ng+ADlvtHd2YoLpkBDFhFjRmfBwMRk7x', 1),
(73, 'Larry', 'Torres', 'larry', 'ltorres@verizon.net', '15611570168', '$argon2id$v=19$m=65536,t=3,p=4$bO00elFsvtSrAzCQ$ia9e/QiizgU0lSu//rHMg7v3XMoiGDEz', 1),
(74, 'Brenda', 'Baker', 'brenda', 'brenda_baker@att.net', '19541578087', '$argon2id$v=19$m=65536,t=3,p=4$6E/gYYRWZlDR2NaM$+co810M6sQBkTY7eLQlIx40EpBfWxXIQ', 2),
(75, 'Justin', 'Nguyen', 'justin', 'justin.nguyen74@sbcglobal.net', '17861586006', '$argon2id$v=19$m=65536,t=3,p=4$tUvCSYN/OyuYbawn$F6GTmWrG1jQ4ILUNWh//UchpW5Nt6eP9', 1);

-- Foreign-culture users Languages represented: Japanese, Chinese, Korean, Vietnamese, Hindi,
-- Arabic, Hebrew, Yiddish, Russian, German, French, Spanish, Irish, Nigerian, Polish. 
INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(76, '隼人', '佐藤', 'h0ayato_75', 'hayato.sato@protonmail.com', '13211593925', '$argon2id$v=19$m=65536,t=3,p=4$raIsyfYwJELd10kW$/UJPu/gSrzhuNvNgMXUxIN8zP4ZnHUYO', 1),
(77, 'Yuki', 'Tanaka', 'yuki', 'yukitanaka@gmx.com', '13521601844', '$argon2id$v=19$m=65536,t=3,p=4$X8IoA50uOftJ80jJ$YUYKpH5bfNTUHFim0oNvwpZYRZY/RSxs', 2),
(78, 'Wei', 'Chen', 'wei', 'wchen@mail.com', '13861609763', '$argon2id$v=19$m=65536,t=3,p=4$0KrBRi0iaE3ZBJqt$CEpKeWKqXJiIBCNmUkUcjpPBa6r5Jh5e', 1),
(79, 'Mei', 'Wang', 'mei', 'mei_wang@outlook.com', '12121617682', '$argon2id$v=19$m=65536,t=3,p=4$f7o9CLRQDBAKdCwd$I2ViJloZX0ChVQGj9r366yRyoZvKyjc4', 1),
(80, 'Jun', 'Li', 'jun', 'jun.li79@fastmail.com', '13051625601', '$argon2id$v=19$m=65536,t=3,p=4$zzHzLcciTA1bHTuO$TNnfwT1d6nRntU8+kRO8qnGXATGcyJ3X', 2),
(81, '李', '伟', 'li', 'li.wei@earthlink.net', '14071633520', '$argon2id$v=19$m=65536,t=3,p=4$u3rrboBWdbl7fAjP$R7+AaFATWnmqz464ig8vZE88sp/WiEDa', 1),
(82, 'Xiu', 'Huang', 'xiu', 'xiuhuang@live.com', '14151641439', '$argon2id$v=19$m=65536,t=3,p=4$YCeFmzae7gZECf0H$ft7c9nmxsuPnWajdkjgL6YaAdx6ApA2o', 1),
(83, '张', '丽', 'zhang', 'zli@netzero.net', '15121649358', '$argon2id$v=19$m=65536,t=3,p=4$lTmlEmlVJMNLs/Qy$akjfoBX60Akchdr3hxL4GrGMSdPWmu4u', 1),
(84, '민준', '김', 'minjun', 'minjun_kim@lycos.com', '16171657277', '$argon2id$v=19$m=65536,t=3,p=4$8PJFb0cRDTQaERku$neO2RUip6uBgF0lBBKbH3pw4vKYFRGdl', 1),
(85, 'Ji-woo', 'Park', 'xX_jiwoo84_Xx', 'jiwoo.park84@gmx.com', '17021665196', '$argon2id$v=19$m=65536,t=3,p=4$AHsiiYMjiibjUjso$/J5wmGMY0w4m6RPAdXCnASQJbyjluNHx', 1),
(86, 'Nguyễn', 'Văn An', 'nguyen', 'nguyen.vanan@yahoo.com', '17181673115', '$argon2id$v=19$m=65536,t=3,p=4$fs9mhXGlChiLbIqT$UwrVGVUvoFvKWdCyCXUE8HagmWVEKd84', 1),
(87, 'Trần', 'Thị Hoa', 'tran', 'tranthihoa@hotmail.com', '13121681034', '$argon2id$v=19$m=65536,t=3,p=4$+oo6+lZp+9wD24hp$yiIU48ERhjC9BWoh3hEvOBmk9H76qj5O', 1),
(88, 'Aarav', 'Sharma', 'aarav', 'asharma@fastmail.com', '12131688953', '$argon2id$v=19$m=65536,t=3,p=4$mAJUip89Gxbd8eD/$rUsXPfVxDc6k5BeK4ryMOziZdvbU9Di9', 1),
(89, 'Priya', 'Patel', 'priya', 'priya_patel@icloud.com', '14041696872', '$argon2id$v=19$m=65536,t=3,p=4$V+BBy8zN6ICPe0wR$0cVuEatH68XrHEpJ1trrPhvD2vk50GCt', 1),
(90, 'Rohan', 'Mehta', 'rohan', 'rohan.mehta89@aol.com', '12061704791', '$argon2id$v=19$m=65536,t=3,p=4$I0mg3ncLjKwr1jWM$o5F/Vy3jGWxGE0UGjh8BPb48Rx7PD3lA', 1),
(91, 'محمد', 'الفارسي', 'mohammed', 'mohammed.alfarsi@live.com', '12141712710', '$argon2id$v=19$m=65536,t=3,p=4$0ZrDVUW/UqCBIoer$Z1j86QTS3Ow9cuYVoLAFzVMGui6fzb0I', 2),
(92, 'Fatima', 'Hassan', 'fatima', 'fatimahassan@msn.com', '13031720629', '$argon2id$v=19$m=65536,t=3,p=4$diawkFawDwHEcdok$lzt8QjSOL19HQhkHuHligHqQR+sygt2X', 1),
(93, 'נועה', 'כהן', 'noa', 'ncohen@comcast.net', '14801728548', '$argon2id$v=19$m=65536,t=3,p=4$LcDNj8mity57Dl83$rbyBn6EH2QhdDdCLB6yxANHquhC7RNYO', 1),
(94, 'Itai', 'Levi', 'i0tai_93', 'itai_levi@verizon.net', '16021736467', '$argon2id$v=19$m=65536,t=3,p=4$NhOlLgPEtwF7dzPp$U8NjniX39iGC5O91V5Ogn6lJreqi7eMi', 1),
(95, 'משה', 'כץ', 'moishe', 'moishe.katz94@att.net', '16461744386', '$argon2id$v=19$m=65536,t=3,p=4$R3ksYmgeKrnjOu0v$EwX2RUpF6olHX8CxK7Yzqy+nRFdG8tPO', 1),
(96, 'Дмитрий', 'Иванов', 'dmitri', 'dmitri.ivanov@sbcglobal.net', '17731752305', '$argon2id$v=19$m=65536,t=3,p=4$wRy1haDSbGfePDOI$UMVTYWKoDb0FgvtNGPW3NrERhSwOrg6R', 1),
(97, 'Anastasia', 'Petrova', 'anastasia', 'anastasiapetrova@hotmail.com', '18321760224', '$argon2id$v=19$m=65536,t=3,p=4$87BRUFimpPddDVji$/gz7ZN9WN8OSNTni951bDAAUUpe73dq2', 1),
(98, 'Hans', 'Müller', 'hans', 'hmuller@gmx.com', '19041768143', '$argon2id$v=19$m=65536,t=3,p=4$lxLTmChCU3uWj1zP$MQx+bsWvxcoUghAcB7tBst4d2rHJD1B7', 1),
(99, 'Ingrid', 'Fischer', 'ingrid', 'ingrid_fischer@mail.com', '16151776062', '$argon2id$v=19$m=65536,t=3,p=4$glaRvEGDwDwzo7BI$2g+a4li1sO6vBR0FzDu0T3MNuB5ksyOp', 0),
(100, 'André', 'Dubois', 'andre', 'andre.dubois99@aol.com', '19011783981', '$argon2id$v=19$m=65536,t=3,p=4$Lx194+8J8z8svDjT$XiZmT2QTYt7af9TZ3MuasUZPCRuZxKor', 1),
(101, 'José', 'Muñoz', 'jose', 'jose.munoz@fastmail.com', '12161791900', '$argon2id$v=19$m=65536,t=3,p=4$dP94/JUcSP9oQGXH$cVXiUbJQK/uWcjyAhrsNDCh3Hpnslt3y', 1),
(102, 'Siobhán', 'O''Brien', 'siobhan', 'siobhanobrien@earthlink.net', '14121799819', '$argon2id$v=19$m=65536,t=3,p=4$f/X2lwqMekhupecP$vo7unxzTzUp3PY0G5D9dwvxtSh5e4b54', 1),
(103, 'Chinedu', 'Okafor', 'xX_chinedu102_Xx', 'cokafor@juno.com', '15031807738', '$argon2id$v=19$m=65536,t=3,p=4$cRYsgs/wXuaaU1yW$0Q9uOWyIBaPOHRu+Jk+ft2k1L2alrnWJ', 1),
(104, 'Katarzyna', 'Kowalska', 'katarzyna', 'katarzyna_kowalska@netzero.net', '16191815657', '$argon2id$v=19$m=65536,t=3,p=4$o34Gk5Vme/MBiHJV$A2J6OZ8pfsLgqTWFHe49dlkeB78kLRxr', 2);

--  edge-case users
-- Split into one INSERT per row on purpose: with 'mysql --force' an error on one row now only aborts that single statement
INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(105, 'Amelia', 'Stone', 'amelia.stone', 'amelia.stone@gmail.com', '14158127100', '$argon2id$v=19$m=65536,t=3,p=4$pxHRvuC8CGHhCuMi$X4Bm18OhXD79zHupOZvr88/IVm/QuRmV', 1);  -- dup-email-case A

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(107, 'Omar', 'Delacroix-Reyes', 'omar.d', 'omar.delacroix@outlook.com', '(407) 555-0199', '$argon2id$v=19$m=65536,t=3,p=4$Wor/KQXwOdOA6pK6$VU9zwUyyMLFi1bAjApEoKmyaIg2lJOb1', 1);  -- dup-phone-format A

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(108, 'Farid', 'Boone', 'farid.boone', 'farid.boone@zoho.com', '+1-407-555-0199', '$argon2id$v=19$m=65536,t=3,p=4$SxbzwCnApIPXZdi2$oIs2Ucdg2XuVUrTVGsuuttopuNm/07bh', 1);  -- dup-phone-format B (same number as above)

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(109, '  Grace', 'Holloway  ', ' gws', ' grace.holloway@yahoo.com ', '16178142938', '$argon2id$v=19$m=65536,t=3,p=4$E2rEaETEl9X2Q8fC$g5EexziHkQlRk2Nj5FtwN3Pn2vf/puhK', 1);  -- whitespace in name/username/email

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(110, 'Bo', 'Xu', 'bo.xu', 'bo.xu@qq.com', '17028150857', '$argon2id$v=19$m=65536,t=3,p=4$fQgnyZvDA3H6lE7a$CYmz0lKUQFIQCeZ13itkjhyHmW+Gym/5', 1);  -- very short name

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(111, 'Al', 'O', 'al.o', 'al.o@gmail.com', '17188158776', '$argon2id$v=19$m=65536,t=3,p=4$Li8qsi93qdxfjoPE$gCISvU0Ju44waql3EtHooWlCatfTkNO4', 1);  -- very short name (1-char surname)

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(112, 'Bartholomew', 'Montgomery-Fitzgerald-Worthington-Ashcroft-Pemberton-Radcliffe-Beaumont-Thornbury-Winterbourne-Castellane-Hollingsworth-Abernathy-Featherstonehaugh-Ravensworth-Chetwynd-Devereux-Montgomery-Fitzgerald-Worthington-Ashcroft-Pemberton-Radcliffe-Beaumont-', 'bartholomew.long', 'bartholomew.long@protonmail.com', '13128166695', '$argon2id$v=19$m=65536,t=3,p=4$zNA9RqVTCJqc13xf$LJp5V8FWLLZeG9PB5TN6UlUAD3GUcIhR', 1);  -- long lastName, 250 chars (limit 255)

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(113, 'Declan', 'O''Connor', 'declan.oconnor', 'declan.oconnor@aol.com', '12138174614', '$argon2id$v=19$m=65536,t=3,p=4$U0e3NDRR8nx+nVzI$+fqR14K1tOtxuTJhFQewg22ytVpoI4YG', 1);  -- apostrophe surname

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(114, 'Ava', 'Smith-Jones', 'ava.smithjones', 'ava.smith-jones@icloud.com', '14048182533', '$argon2id$v=19$m=65536,t=3,p=4$cYXxWbVoPQqeyAcD$LmzED8PpePl6pEB4N1UbDoQZE2FQEWeM', 1);  -- hyphenated surname

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(115, 'Freya', 'Andersen', 'freya.andersen', 'freya.andersen@gmx.com', '+44 20 7946 0958', '$argon2id$v=19$m=65536,t=3,p=4$I897bgW7Dw8XunH4$lN7BaillxVa306LSVvm/oVLACXTQJKkV', 1);  -- international phone, raw UK format

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(116, 'Arjun', 'Rao', 'arjun.rao', 'arjun.rao@rediffmail.com', '+91 98765 43210', '$argon2id$v=19$m=65536,t=3,p=4$oUPrQoRu1cUCZauz$5UZHDw6vVhdWCPZf/8zwiwxHrvOLr9or', 1);  -- international phone, raw India format

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(117, 'Lin', 'Fang', 'lin.fang', 'lin.fang@163.com', '+86 138 0013 8000', '$argon2id$v=19$m=65536,t=3,p=4$JNMzC4OqU/5vhnke$sIiwccD4l6ExzORdqRVijcpguLJMlA4J', 1);  -- international phone, raw China format

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(118, 'Isla', 'Brennan', 'isla.brennan', 'isla.brennan@fastmail.com', NULL, '$argon2id$v=19$m=65536,t=3,p=4$ahKDNl9sW7W6zCJI$FrNYfCmB4V7S+dTZAuS/Zut2x8AzFTmH', 1);  -- NULL phone number

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(119, 'Tobias', 'Kern', 'tobias.kern', 'tobias.kern@web.de', '', '$argon2id$v=19$m=65536,t=3,p=4$JSp9KWBO3aMGrqvL$m3733ymt0wtOC3XJtmxyu8y4+mcz4en3', 1);  -- empty-string phone number

INSERT INTO `Users` (`id`, `firstName`, `lastName`, `userName`, `email`, `phoneNumber`, `password`, `role`) VALUES
(120, 'Trinity', 'Vance', 'xX_Tr1n1ty_Xx99', 'trinity.vance@lycos.com', '12068190452', '$argon2id$v=19$m=65536,t=3,p=4$Zj8pQ0nR2vLxK7mS$Ft6HqRxKtL3pXpZ8mBWtQ0Yd/NaK9V6c', 1);  -- strange username + extra-obscure password chars

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



COMMIT;
SET FOREIGN_KEY_CHECKS = 1;
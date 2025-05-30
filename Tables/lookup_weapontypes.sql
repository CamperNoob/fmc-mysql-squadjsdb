CREATE TABLE `lookup_weapontypes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `weaponName` varchar(255) DEFAULT NULL,
  `weaponIcon` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `weaponName` (`weaponName`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
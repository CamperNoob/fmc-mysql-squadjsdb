CREATE TABLE `lookup_vehicletypes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vehicleName` varchar(255) DEFAULT NULL,
  `vehicleIcon` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `vehicleName` (`vehicleName`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

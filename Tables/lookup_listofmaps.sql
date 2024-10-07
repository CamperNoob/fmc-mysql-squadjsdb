CREATE TABLE `lookup_listofmaps` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mapName` varchar(255) DEFAULT NULL,
  `isActive` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mapName` (`mapName`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into from `lookup_listofmaps` (mapName)
values
('Harju'),
('Skorpo'),
('Belaya'),
('BlackCoast'),
('FoolsRoad'),
('Gorodok'),
('Mestia'),
('Narva'),
('Yehorivka'),
('Chora'),
('Kamdesh'),
('Kohat'),
('Kokan'),
('Lashkar'),
('Logar'),
('Sumari'),
('Sanxian'),
('AlBasrah'),
('Anvil'),
('Fallujah'),
('Mutaha'),
('Tallil'),
('Manicouagan'),
('GooseBay'),
('PacificProvingGrounds');
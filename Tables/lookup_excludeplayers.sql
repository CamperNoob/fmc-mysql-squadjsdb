CREATE TABLE `lookup_excludeplayers` (
  `playerid` int NOT NULL,
  PRIMARY KEY (`playerid`),
  CONSTRAINT `lookup_excludeplayers_id` FOREIGN KEY (`playerid`) REFERENCES `dblog_players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
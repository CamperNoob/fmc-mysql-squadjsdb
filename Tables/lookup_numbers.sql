CREATE TABLE `lookup_numbers` (
  `number` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE PROCEDURE `sp_lookup_numbers_fill`()
BEGIN
  DECLARE num INT DEFAULT 1;
  WHILE num <= 100000 DO
    INSERT INTO `lookup_numbers`(number)
    SELECT num;
    SET num = num + 1;
  END WHILE;
END;

CALL `sp_lookup_numbers_fill`();

DROP PROCEDURE IF EXISTS `sp_lookup_numbers_fill`;
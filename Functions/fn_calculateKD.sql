DROP FUNCTION IF EXISTS `fn_calculateKD`;
CREATE FUNCTION `fn_calculateKD`(kills int, deaths int) RETURNS float
    DETERMINISTIC
begin
	declare result float;
    IF kills = 0 THEN
		SET result = 0;
    ELSEIF deaths = 0 THEN
		SET result = kills;
    ELSE
      SET result = kills/deaths;
    END IF;
	return result;
end
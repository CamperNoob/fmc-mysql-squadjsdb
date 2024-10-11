drop trigger if exists `squadjs`.`trigger_dblogmatchesunignorelegit`;
create trigger `squadjs`.`trigger_dblogmatchesunignorelegit`
before update on `dblog_matches`
for each ROW
BEGIN
    IF (NEW.`ignore` = 1 
    --and NEW.winner is not null 
    and timestampdiff(minute, NEW.startTime, NEW.endTime) >= 15 and NEW.layerClassName not like '%_Seed%')
	    THEN SET NEW.`ignore` = 0;
    END IF;
END
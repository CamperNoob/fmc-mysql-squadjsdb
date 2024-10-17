drop trigger if exists `squadjs`.`trigger_dblogmatchesignore`;
create trigger `squadjs`.`trigger_dblogmatchesignore`
before insert on `dblog_matches`
for each ROW
BEGIN
	IF (NEW.endTime is null)
		THEN SET NEW.ignore = 1;
	END IF;
END
drop trigger if exists `squadjs`.`trigger_dblogmatchesignore`;
create trigger `squadjs`.`trigger_dblogmatchesignore`
before insert on `dblog_matches`
for each ROW
BEGIN
	IF (NEW.endTime is null)
		THEN SET NEW.ignore = 1;
	END IF;
	IF (NEW.displayName is null)
		THEN SET NEW.displayName = DATE_FORMAT(date_add(NEW.StartTime, interval 3 hour), '%Y-%m-%d %H:%i');
	END IF;
END
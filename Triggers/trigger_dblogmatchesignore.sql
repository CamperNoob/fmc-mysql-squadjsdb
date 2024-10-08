drop trigger if exists `squadjs`.`trigger_dblogmatchesignore`;
create trigger `squadjs`.`trigger_dblogmatchesignore`
before insert on `dblog_matches`
for each ROW
BEGIN
	SET NEW.ignore = 1;
END
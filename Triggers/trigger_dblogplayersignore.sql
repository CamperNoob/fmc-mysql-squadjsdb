drop trigger if exists `squadjs`.`trigger_dblogplayersignore`;
create trigger `squadjs`.`trigger_dblogplayersignore`
before insert on `dblog_players`
for each ROW
BEGIN
	SET NEW.ignore = 1;
END
drop trigger if exists `squadjs`.`trigger_dblogplayersignore`;
create trigger `squadjs`.`trigger_dblogplayersignore`
after insert on `dblog_players`
for each ROW
BEGIN
	insert into lookup_excludeplayers (playerId)
	values (NEW.id);
END
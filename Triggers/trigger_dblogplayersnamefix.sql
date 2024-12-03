drop trigger if exists `squadjs`.`trigger_dblogplayersnamefixinsert`;
create trigger `squadjs`.`trigger_dblogplayersnamefixinsert`
before insert on `dblog_players`
for each ROW
BEGIN
	IF (NEW.lastName like "%'%")
		THEN SET NEW.lastName = replace(NEW.lastName, "'", "");
	END IF;
END;

drop trigger if exists `squadjs`.`trigger_dblogplayersnamefixupdate`;
create trigger `squadjs`.`trigger_dblogplayersnamefixupdate`
before update on `dblog_players`
for each ROW
BEGIN
	IF (NEW.lastName like "%'%")
		THEN SET NEW.lastName = replace(NEW.lastName, "'", "");
	END IF;
END;
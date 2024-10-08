drop trigger if exists `squadjs`.`trigger_updateactivemaps`;
create trigger `squadjs`.`trigger_updateactivemaps`
after insert on `dblog_matches`
for each ROW
BEGIN
	IF NOT EXISTS (
		select 1 from lookup_listofmaps
		where concat('%',lookup_listofmaps.mapName,'%') like NEW.layerClassName and lookup_listofmaps.isActive = 1 and NEW.layerClassName not like '%_Seed%'
	) THEN
		CALL `squadjs`.`sp_updateactivemaps`();
	END IF;
END
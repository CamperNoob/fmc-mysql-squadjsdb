DROP PROCEDURE IF EXISTS `squadjs`.`sp_updateactivemaps`;
CREATE PROCEDURE `squadjs`.`sp_updateactivemaps` ()
begin
	drop temporary table if exists `listofactivemaps`;
	create temporary table `listofactivemaps` (id int);

	insert into `listofactivemaps` (id)
	select distinct a.id from `squadjs`.`lookup_listofmaps` as a
	inner join `squadjs`.`dblog_matches` as b on b.layerClassName like concat('%', a.mapName, '%') and b.layerClassName not like '%_Seed%';

	update `squadjs`.`lookup_listofmaps`
	set isActive = 0;

	update `squadjs`.`lookup_listofmaps`
	set isActive = 1
	where id in (select id from listofactivemaps);

	drop temporary table if exists `listofactivemaps`;
end
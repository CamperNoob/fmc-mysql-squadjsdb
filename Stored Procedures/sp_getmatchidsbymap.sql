drop procedure if exists `sp_getmatchidsbymap`;
create procedure `sp_getmatchidsbymap` (mapNameJson TEXT)
begin
	drop temporary table if exists `getmatchidsbymap`;
	drop temporary table if exists `getmatchidsbymap_maplist`;
	create temporary table `getmatchidsbymap` (matchId int);
	create temporary table `getmatchidsbymap_maplist` (searchName varchar(255));

	insert into getmatchidsbymap_maplist (searchName)
	select value
	from JSON_TABLE(mapNameJson, '$[*]' columns(value varchar(255) path '$')) as jt;

	update getmatchidsbymap_maplist
	set searchName = concat('%', searchName, '%');

	insert into getmatchidsbymap (matchID)
	select distinct a.id
	from dblog_matches as a
	right join getmatchidsbymap_maplist as b on a.layerClassname like b.searchName and a.ignore = 0;
	drop temporary table if exists `getmatchidsbymap_maplist`;
end
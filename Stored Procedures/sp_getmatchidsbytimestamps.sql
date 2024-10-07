drop procedure if exists `sp_getmatchidsbytimestamps`;
create procedure `sp_getmatchidsbytimestamps` (timestampsJson TEXT)
begin
	drop temporary table if exists `getmatchidsbytimestamps`;
	drop temporary table if exists `getmatchidsbymap_timestampList`;
	create temporary table `getmatchidsbymap` (matchId int);
	create temporary table `getmatchidsbymap_timestampList` (searchTime datetime);

	insert into getmatchidsbymap_timestampList (searchTime)
	select STR_TO_DATE(value, '%Y-%m-%d %H:%i') as `searchTime`
	from JSON_TABLE(mapNameJson, '$[*]' columns(value varchar(255) path '$')) as jt;

	insert into getmatchidsbymap (matchID)
	select distinct a.id
	from dblog_matches as a
	right join getmatchidsbymap_timestampList as b on a.startTime between date_add(b.searchTime, interval -1 minute) and date_add(b.searchTime, interval 1 minute);
	drop temporary table if exists `getmatchidsbymap_timestampList`;
end
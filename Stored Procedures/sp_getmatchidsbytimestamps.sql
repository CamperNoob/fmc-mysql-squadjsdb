drop procedure if exists `sp_getmatchidsbytimestamps`;
create procedure `sp_getmatchidsbytimestamps` (timestampsJson TEXT)
begin
	drop temporary table if exists `getmatchidsbytimestamps`;
	drop temporary table if exists `getmatchidsbytimestamps_timestampList`;
	create temporary table `getmatchidsbytimestamps` (matchId int);
	create temporary table `getmatchidsbytimestamps_timestampList` (searchTime datetime);

	insert into getmatchidsbytimestamps_timestampList (searchTime)
	select STR_TO_DATE(value, '%Y-%m-%d %H:%i') as `searchTime`
	from JSON_TABLE(timestampsJson, '$[*]' columns(value varchar(255) path '$')) as jt;

	insert into getmatchidsbytimestamps (matchID)
	select distinct a.id
	from dblog_matches as a
	right join getmatchidsbytimestamps_timestampList as b on a.startTime between date_add(date_add(b.searchTime, interval -3 hour), interval -1 minute) and date_add(date_add(b.searchTime, interval -3 hour), interval 1 minute);
	drop temporary table if exists `getmatchidsbytimestamps_timestampList`;
end
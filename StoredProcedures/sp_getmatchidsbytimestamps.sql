drop procedure if exists `sp_getmatchidsbytimestamps`;
create procedure `sp_getmatchidsbytimestamps` (timestampsJson TEXT)
begin
	drop temporary table if exists `getmatchidsbytimestamps`;
	drop temporary table if exists `getmatchidsbytimestamps_timestampList`;
	create temporary table `getmatchidsbytimestamps` (matchId int);
	--create temporary table `getmatchidsbytimestamps_timestampList` (searchTime datetime);
	create temporary table `getmatchidsbytimestamps_timestampList` (displayName varchar(255));

	--insert into getmatchidsbytimestamps_timestampList (searchTime)
	insert into getmatchidsbytimestamps_timestampList (displayName)
	--select STR_TO_DATE(value, '%Y-%m-%d %H:%i') as `searchTime`
	select value as `displayName`
	from JSON_TABLE(timestampsJson, '$[*]' columns(value varchar(255) path '$')) as jt;

	insert into getmatchidsbytimestamps (matchID)
	select distinct a.id
	from dblog_matches as a
	right join getmatchidsbytimestamps_timestampList as b 
	--on a.startTime between date_add(date_add(b.searchTime, interval -3 hour), interval -1 minute) and date_add(date_add(b.searchTime, interval -3 hour), interval 1 minute) 
	on a.displayName = b.displayName
		and a.ignore = 0;
	drop temporary table if exists `getmatchidsbytimestamps_timestampList`;
end 
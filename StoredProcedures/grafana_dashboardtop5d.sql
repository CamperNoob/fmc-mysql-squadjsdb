drop procedure if exists `grafana_dashboardtop5d`;
--create procedure `grafana_dashboardtop5d`(lastVar int, lastTypeVar varchar(255), layerVar TEXT, serverVar TEXT, matchTimestamps TEXT)
create procedure `grafana_dashboardtop5d`(fromVar varchar(255), toVar varchar(255), layerVar TEXT, serverVar TEXT, matchTimestamps TEXT)
begin 
--	call sp_getstatsbytime(fn_getdatetimefromrange(lastVar,lastTypeVar,now()),now());
	call sp_getstatsbytime(str_to_date(left(fromVar, 19),'%Y-%m-%dT%H:%i:%s'),str_to_date(left(toVar, 19),'%Y-%m-%dT%H:%i:%s'));
	call sp_getmatchidsbymap(layerVar);
	call sp_serveridsfromnamesjson(serverVar);
	call sp_getmatchidsbytimestamps(matchTimestamps);
	select playerName as Nickname, sum(deaths) as `Deaths`
	from getstatsbytime 
	where serverID in (select serverID from serveridsfromnamesjson) 
		and matchId in (select matchId from getmatchidsbymap) 
		and matchId in (select matchId from getmatchidsbytimestamps)
	group by playerName, steamId
	order by sum(Deaths) desc, sum(Kills) asc, sum(Wounds) asc, sum(Revives) asc, playerName asc
	limit 5;
	drop temporary table if exists getstatsbytime;
	drop temporary table if exists getmatchidsbymap;
	drop temporary table if exists serveridsfromnamesjson;
	drop temporary table if exists getmatchidsbytimestamps;
end
drop procedure if exists `grafana_dashboardtop5d`;
create procedure `grafana_dashboardtop5d`(lastVar int, lastTypeVar varchar(255), layerVar TEXT, serverVar TEXT)
begin 
	call sp_getstatsbytime(fn_getdatetimefromrange(lastVar,lastTypeVar,now()),now());
	call sp_getmatchidsbymap(layerVar);
	call sp_serveridsfromnamesjson(serverVar);
	select playerName as Nickname, sum(deaths) as `Deaths`
	from getstatsbytime 
	where serverID in (select serverID from serveridsfromnamesjson) 
		and matchId in (select matchId from getmatchidsbymap) 
	group by playerName, steamId
	order by sum(Deaths) desc
	limit 5;
	drop temporary table if exists getstatsbytime;
	drop temporary table if exists getmatchidsbymap;
	drop temporary table if exists serveridsfromnamesjson;
end
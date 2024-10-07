drop procedure if exists `grafana_dashboardkd`;
create procedure `grafana_dashboardkd`(lastVar int, lastTypeVar varchar(255), layerVar TEXT, nicknameVar TEXT, serverVar TEXT)
begin 
	call sp_getstatsbytime(fn_getdatetimefromrange(lastVar,lastTypeVar,now()),now());
	call sp_getmatchidsbymap(layerVar);
	call sp_steamidlistfromnamesjson(nicknameVar);
	call sp_serveridsfromnamesjson(serverVar);
	select playerName as Nickname, steamId as SteamID, sum(revives) as Revives, sum(wounds) as Wounds, sum(kills) as Kills, sum(deaths) as Deaths, fn_calculateKD(sum(kills), sum(deaths)) as `Kill\Deaths`, fn_calculateKD(sum(revives), sum(deaths)) as `Revive\Deaths`
	from getstatsbytime 
	where serverID in (select serverID from serveridsfromnamesjson) 
		and matchId in (select matchId from getmatchidsbymap) 
		and steamId in (select steamID from steamidlistfromnamesjson)
	group by playerName, steamId;
	drop temporary table if exists getstatsbytime;
	drop temporary table if exists getmatchidsbymap;
	drop temporary table if exists steamidlistfromnamesjson;
	drop temporary table if exists serveridsfromnamesjson;
end
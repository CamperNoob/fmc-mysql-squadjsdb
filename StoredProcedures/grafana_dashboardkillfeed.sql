drop procedure if exists `grafana_dashboardkillfeed`;
create procedure `grafana_dashboardkillfeed`(matchDisplayName TEXT, nicknameVar TEXT)
begin 
	call sp_getmatchkillfeed(matchDisplayName);
	call sp_steamidlistfromnamesjson(nicknameVar);

	with result as (
		select distinct a.html, `time`, id
		from getmatchkillfeed as a
		join steamidlistfromnamesjson as b on (a.attackerSteamID = b.steamID or a.victimSteamID = b.steamID)
	)
	select html as Feed
	from result
	order by `time`, id desc;

	drop temporary table if exists getmatchkillfeed;
	drop temporary table if exists steamidlistfromnamesjson;
end
drop procedure if exists `sp_getstatsbytime`;
create procedure `sp_getstatsbytime` (startDate datetime, endDate datetime)
begin
	drop temporary table if exists getstatsbytime;
	create TEMPORARY table getstatsbytime
	(
		playerName varchar(255),
		steamId varchar(255),
		kills int,
		deaths int,
		wounds int,
		revives int,
		serverId int,
		matchId int,
		serverName varchar(255),
		matchTime datetime,
		matchLayer varchar(255),
		primary key (serverId, matchId, steamId)
	);

	insert into getstatsbytime (steamID, kills, serverID, matchID)
	select attacker as steamID, count(victim) as kills, server as serverID, `match` as matchID
	from dblog_deaths
	where teamkill = 0 and attacker != "00000000000000000" and attacker != victim and attacker not in (select a.steamId from dblog_players as a where a.ignore = 1)
		and `server` is not null and `match` is not null and attacker is not null
		and time between startDate and endDate
	group by server, `match`, attacker;

	insert into getstatsbytime (steamID, deaths, serverID, matchID)
	select victim as steamID, count(attacker) as deaths, server as serverID, `match` as matchID
	from dblog_deaths
	where victim != "00000000000000000" and `server` is not null and `match` is not null and victim is not null and victim not in (select a.steamId from dblog_players as a where a.ignore = 1)
		and time between startDate and endDate
	group by server, `match`, victim
	on duplicate key update deaths = values(deaths);


	insert into getstatsbytime (steamID, wounds, serverID, matchID)
	select attacker as steamID, count(victim) as wounds, server as serverID, `match` as matchID
	from dblog_wounds
	where teamkill = 0 and attacker != "00000000000000000" and attacker != victim
		and `server` is not null and `match` is not null and attacker is not null and attacker not in (select a.steamId from dblog_players as a where a.ignore = 1)
		and time between startDate and endDate
	group by server, `match`, attacker
	on duplicate key update wounds = values(wounds);

	insert into getstatsbytime (steamID, revives, serverID, matchID)
	select reviver as steamID, count(victim) as revives, server as serverID, `match` as matchID
	from dblog_revives
	where reviver != "00000000000000000"  and reviver != victim and reviver not in (select a.steamId from dblog_players as a where a.ignore = 1)
		and `server` is not null and `match` is not null and reviver is not null
		and time between startDate and endDate
	group by server, `match`, reviver
	on duplicate key update revives = values(revives);

	update getstatsbytime
	set playerName = fn_getnamefromsteamid(steamID);

	update getstatsbytime as a
	left join dblog_servers as b on a.serverId = b.id
	set a.serverName = b.name;

	update getstatsbytime as a
	left join dblog_matches as b on a.matchId = b.id
	set a.matchTime = b.startTime, a.matchLayer = b.layerClassname;

	update getstatsbytime
	set kills = 0
	where kills is null;

	update getstatsbytime
	set deaths = 0
	where deaths is null;

	update getstatsbytime
	set wounds = 0
	where wounds is null;

	update getstatsbytime
	set wounds = kills
	where wounds < kills;

	update getstatsbytime
	set revives = 0
	where revives is null;

	delete from getstatsbytime
	where matchTime not between startDate and endDate;
end
DROP PROCEDURE IF EXISTS `sp_addKDWR`;
CREATE PROCEDURE `sp_addKDWR` (matchID int, steamIDnew char(255), revivesNew int, woundsNew int, killsNew int, deathsNew int)
BEGIN
	DECLARE maxIdRevives INT DEFAULT 0;
    DECLARE maxIdDeaths INT DEFAULT 0;
    DECLARE maxIdWounds INT DEFAULT 0;
    DECLARE matchTimestamp DATETIME;

	SELECT MAX(id) INTO maxIdRevives FROM dblog_revives;
    SELECT MAX(id) INTO maxIdDeaths FROM dblog_deaths;
    SELECT MAX(id) INTO maxIdWounds FROM dblog_wounds;
    SELECT startTime INTO matchTimestamp FROM dblog_matches WHERE id = matchID;
	
	-- DEATHS AND KILLS
	drop temporary table if exists deathRows;
	create temporary table deathRows (
		`time` datetime, woundTime datetime, victimName varchar(255), victimTeamID int, victimSquadID int, attackerName varchar(255), attackerTeamID int, attackerSquadID int, damage float, weapon varchar(255)
		, teamkill int, `server` int, attacker varchar(255), victim varchar(255), `match` int);

	if killsNew > 0 then
		insert into deathRows (`time`, woundTime, victimName, victimTeamID, victimSquadID, attackerName, attackerTeamID, attackerSquadID, damage, weapon, teamkill, `server`, attacker, victim, `match`)
		select matchTimestamp as `time`, matchTimestamp as woundTime
			, fn_getnamefromsteamid("00000000000000000") as victimName, 1 as victimTeamID, 1 as victimSquadID
			, fn_getnamefromsteamid(steamIDnew) as attackerName, 2 as attackerTeamID, 1 as attackerSquadID
			, 100.0 as damage, "unknown_weapon" as weapon, 0 as teamkill, 10 as `server`
			, steamIDnew as attacker, "00000000000000000" as victim, matchID as `match`
		from lookup_numbers
		where number between 1 and killsNew;
	end if;

	if deathsNew > 0 then
		insert into deathRows (`time`, woundTime, victimName, victimTeamID, victimSquadID, attackerName, attackerTeamID, attackerSquadID, damage, weapon, teamkill, `server`, attacker, victim, `match`)
		select matchTimestamp as `time`, matchTimestamp as woundTime
			, fn_getnamefromsteamid(steamIDnew) as victimName, 2 as victimTeamID, 1 as victimSquadID
			, fn_getnamefromsteamid("00000000000000000") as attackerName, 1 as attackerTeamID, 1 as attackerSquadID
			, 100.0 as damage, "unknown_weapon" as weapon, 0 as teamkill, 10 as `server`
			, "00000000000000000" as attacker, steamIDnew as victim, matchID as `match`
		from lookup_numbers
		where number between 1 and deathsNew;
	end if;

	insert into dblog_deaths (id, `time`, woundTime, victimName, victimTeamID, victimSquadID, attackerName, attackerTeamID, attackerSquadID, damage, weapon, teamkill, `server`, attacker, victim, `match`)
	select maxIdDeaths + row_number() over w as id, `time`, woundTime, victimName, victimTeamID, victimSquadID, attackerName, attackerTeamID, attackerSquadID, damage, weapon, teamkill, `server`, attacker, victim, `match`
	from deathRows
	window w as (order by victimName);

	drop temporary table if exists deathRows;

	-- WOUNDS (KNOCKS)
	drop temporary table if exists woundRows;
	create temporary table woundRows (
		`time` datetime, victimName varchar(255), victimTeamID int, victimSquadID int, attackerName varchar(255), attackerTeamID int, attackerSquadID int, damage float, weapon varchar(255)
		, teamkill int, `server` int, attacker varchar(255), victim varchar(255), `match` int);

	if woundsNew > 0 then
		insert into woundRows (`time`, victimName, victimTeamID, victimSquadID, attackerName, attackerTeamID, attackerSquadID, damage, weapon, teamkill, `server`, attacker, victim, `match`)
		select matchTimestamp as `time`
			, fn_getnamefromsteamid("00000000000000000") as victimName, 1 as victimTeamID, 1 as victimSquadID
			, fn_getnamefromsteamid(steamIDnew) as attackerName, 2 as attackerTeamID, 1 as attackerSquadID
			, 100.0 as damage, "unknown_weapon" as weapon, 0 as teamkill, 10 as `server`
			, steamIDnew as attacker, "00000000000000000" as victim, matchID as `match`
		from lookup_numbers
		where number between 1 and woundsNew;
	end if;

	insert into dblog_wounds (id, `time`, victimName, victimTeamID, victimSquadID, attackerName, attackerTeamID, attackerSquadID, damage, weapon, teamkill, `server`, attacker, victim, `match`)
	select maxIdWounds + row_number() over w as id, `time`, victimName, victimTeamID, victimSquadID, attackerName, attackerTeamID, attackerSquadID, damage, weapon, teamkill, `server`, attacker, victim, `match`
	from woundRows
	window w as (order by victimName);

	drop temporary table if exists woundRows;

	-- REVIVES
	drop temporary table if exists reviveRows;
	create temporary table reviveRows (
		`time` datetime, woundTime datetime, victimName varchar(255), victimTeamID int, victimSquadID int, attackerName varchar(255), attackerTeamID int, attackerSquadID int, damage float, weapon varchar(255)
		, teamkill int, reviverName varchar(255), reviverTeamID int, reviverSquadID int, `server` int, attacker varchar(255), victim varchar(255), reviver varchar(255), `match` int);

	if revivesNew > 0 then
		insert into reviveRows (`time`, woundTime, victimName, victimTeamID, victimSquadID, attackerName, attackerTeamID, attackerSquadID, damage, weapon, teamkill, reviverName, reviverTeamID, reviverSquadID, `server`, attacker, victim, reviver, `match`)
		select matchTimestamp as time, null as woundTime
			, fn_getnamefromsteamid("00000000000000000") as victimName, 2 as victimTeamID, 1 as victimSquadID
			, null as attackerName, null attackerTeamID, null attackerSquadID, null as damage, null as weapon, null as teamkill
			, fn_getnamefromsteamid(steamIDnew) as reviverName, 2 as reviverTeamID, 1 as reviverSquadID
			, 10 as `server`, null as attacker, "00000000000000000" as victim, steamIDnew as reviver, matchID as `match`
		from lookup_numbers
		where number between 1 and revivesNew;
	end if;

	insert into dblog_revives (id, `time`, woundTime, victimName, victimTeamID, victimSquadID, attackerName, attackerTeamID, attackerSquadID, damage, weapon, teamkill, reviverName, reviverTeamID, reviverSquadID, `server`, attacker, victim, reviver, `match`)
	select maxIdRevives + row_number() over w as id, `time`, woundTime, victimName, victimTeamID, victimSquadID, attackerName, attackerTeamID, attackerSquadID, damage, weapon, teamkill, reviverName, reviverTeamID, reviverSquadID, `server`, attacker, victim, reviver, `match`
	from reviveRows
	window w as (order by victimName);

	drop temporary table if exists reviveRows;

END;

drop procedure if exists `sp_getmatchkillfeed`;
create procedure `sp_getmatchkillfeed` (matchDisplayName TEXT)
begin

	declare matchid int;
	declare match_start_time datetime;

	select id
	into matchid
	from dblog_matches
	where displayName = matchDisplayName;

	select startTime
	into match_start_time
	from dblog_matches
	where id = matchid;

	drop temporary table if exists getmatchkillfeed;
	drop temporary table if exists getmatchkillfeed_pre;

	create TEMPORARY table getmatchkillfeed_pre
	(
		id int,
		`time` datetime,
		`type` int,
		attacker varchar(255),
		attackerTeamID int,
		victim varchar(255),
		victimTeamID int,
		weapon varchar(255),
		teamkill int,
		primary key (id, `type`)
	);

	insert into getmatchkillfeed_pre (id, `time`, `type`, attacker, attackerTeamID, victim, victimTeamID, weapon, teamkill)
	select id, `time`, 0, attacker, attackerTeamID, victim, victimTeamID, weapon, teamkill
	from dblog_wounds
	where `match` = matchid;

	insert into getmatchkillfeed_pre (id, `time`, `type`, attacker, attackerTeamID, victim, victimTeamID, weapon, teamkill)
	select id, `time`, 1, reviver, reviverTeamID, victim, victimTeamID, weapon, 0
	from dblog_revives
	where `match` = matchid;

	insert into getmatchkillfeed_pre (id, `time`, `type`, attacker, attackerTeamID, victim, victimTeamID, weapon, teamkill)
	select id, `time`, 2, attacker, attackerTeamID, vehicleName, null, weapon, teamkill
	from dblog_vehicledestroys
	where `match` = matchid;

	update getmatchkillfeed_pre
	set victimTeamID = case 
		when teamkill = 1 then attackerTeamID 
		when (teamkill = 0 or teamkill is null) and attackerTeamID = 1 then 2 
		when (teamkill = 0 or teamkill is null) and attackerTeamID = 2 then 1
		else victimTeamID end
	where `type` = 2;

	create TEMPORARY table getmatchkillfeed
	(
		`id` int,
		`time` datetime,
		`time_from` varchar(255),
		`type` int,
		`attacker` varchar(255),
		`attackerColor` varchar(255),
		`victim` varchar(255),
		`victimColor` varchar(255),
		`weapon` varchar(255),
		`weaponType` varchar(255),
		`html` text,
		`attackerSteamID` varchar(255),
		`victimSteamID` varchar(255),
		`attackerTeamID` int,
		`victimTeamID` int,
		primary key (`id`, `type`)
	);

	insert into getmatchkillfeed (`id`, `time`, `type`, `attacker`, `attackerSteamID`, `attackerTeamID`, `victimSteamID`, `victimTeamID`, `weapon`)
	select 
		`id`, 
		`time`, 
		`type`,
		fn_getnamefromsteamid(`attacker`) as `attacker`, 
		`attacker` as `attackerSteamID`, 
		`attackerTeamID` as `attackerTeamID`, 
		`victim` as `victimSteamID`, 
		`victimTeamID` as `victimTeamID`,
		`weapon`
	from `getmatchkillfeed_pre`;

	update getmatchkillfeed
	set attackerColor = case
		when `attackerTeamID` = 1
			then '<font color="#1b6fe2">'
		when `attackerTeamID` = 2
			then '<font color="#ea2b1c">'
		else '<font color="#ffffff">'
	end;
	
	update getmatchkillfeed
	set victim = fn_getnamefromsteamid(`victimSteamID`) 
	where `type` <> 2;

	update getmatchkillfeed
	set victim =  replace(replace(`victimSteamID`, 'BP_', ''), '_', ' ') 
	where `type` = 2;

	update getmatchkillfeed
	set victimSteamID = null
	where `type` = 2;

	update getmatchkillfeed
	set victimColor = '<font color="#1b6fe2">'
	where victimTeamID = 1;

	update getmatchkillfeed
	set victimColor = '<font color="#ea2b1c">'
	where victimTeamID = 2;

	update getmatchkillfeed
	set victimColor = '<font color="#ffffff">'
	where victimTeamID not in (1,2);

	update getmatchkillfeed
	set weapon = '[Revive]'
	where `type` = 1;

	update getmatchkillfeed
	set weapon = concat("[", replace(replace(`weapon`, 'BP_', ''), '_', ' '), "]")
	where `type` <> 1;

	update getmatchkillfeed
	set weaponType = 'revive'
	where `type` = 1;

	update getmatchkillfeed
	set weaponType = fn_getweapontype(`weapon`) 
	where `type` <> 1;

	update getmatchkillfeed
	set time_from = concat('[',TIME_FORMAT(TIMEDIFF(`time`, match_start_time), '%H:%i:%s'),'] ');

	update getmatchkillfeed
	set html = concat(time_from, attackerColor, attacker, ' </font> ', weapon);

	update getmatchkillfeed
	set html = concat(html, ' ')
	where weaponType is null;

	update getmatchkillfeed
	set html = concat(html, ' <img src="public/img/squad_killfeed/', weaponType, '.png" height="45"> ')
	where weaponType is not null;

	update getmatchkillfeed
	set html = concat(html, victimColor, victim, ' </font>');

	update getmatchkillfeed
	set html = concat(html, ' <img src="public/img/squad_killfeed/vehicle.png" height="45">')
	where `type` = 2;
	
	drop temporary table if exists getmatchkillfeed_pre;

end;
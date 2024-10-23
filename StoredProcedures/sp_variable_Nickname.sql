DROP PROCEDURE IF EXISTS `sp_variable_Nickname`;
CREATE PROCEDURE `sp_variable_Nickname`(
    fromVar varchar(255),
    toVar varchar(255))
BEGIN
    select players.lastName from dblog_players as players
    where players.lastName <> 'unknown player' and players.`ignore` = 0
    and (exists (select 1 from dblog_deaths as a where a.attacker = players.steamID and a.teamkill != 1 and exists (
            select 1 from `dblog_matches` where starttime between str_to_date(left(fromVar, 19),'%Y-%m-%dT%H:%i:%s') and str_to_date(left(toVar, 19),'%Y-%m-%dT%H:%i:%s') 
                and `dblog_matches`.server <> 3 and `dblog_matches`.`ignore` = 0 and a.match = `dblog_matches`.id limit 1) limit 1)
        or exists (select 1 from dblog_deaths as a where a.victim = players.steamID and exists (
            select 1 from `dblog_matches` where starttime between str_to_date(left(fromVar, 19),'%Y-%m-%dT%H:%i:%s') and str_to_date(left(toVar, 19),'%Y-%m-%dT%H:%i:%s') 
                and `dblog_matches`.server <> 3 and `dblog_matches`.`ignore` = 0 and a.match = `dblog_matches`.id limit 1) limit 1)
        or exists (select 1 from dblog_wounds as a where a.attacker = players.steamID and a.teamkill != 1 and exists (
            select 1 from `dblog_matches` where starttime between str_to_date(left(fromVar, 19),'%Y-%m-%dT%H:%i:%s') and str_to_date(left(toVar, 19),'%Y-%m-%dT%H:%i:%s') 
                and `dblog_matches`.server <> 3 and `dblog_matches`.`ignore` = 0 and a.match = `dblog_matches`.id limit 1) limit 1)
        or exists (select 1 from dblog_revives as a where a.reviver = players.steamID and exists (
            select 1 from `dblog_matches` where starttime between str_to_date(left(fromVar, 19),'%Y-%m-%dT%H:%i:%s') and str_to_date(left(toVar, 19),'%Y-%m-%dT%H:%i:%s') 
                and `dblog_matches`.server <> 3 and `dblog_matches`.`ignore` = 0 and a.match = `dblog_matches`.id limit 1) limit 1));
END
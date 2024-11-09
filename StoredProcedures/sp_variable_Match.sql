DROP PROCEDURE IF EXISTS `sp_variable_Match`;
CREATE PROCEDURE `sp_variable_Match`(
    fromVar varchar(255),
    toVar varchar(255),
    layerVar TEXT,
    serverVar TEXT,
    nicknameVar TEXT)
BEGIN
    call sp_getmatchidsbymap(layerVar);
    call sp_serveridsfromnamesjson(serverVar);
    call sp_steamidlistfromnamesjson(nicknameVar);
	select `displayName` as `Match`
    from `dblog_matches` as matches
    where matches.starttime between str_to_date(left(fromVar, 19),'%Y-%m-%dT%H:%i:%s') and str_to_date(left(toVar, 19),'%Y-%m-%dT%H:%i:%s')
        and matches.server != 3
        and exists (
            select 1 from steamidlistfromnamesjson as stjs
            left join dblog_deaths as a on a.match = matches.id and a.teamkill <> 1 and a.attacker = stjs.steamID
            left join dblog_deaths as b on b.match = matches.id and b.victim = stjs.steamID
            left join dblog_wounds as c on c.match = matches.id and c.teamkill <> 1 and c.attacker = stjs.steamID
            left join dblog_revives as d on d.match = matches.id and d.reviver = stjs.steamID
            where a.match is not null or b.match is not null or c.match is not null or d.match is not null)
        and matches.ignore = 0
        and matches.id in (select matchID from getmatchidsbymap)
        and matches.server in (select serverID from serveridsfromnamesjson)
    order by matches.StartTime desc;
    drop temporary table if exists `getmatchidsbymap`;
    drop temporary table if exists `serveridsfromnamesjson`;
    drop temporary table if exists `steamidlistfromnamesjson`;
END 
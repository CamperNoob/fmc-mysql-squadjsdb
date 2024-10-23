DROP PROCEDURE IF EXISTS `sp_variable_Server`;
CREATE PROCEDURE `sp_variable_Server`(
    fromVar varchar(255),
    toVar varchar(255),
    nicknameVar TEXT)
BEGIN
    call sp_steamidlistfromnamesjson(nicknameVar);
    select servers.name from dblog_servers as servers
    where servers.id != 3 and exists (
        select 1 from dblog_matches as matches
        where matches.ignore = 0
            and exists (
                select 1 from steamidlistfromnamesjson as stjs
                left join dblog_deaths as a on a.match = matches.id and a.teamkill != 1 and a.attacker = stjs.steamID
                left join dblog_deaths as b on b.match = matches.id and b.victim = stjs.steamID
                left join dblog_wounds as c on c.match = matches.id and c.teamkill != 1 and c.attacker = stjs.steamID
                left join dblog_revives as d on d.match = matches.id and d.reviver = stjs.steamID
                where a.match is not null or b.match is not null or c.match is not null or d.match is not null)
            and matches.server = servers.id);
    drop temporary table if exists `steamidlistfromnamesjson`;
END
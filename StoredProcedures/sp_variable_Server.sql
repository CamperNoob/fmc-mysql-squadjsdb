DROP PROCEDURE IF EXISTS `sp_variable_Server`;
CREATE PROCEDURE `sp_variable_Server`(
    fromVar varchar(255),
    toVar varchar(255),
    nicknameVar TEXT)
BEGIN
--    call sp_steamidlistfromnamesjson(nicknameVar);
--    create temporary table steamidlist_copy1 as
--    select steamID from steamidlistfromnamesjson;
--    create temporary table steamidlist_copy2 as
--    select steamID from steamidlistfromnamesjson;
--    create temporary table steamidlist_copy3 as
--    select steamID from steamidlistfromnamesjson;
    select servers.name from dblog_servers as servers
    where servers.id != 3 and exists (
        select 1 from dblog_matches as matches
        where matches.ignore = 0
--            and (
--                    exists (
--                        select 1 from steamidlist_copy1 as stjs1
--                        join dblog_deaths as a on a.match = matches.id and a.teamkill != 1 and a.attacker = stjs1.steamID)
--                    or exists (
--                        select 1 from steamidlist_copy2 as stjs2
--                        join dblog_deaths as b on b.match = matches.id and b.teamkill != 1 and b.victim = stjs2.steamID)
--                    or exists (
--                        select 1 from steamidlist_copy3 as stjs3
--                        join dblog_wounds as c on c.match = matches.id and c.teamkill != 1 and c.attacker = stjs3.steamID))
            and matches.server = servers.id);
--    drop temporary table if exists `steamidlistfromnamesjson`;
--    drop temporary table if exists `steamidlist_copy1`;
--    drop temporary table if exists `steamidlist_copy2`;
--    drop temporary table if exists `steamidlist_copy3`;
END
DROP PROCEDURE IF EXISTS `sp_variable_Live_killfeed`;
CREATE PROCEDURE `sp_variable_Live_killfeed`(serverVar TEXT)
BEGIN
    declare serverid int;

    select id
	into serverid
	from dblog_servers
	where name = serverVar;

	select `displayName` as `Match`
    from `dblog_matches` as matches
    where --matches.starttime between str_to_date(left(fromVar, 19),'%Y-%m-%dT%H:%i:%s') and str_to_date(left(toVar, 19),'%Y-%m-%dT%H:%i:%s') and 
        matches.server = serverid
        --and matches.ignore = 0
    order by matches.StartTime desc
    limit 1;
END 
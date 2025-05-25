DROP PROCEDURE IF EXISTS `sp_variable_Match_killfeed`;
CREATE PROCEDURE `sp_variable_Match_killfeed`(
    fromVar varchar(255),
    toVar varchar(255))
BEGIN
	select `displayName` as `Match`
    from `dblog_matches` as matches
    where matches.starttime between str_to_date(left(fromVar, 19),'%Y-%m-%dT%H:%i:%s') and str_to_date(left(toVar, 19),'%Y-%m-%dT%H:%i:%s')
        and matches.server in (1, 2)
        and matches.ignore = 0
    order by matches.StartTime desc;
END 
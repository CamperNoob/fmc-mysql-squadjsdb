drop procedure if exists `grafana_dashboardinternalmatches`;
create procedure `grafana_dashboardinternalmatches`(fromVar varchar(255), toVar varchar(255))
begin
    drop temporary table if exists matches_internal;
	create TEMPORARY table matches_internal
	(
		id int,
		layerClassName varchar(255),
		startTime datetime,
		endTime datetime,
		duration int,
		maxPlayers int,
        matchName varchar(255),
		serverName varchar(255),
		`ignore` int,
		primary key (id)
	);

    insert into matches_internal (id, layerClassName, startTime, endTime, duration, maxPlayers, matchName, serverName, `ignore`)
    select a.id as ID, a.layerClassName as layerClassName, a.StartTime as startTime, ifnull(a.EndTime, now()) as endTime, TIMESTAMPDIFF(MINUTE, a.StartTime, ifnull(a.EndTime, now())) as duration, 
    null as maxPlayers, a.displayName as matchName, b.name as serverName, a.`ignore` as `ignore` 
    from dblog_matches as a
    left join dblog_servers as b on a.server = b.id
    where a.`StartTime` between str_to_date(left(fromVar, 19),'%Y-%m-%dT%H:%i:%s') and str_to_date(left(toVar, 19),'%Y-%m-%dT%H:%i:%s');

    update matches_internal as c
	left join (
        select `match`, max(players) as max_players
        from dblog_playercounts
        --where `match` in (select id from matches_internal)
        group by `match`
    ) as d on c.id = d.match
	set c.maxPlayers = d.max_players;

    select id as ID, layerClassName as 'Карта', StartTime as 'Початок', EndTime as 'Кінець', duration as 'Тривалість хв.', 
    maxPlayers as 'Максимум гравців', matchName as 'Назва', serverName as 'Сервер', `ignore` as 'Ігнорувати'
    from matches_internal
    order by ID desc;

    drop temporary table if exists matches_internal;
end
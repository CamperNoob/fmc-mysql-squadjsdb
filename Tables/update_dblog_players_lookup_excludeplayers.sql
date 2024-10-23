start transaction;
update dblog_players as players
left join lookup_excludeplayers as excluded on players.Id = excluded.playerId
set players.ignore = 1
where excluded.playerId is not null;
select * from dblog_players as a
left join lookup_excludeplayers as b on a.Id = b.playerId;
commit;

start transaction;
update dblog_players as players
left join lookup_excludeplayers as excluded on players.Id = excluded.playerId
set players.ignore = 0
where excluded.playerId is null;
select * from dblog_players as a
left join lookup_excludeplayers as b on a.Id = b.playerId;
commit;

drop table if exists lookup_excludeplayers;
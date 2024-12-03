start transaction;
update dblog_players
set lastName = replace(lastName, "'", "")
where lastName like "%'%";
select * from dblog_players where lastName like "%'%";
--commit;
--rollback;
start TRANSACTION;
create temporary table matchNames (id int, displayName varchar(255));
insert into matchNames (id, displayName) values
(2,'Тренування від Delfin97 на техніці R1');
update dblog_matches as m
join matchNames as t on m.id = t.id
set m.displayName = t.displayName
where t.id is not null;
select * from dblog_matches;
drop temporary table if exists matchNames;
--commit;
--rollback;
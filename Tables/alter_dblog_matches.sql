alter table `dblog_matches`
add `ignore` int; 

alter table `dblog_matches`
add `displayName` varchar(255);

start TRANSACTION;
update dblog_matches
set displayName = DATE_FORMAT(date_add(dblog_matches.StartTime, interval 3 hour), '%Y-%m-%d %H:%i');
select * from dblog_matches;
commit;
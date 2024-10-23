drop procedure if exists `grafana_dashboardravg`;
create procedure `grafana_dashboardravg`(fromVar varchar(255), toVar varchar(255), nicknameVar varchar(255))
begin 
	call sp_getstatsbytime(str_to_date(left(fromVar, 19),'%Y-%m-%dT%H:%i:%s'),str_to_date(left(toVar, 19),'%Y-%m-%dT%H:%i:%s'));
	select fn_calculateKD(sum(revives), sum(deaths)) as RevivesDeathsAvg
	from getstatsbytime 
	where steamID = fn_getsteamidfromname(nicknameVar)
	group by date_add(date(matchTime), interval -3 hour);
	drop temporary table if exists getstatsbytime;
end
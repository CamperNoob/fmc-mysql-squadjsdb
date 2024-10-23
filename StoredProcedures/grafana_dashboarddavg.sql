drop procedure if exists `grafana_dashboarddavg`;
create procedure `grafana_dashboarddavg`(fromVar varchar(255), toVar varchar(255), nicknameVar varchar(255))
begin 
	call sp_getstatsbytime(str_to_date(left(fromVar, 19),'%Y-%m-%dT%H:%i:%s'),str_to_date(left(toVar, 19),'%Y-%m-%dT%H:%i:%s'));
	select fn_calculateKD(sum(deaths), sum(kills)) as DeathsKillsAvg
	from getstatsbytime 
	where steamID = fn_getsteamidfromname(nicknameVar)
	group by date_add(date(matchTime), interval -3 hour);
	drop temporary table if exists getstatsbytime;
end
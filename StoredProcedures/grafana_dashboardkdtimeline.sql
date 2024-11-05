drop procedure if exists `grafana_dashboardkdtimeline`;
create procedure `grafana_dashboardkdtimeline`(fromVar varchar(255), toVar varchar(255), nicknameVar varchar(255))
begin 
	call sp_getstatsbytime(str_to_date(left(fromVar, 19),'%Y-%m-%dT%H:%i:%s'),str_to_date(left(toVar, 19),'%Y-%m-%dT%H:%i:%s'));
	select date(matchTime) as `Date`, fn_calculateKD(sum(kills), sum(deaths)) as `Kill\Deaths`, fn_calculateKD(sum(revives), sum(deaths)) as `Revive\Deaths`
	from getstatsbytime 
	where steamID = fn_getsteamidfromname(nicknameVar)
	group by date(matchTime);
	drop temporary table if exists getstatsbytime;
end
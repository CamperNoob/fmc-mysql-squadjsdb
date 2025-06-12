drop procedure if exists `grafana_dashboardtotalkdr`;
create procedure `grafana_dashboardtotalkdr`(fromVar varchar(255), toVar varchar(255), nicknameVar varchar(255))
begin 
	call sp_getstatsbytime(str_to_date(left(fromVar, 19),'%Y-%m-%dT%H:%i:%s'),str_to_date(left(toVar, 19),'%Y-%m-%dT%H:%i:%s'));
	select sum(kills) as Kills, sum(wounds) as Wounds, sum(deaths) as Deaths, sum(Revives) as Revives, sum(Vehicles) as `Destroyed Vehicles`, sum(Teamkills) as `Teamkills`
	from getstatsbytime 
	where steamID = fn_getsteamidfromname(nicknameVar);
	drop temporary table if exists getstatsbytime;
end
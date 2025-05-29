drop procedure if exists `grafana_dashboardlivekillfeed`;
create procedure `grafana_dashboardlivekillfeed`(matchDisplayName TEXT)
begin 
	call sp_getmatchkillfeed(matchDisplayName);

	with result as (
		select distinct a.html, `time`, id
		from getmatchkillfeed as a
	)
	select html as Feed
	from result
	order by `time` desc, id desc;

	drop temporary table if exists getmatchkillfeed;
end
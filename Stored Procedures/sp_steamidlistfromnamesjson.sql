drop procedure if exists `sp_steamidlistfromnamesjson`;
create procedure `sp_steamidlistfromnamesjson` (jsonString TEXT)
begin
	drop temporary table if exists `steamidlistfromnamesjson`;
	create temporary table `steamidlistfromnamesjson` (searchName varchar(255), steamID varchar(255));

	insert into steamidlistfromnamesjson (searchName)
	select value
	from JSON_TABLE(jsonString, '$[*]' columns(value varchar(255) path '$')) as jt;

	update steamidlistfromnamesjson
	set steamID = fn_getsteamidfromname(searchName);
end
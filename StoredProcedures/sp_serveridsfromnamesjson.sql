DROP PROCEDURE IF EXISTS `sp_serveridsfromnamesjson`;
CREATE PROCEDURE `sp_serveridsfromnamesjson`(jsonString TEXT)
begin
	drop temporary table if exists `serveridsfromnamesjson`;
	create temporary table `serveridsfromnamesjson` (searchName varchar(255), serverId varchar(255));

	insert into serveridsfromnamesjson (searchName)
	select value
	from JSON_TABLE(jsonString, '$[*]' columns(value varchar(255) path '$')) as jt;

	update serveridsfromnamesjson as a
	left join dblog_servers as b on a.searchName = b.name
	set a.serverId = b.id;
end
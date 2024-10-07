DROP FUNCTION IF EXISTS `fn_getsteamidfromname`;
CREATE FUNCTION `fn_getsteamidfromname`(nameLike varchar(255)) RETURNS varchar(255)
    DETERMINISTIC
begin
	declare found_steamid varchar(255) default null;
	declare wildcard varchar(255) default null;
	set wildcard = concat("%", nameLike, "%");
	select steamID into found_steamid from dblog_players where lastName like wildcard limit 1;
	return found_steamid;
end
DROP FUNCTION IF EXISTS `fn_getnamefromsteamid`;
CREATE FUNCTION `fn_getnamefromsteamid`(id varchar(255)) RETURNS varchar(255)
    DETERMINISTIC
begin
	declare found_name varchar(255) default null;
	select lastName into found_name from dblog_players where steamID = id;
	return found_name;
end
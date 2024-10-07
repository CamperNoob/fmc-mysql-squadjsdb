DROP FUNCTION IF EXISTS `fn_getdatetimefromrange`;
CREATE FUNCTION `fn_getdatetimefromrange` (dateRangeNumber int, dateRangeType varchar(255), dateTo datetime) RETURNS datetime
    DETERMINISTIC
begin
	declare result datetime;
	IF dateRangeType = 'm' THEN
        -- For minutes
        SET result = DATE_SUB(dateTo, INTERVAL dateRangeNumber MINUTE);
    ELSEIF dateRangeType = 'h' OR dateRangeType = 'hours' THEN
        -- For hours
        SET result = DATE_SUB(dateTo, INTERVAL dateRangeNumber HOUR);
    ELSEIF dateRangeType = 'd' OR dateRangeType = 'days' THEN
        -- For days
        SET result = DATE_SUB(dateTo, INTERVAL dateRangeNumber DAY);
    ELSEIF dateRangeType = 'months' THEN
        -- For months
        SET result = DATE_SUB(dateTo, INTERVAL dateRangeNumber MONTH);
    ELSEIF dateRangeType = 'years' THEN
        -- For years
        SET result = DATE_SUB(dateTo, INTERVAL dateRangeNumber YEAR);
    ELSE
        SET result = dateTo;
    END IF;
	return result;
end
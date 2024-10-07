drop event if exists `squadjs`.`event_updateactivemaps`;
create event `squadjs`.`event_updateactivemaps`
on SCHEDULE EVERY 1 DAY
STARTS '2024-10-07 02:00:00'
DO
	CALL `squadjs`.`sp_updateactivemaps`();
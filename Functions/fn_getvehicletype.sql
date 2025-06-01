DROP FUNCTION IF EXISTS `fn_getvehicletype`;
CREATE FUNCTION `fn_getvehicletype`(vehicle varchar(255)) RETURNS varchar(255)
    DETERMINISTIC
begin
	declare found_vehicle varchar(255) default null;

	--select GROUP_CONCAT(vehicleIcon SEPARATOR ', ')
	select vehicleIcon
	into found_vehicle
	from lookup_vehicletypes
	--where vehicle like concat('%', vehicleName);
	where vehicle like concat('%', vehicleName)
	limit 1;

	return found_vehicle;
end
DROP FUNCTION IF EXISTS `fn_getweapontype`;
CREATE FUNCTION `fn_getweapontype`(weapon varchar(255)) RETURNS varchar(255)
    DETERMINISTIC
begin
	declare found_weapon varchar(255) default null;

	--select GROUP_CONCAT(weaponIcon SEPARATOR ', ')
	select weaponIcon
	into found_weapon
	from lookup_weapontypes
	--where weapon like concat('%', weaponName);
	where weapon like concat('%', weaponName)
	limit 1;

	return found_weapon;
end
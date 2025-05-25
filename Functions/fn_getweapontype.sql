DROP FUNCTION IF EXISTS `fn_getweapontype`;
CREATE FUNCTION `fn_getweapontype`(weapon varchar(255)) RETURNS varchar(255)
    DETERMINISTIC
begin
	declare found_weapon varchar(255) default null;

	with a as (
		select weapon as `weapon`
	)
	,frag as (
		select weapon from a
		where (a.weapon like '%frag%'
			or a.weapon like '%rkg3%')
			and a.weapon not like '%HEFrag%'
			and a.weapon not like '%100mm%'
			and a.weapon not like '%125mm%'
			and a.weapon not like '%riflegrenade%'
			and a.weapon not like '%rpg7%'
			and a.weapon not like '%spg9%'
			and a.weapon not like '%mg253%'
			and a.weapon not like '%2a46%'
			and a.weapon not like '%ztd05%'
	)
	,explosion as (
		select weapon from a
		where a.weapon like '%explosive%' 
			or a.weapon like '%_IED%'
	)
	,gp as (
		select weapon from a
		where a.weapon like '%40mm%'
			or a.weapon like '%riflegrenade%'
	)
	,mortar as (
		select weapon from a
		where a.weapon like '%hell%' 
			or a.weapon like '%mortar%'
			or a.weapon like '%ub32%'
			or (a.weapon like '%120mm%' and a.weapon not like '%heat%')
			or a.weapon like '%_S5_%'
	)
	,arty as (
		select weapon from a
		where a.weapon like '%artillery%'
	)
	,knife as (
		select weapon from a
		where a.weapon like '%bayonet%'
			or a.weapon like '%OKC%'
	)
	,rocket as (
		select weapon from a
		where (a.weapon like '%_proj'
			or a.weapon like '%_proj2'
			or a.weapon like '%tandem%')
			and a.weapon not like '%40mm%'
			and a.weapon not like '%_S5_%'
	)
	,mine as (
		select weapon from a
		where a.weapon like '%Deployable' and a.weapon like '%mine%'
	)
	,total_defined as (
		select weapon, 'frag' as `type` from frag
		union
		select weapon, 'explosion' from explosion
		union
		select weapon, 'gp' from gp
		union
		select weapon, 'mortar' from mortar
		union
		select weapon, 'arty' from arty
		union
		select weapon, 'knife' from knife
		union
		select weapon, 'rocket' from rocket
		union
		select weapon, 'mine' from mine
	)
	,total as (
		select weapon, `type` as `type` from total_defined
		union
		select weapon, 'other' from a
		where not exists (select 1 from total_defined as b where a.weapon = b.weapon)
	)
	select distinct `type`
	into found_weapon
	from total
	limit 1;

	return found_weapon;
end
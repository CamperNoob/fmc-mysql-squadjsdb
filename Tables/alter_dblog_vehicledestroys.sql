alter table `dblog_vehicledestroys`
add `attackerTeamID` int; 

alter table `dblog_vehicledestroys`
add `weapon` varchar(255);

START TRANSACTION;

WITH match_team_id AS (
    SELECT DISTINCT `match`, attacker, attackerTeamID
    FROM dblog_wounds
    UNION
    SELECT DISTINCT `match`, victim AS attacker, victimTeamID AS attackerTeamID
    FROM dblog_wounds
)
UPDATE dblog_vehicledestroys AS a
JOIN match_team_id AS b
    ON a.`match` = b.`match` AND a.attacker = b.attacker
SET a.attackerTeamID = b.attackerTeamID;

with match_team_id as (
    select distinct `match`, attacker, attackerTeamID from `dblog_wounds`
    union
    select distinct `match`, victim as attacker, victimTeamID as attackerTeamID from `dblog_wounds`
)
select a.*, b.attackerTeamID from `dblog_vehicledestroys` as a
join match_team_id as b on a.match = b.`match` and a.attacker = b.attacker;

--COMMIT;
ROLLBACK;
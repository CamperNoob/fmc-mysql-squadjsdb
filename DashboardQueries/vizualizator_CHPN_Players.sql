select lastName as 'Нікнейм'
, lastIPCountry as 'Країна'
, steamID as SteamID
, `ignore` as 'Ігнорувати'
, id as ID
from dblog_players
where id <> 458
order by id desc
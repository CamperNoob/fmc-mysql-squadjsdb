select DATE_FORMAT(date_add(`StartTime`, interval 3 hour), '%Y-%m-%d %H:%i') as `Match`
from `dblog_matches` 
where starttime between `fn_getdatetimefromrange`($Last, '$LastType', NOW()) and NOW()
    and server != 3
    and (
            exists (select 1 from dblog_deaths as a where a.match = `dblog_matches`.id and a.teamkill != 1)
            or
            exists (select 1 from dblog_wounds as a where a.match = `dblog_matches`.id and a.teamkill != 1)
            or
            exists (select 1 from dblog_revives as a where a.match = `dblog_matches`.id)
        )
    and `ignore` = 0
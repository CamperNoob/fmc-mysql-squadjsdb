SELECT
    CAST(`date` AS DATE) AS `Дата проведення`,
    event_name as `Назва події`,
    opponent AS `Клан суперник`,
    mercs AS `Клан найманці`,
    layer AS `Леєр (з фракціями)`,
    match_status AS `Статус`,
    case when ticket_diff_r1 + ticket_diff_r2 > 0 then CONCAT('+', ticket_diff_r1 + ticket_diff_r2) ELSE CONCAT(ticket_diff_r1 + ticket_diff_r2, '') end as `Різниця тікетів`,
    CONCAT(ticket_us_r1, '/', ticket_op_r1, ' (', case when ticket_diff_r1 > 0 then CONCAT('+', ticket_diff_r1) ELSE CONCAT(ticket_diff_r1, '') end, ')') AS `Тікети перший раунд`,
    CONCAT(ticket_us_r2, '/', ticket_op_r2, ' (', case when ticket_diff_r2 > 0 then CONCAT('+', ticket_diff_r2) ELSE CONCAT(ticket_diff_r2, '') end, ')') AS `Тікети другий раунд`,
    vods AS `Записи гри`,
    tactics AS `Тактика`,
    event_url AS `Посилання на подію`
FROM
    match_history
WHERE
    `ignore` = 0 and
    `date` between str_to_date(left('${__from:date:iso}', 19),'%Y-%m-%dT%H:%i:%s') and str_to_date(left('${__to:date:iso}', 19),'%Y-%m-%dT%H:%i:%s')
ORDER BY DATE DESC;
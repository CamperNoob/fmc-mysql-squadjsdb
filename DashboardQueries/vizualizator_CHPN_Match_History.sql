SELECT
    CAST(`date` AS DATE) AS `Date`,
    opponent AS `Opponent`,
    mercs AS `Mercs`,
    layer AS `Layer`,
    match_status AS `Result`,
    CONCAT(ticket_us_r1, '/', ticket_op_r1, ' (', ticket_diff_r1, ')') AS `Round 1 Tickets`,
    CONCAT(ticket_us_r2, '/', ticket_op_r2, ' (', ticket_diff_r2, ')') AS `Round 2 Tickets`,
    event_url AS `Event URL`,
    vods AS `VODs`,
    tactics AS `Tactics`
FROM
    match_history
WHERE
    `ignore` = 0;
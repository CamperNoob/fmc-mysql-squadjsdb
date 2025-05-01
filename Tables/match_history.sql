CREATE TABLE match_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    `date` DATETIME,
    opponent VARCHAR(255),
    mercs VARCHAR(255),
    ticket_us_r1 INT,
    ticket_op_r1 INT,
    ticket_diff_r1 INT,
    ticket_us_r2 INT,
    ticket_op_r2 INT,
    ticket_diff_r2 INT,
    layer VARCHAR(255),
    vods varchar(255),
    match_status VARCHAR(255),
    tactics varchar(255),
    event_url VARCHAR(255),
    `ignore` int,
    event_name varchar(255)
);
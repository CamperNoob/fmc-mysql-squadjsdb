create table lookup_utc_offset(`offset` int, fromDate datetime, primary key (`fromDate`));
insert into lookup_utc_offset(`offset`, `fromDate`)
values (3, '2024-07-01'),
(2, '2024-10-27');
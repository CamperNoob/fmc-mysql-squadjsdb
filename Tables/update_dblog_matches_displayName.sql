start TRANSACTION;
create temporary table matchNames (id int, displayName varchar(255));
insert into matchNames (id, displayName) values
(2,'Тренування від Delfin97 на техніці R1'),
(4,'Тренування від Delfin97 на техніці R2'),
(9,'30-30 450 vs COTA IM_Yehorivka_AAS_1 R1'),
(10,'30-30 450 vs COTA IM_Yehorivka_AAS_1 R2'),
(19,'30на30-«jaeger-division» IM_Chora_AAS_1 R1'),
(20,'30на30-«jaeger-division» IM_Chora_AAS_1 R2'),
(27,'30-30 450 vs Jaeger Division IM_Yehorivka_AAS_1 R1'),
(30,'30-30 450 vs Jaeger Division IM_Yehorivka_AAS_1 R2'),
(41,'30-30 450 vs NXL IM_Yehorivka_AAS_1 R1'),
(44,'30-30 450 vs NXL IM_Yehorivka_AAS_1 R2'),
(47,'International Masters 450 vs GoodFellas IM_Yehorivka_AAS R1'),
(48,'International Masters 450 vs GoodFellas IM_Yehorivka_AAS R2'),
(53,'30на30 450 vs DTEK IM_Chora_AAS R1'),
(54,'30на30 450 vs DTEK IM_Chora_AAS R2'),
(56,'30на30 450 vs G4S+NL IM_Chora_AAS R1'),
(59,'30на30 450 vs G4S+NL IM_Chora_AAS R2'),
(78,'International Masters 450 vs SLS IM_Chora_AAS R1'),
(79,'International Masters 450 vs SLS IM_Chora_AAS R2'),
(83,'30на30 450 vs NHS IM_Belaya_AAS R1'),
(86,'30на30 450 vs NHS IM_Belaya_AAS R2'),
(90,'30-30 450 vs COTA IM_Belaya_AAS R1'),
(91,'30-30 450 vs COTA IM_Belaya_AAS R2'),
(97,'International Masters 450 vs FRI IM_Belaya_AAS R1'),
(98,'International Masters 450 vs FRI IM_Belaya_AAS R2'),
(101,'30-30 450 vs 8mm IM_Fools Road R1'),
(102,'30-30 450 vs 8mm IM_Fools Road R2'),
(105,'30-30 450 vs Jaeger Division IM_Fools Road R1'),
(108,'30-30 450 vs Jaeger Division IM_Fools Road R2'),
(111,'International Masters 450 vs COTA IM_Fools Road R1'),
(112,'International Masters 450 vs COTA IM_Fools Road R2'),
(113,'30-30 450 vs Goodfellas IM_Narva_AAS R1'),
(118,'30-30 450 vs Goodfellas IM_Narva_AAS R2'),
(121,'30-30 450 vs 8mm IM_Narva_AAS R1'),
(124,'30-30 450 vs 8mm IM_Narva_AAS R2'),
(132,'30-30 450 vs NXL IM_Narva_AAS R1'),
(135,'30-30 450 vs NXL IM_Narva_AAS R2');
update dblog_matches as m
join matchNames as t on m.id = t.id
set m.displayName = t.displayName
where t.id is not null;
select * from dblog_matches;
drop temporary table if exists matchNames;
--commit;
--rollback;
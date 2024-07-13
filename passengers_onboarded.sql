

select * from buses;
select * from Passengers;

with recursive cte as (
select rn, bus_id, capacity, total_passengers_overall,
	least(capacity,total_passengers_overall) as passengers_current
	, least(capacity,total_passengers_overall) as total_passengers_onboarded
	from cte_buses
	union all
	select d.rn, d.bus_id, d.capacity, d.total_passengers_overall,
	least(d.capacity,d.total_passengers_overall-cte.total_passengers_onboarded) as passengers_current,
	total_passengers_onboarded+least(d.capacity,d.total_passengers_overall-cte.total_passengers_onboarded) as total_passengers_onboarded
	from cte
	inner join cte_buses d on d.rn = cte.rn+1
)
, cte_buses as(
select row_number() over (order by arrival_time) as rn, bus_id, capacity, (select count(1) from Passengers p 
where p.arrival_time <= b.arrival_time) as total_passengers_overall
from buses b)

select bus_id, passengers_current as passengers_count
from cte
order by bus_id

/*
-- Dataset for Test case 3
insert into buses values (717,27 ,6 );
insert into buses values (54 ,102,4 );
insert into buses values (270,116,4 );
insert into buses values (337,209,9 );
insert into buses values (346,309,7 );
insert into buses values (16 ,467,9 );
insert into buses values (189,484,1 );
insert into buses values (29 ,550,10);
insert into buses values (771,627,1 );
insert into buses values (9  ,728,7 );
insert into buses values (274,797,9 );
insert into buses values (217,799,1 );
insert into buses values (531,840,5 );
insert into buses values (684,858,6 );
insert into buses values (479,928,2 );
insert into buses values (101,931,5 );

insert into Passengers values(1679,76 );
insert into Passengers values(667 ,86 );
insert into Passengers values(1552,132);
insert into Passengers values(512 ,147);
insert into Passengers values(1497,156);
insert into Passengers values(907 ,158);
insert into Passengers values(1537,206);
insert into Passengers values(1535,219);
insert into Passengers values(584 ,301);
insert into Passengers values(16  ,318);
insert into Passengers values(166 ,375);
insert into Passengers values(1103,398);
insert into Passengers values(831 ,431);
insert into Passengers values(659 ,447);
insert into Passengers values(241 ,449);
insert into Passengers values(695 ,495);
insert into Passengers values(1702,517);
insert into Passengers values(499 ,536);
insert into Passengers values(685 ,541);
insert into Passengers values(523 ,573);
insert into Passengers values(1283,586);
insert into Passengers values(1013,619);
insert into Passengers values(256 ,680);
insert into Passengers values(854 ,698);
insert into Passengers values(1077,702);
insert into Passengers values(1684,779);
insert into Passengers values(1715,800);
insert into Passengers values(1772,804);
insert into Passengers values(69  ,807);
insert into Passengers values(261 ,919);
insert into Passengers values(581 ,922);
insert into Passengers values(1627,999);



-- Dataset for Test case 4
insert into buses values (238,4  ,4 );
insert into buses values (718,42 ,5 );
insert into buses values (689,52 ,8 );
insert into buses values (324,55 ,3 );
insert into buses values (358,59 ,7 );
insert into buses values (550,86 ,2 );
insert into buses values (46 ,91 ,5 );
insert into buses values (60 ,110,3 );
insert into buses values (667,123,8 );
insert into buses values (47 ,146,9 );
insert into buses values (671,158,2 );
insert into buses values (461,181,5 );
insert into buses values (399,183,9 );
insert into buses values (196,226,2 );
insert into buses values (549,227,7 );
insert into buses values (62 ,238,5 );
insert into buses values (251,269,6 );
insert into buses values (315,294,7 );
insert into buses values (243,305,4 );
insert into buses values (98 ,338,6 );
insert into buses values (642,369,6 );
insert into buses values (191,380,3 );
insert into buses values (67 ,394,2 );
insert into buses values (303,397,1 );
insert into buses values (663,466,1 );
insert into buses values (524,507,1 );
insert into buses values (405,556,5 );
insert into buses values (543,586,9 );
insert into buses values (177,623,3 );
insert into buses values (195,728,5 );
insert into buses values (573,747,6 );
insert into buses values (390,769,10);
insert into buses values (661,785,9 );
insert into buses values (494,798,5 );
insert into buses values (114,804,6 );
insert into buses values (571,810,9 );
insert into buses values (26 ,813,10);
insert into buses values (507,823,2 );
insert into buses values (739,829,4 );
insert into buses values (74 ,830,7 );
insert into buses values (483,849,1 );
insert into buses values (758,877,9 );
insert into buses values (597,895,2 );
insert into buses values (255,969,6 );
insert into buses values (717,977,5 );

insert into Passengers values(1490,4  );
insert into Passengers values(1535,8  );
insert into Passengers values(1283,34 );
insert into Passengers values(1230,58 );
insert into Passengers values(821 ,102);
insert into Passengers values(1388,104);
insert into Passengers values(1207,127);
insert into Passengers values(1110,144);
insert into Passengers values(566 ,149);
insert into Passengers values(1774,160);
insert into Passengers values(47  ,166);
insert into Passengers values(1099,167);
insert into Passengers values(1336,178);
insert into Passengers values(1251,193);
insert into Passengers values(572 ,194);
insert into Passengers values(524 ,208);
insert into Passengers values(1100,209);
insert into Passengers values(1211,246);
insert into Passengers values(885 ,249);
insert into Passengers values(403 ,268);
insert into Passengers values(538 ,274);
insert into Passengers values(1397,287);
insert into Passengers values(1303,301);
insert into Passengers values(1293,313);
insert into Passengers values(1133,315);
insert into Passengers values(216 ,324);
insert into Passengers values(318 ,337);
insert into Passengers values(373 ,345);
insert into Passengers values(49  ,351);
insert into Passengers values(998 ,358);
insert into Passengers values(109 ,364);
insert into Passengers values(245 ,383);
insert into Passengers values(205 ,383);
insert into Passengers values(410 ,395);
insert into Passengers values(179 ,410);
insert into Passengers values(1429,415);
insert into Passengers values(440 ,427);
insert into Passengers values(388 ,429);
insert into Passengers values(1470,453);
insert into Passengers values(1067,459);
insert into Passengers values(96  ,475);
insert into Passengers values(1363,496);
insert into Passengers values(229 ,498);
insert into Passengers values(1298,503);
insert into Passengers values(293 ,509);
insert into Passengers values(683 ,524);
insert into Passengers values(374 ,528);
insert into Passengers values(9   ,539);
insert into Passengers values(966 ,540);
insert into Passengers values(1275,552);
insert into Passengers values(1221,553);
insert into Passengers values(319 ,565);
insert into Passengers values(1131,569);
insert into Passengers values(1339,587);
insert into Passengers values(18  ,598);
insert into Passengers values(1024,653);
insert into Passengers values(396 ,663);
insert into Passengers values(409 ,677);
insert into Passengers values(545 ,689);
insert into Passengers values(999 ,699);
insert into Passengers values(1219,714);
insert into Passengers values(1195,725);
insert into Passengers values(957 ,738);
insert into Passengers values(1717,750);
insert into Passengers values(118 ,753);
insert into Passengers values(873 ,758);
insert into Passengers values(1706,759);
insert into Passengers values(1570,765);
insert into Passengers values(1469,772);
insert into Passengers values(1417,776);
insert into Passengers values(1773,809);
insert into Passengers values(568 ,823);
insert into Passengers values(83  ,831);
insert into Passengers values(804 ,835);
insert into Passengers values(418 ,837);
insert into Passengers values(1471,861);
insert into Passengers values(816 ,880);
insert into Passengers values(1673,881);
insert into Passengers values(1158,882);
insert into Passengers values(1466,910);
insert into Passengers values(172 ,927);
insert into Passengers values(1254,929);
insert into Passengers values(1337,934);
insert into Passengers values(1739,939);
insert into Passengers values(611 ,940);
insert into Passengers values(415 ,945);
insert into Passengers values(585 ,947);
insert into Passengers values(1632,949);
insert into Passengers values(1679,971);
insert into Passengers values(332 ,976);


-- Dataset for Test case 5
insert into buses values (81 ,57 ,10);
insert into buses values (137,69 ,7 );
insert into buses values (132,103,1 );
insert into buses values (756,138,3 );
insert into buses values (553,139,9 );
insert into buses values (591,196,5 );
insert into buses values (254,205,1 );
insert into buses values (664,218,10);
insert into buses values (440,234,4 );
insert into buses values (211,253,8 );
insert into buses values (54 ,286,7 );
insert into buses values (621,334,9 );
insert into buses values (516,345,2 );
insert into buses values (616,416,2 );
insert into buses values (32 ,436,9 );
insert into buses values (336,462,5 );
insert into buses values (61 ,468,4 );
insert into buses values (233,501,3 );
insert into buses values (492,508,9 );
insert into buses values (628,526,3 );
insert into buses values (93 ,563,1 );
insert into buses values (8  ,574,1 );
insert into buses values (76 ,586,3 );
insert into buses values (23 ,650,6 );
insert into buses values (147,669,7 );
insert into buses values (601,679,5 );
insert into buses values (179,696,10);
insert into buses values (647,703,5 );
insert into buses values (148,711,10);
insert into buses values (352,728,5 );
insert into buses values (176,746,5 );
insert into buses values (26 ,770,3 );
insert into buses values (231,772,2 );
insert into buses values (434,798,9 );
insert into buses values (64 ,826,1 );
insert into buses values (641,829,6 );
insert into buses values (484,846,3 );
insert into buses values (337,896,3 );

insert into Passengers values(108 ,1  );
insert into Passengers values(646 ,54 );
insert into Passengers values(1656,55 );
insert into Passengers values(1762,91 );
insert into Passengers values(89  ,101);
insert into Passengers values(427 ,150);
insert into Passengers values(1357,156);
insert into Passengers values(325 ,203);
insert into Passengers values(847 ,206);
insert into Passengers values(1036,211);
insert into Passengers values(119 ,214);
insert into Passengers values(1765,218);
insert into Passengers values(303 ,225);
insert into Passengers values(466 ,237);
insert into Passengers values(722 ,255);
insert into Passengers values(1659,279);
insert into Passengers values(1528,281);
insert into Passengers values(628 ,283);
insert into Passengers values(575 ,300);
insert into Passengers values(1075,306);
insert into Passengers values(743 ,309);
insert into Passengers values(894 ,327);
insert into Passengers values(190 ,388);
insert into Passengers values(502 ,392);
insert into Passengers values(541 ,401);
insert into Passengers values(1037,407);
insert into Passengers values(1093,412);
insert into Passengers values(1252,417);
insert into Passengers values(632 ,430);
insert into Passengers values(339 ,431);
insert into Passengers values(735 ,433);
insert into Passengers values(778 ,443);
insert into Passengers values(877 ,446);
insert into Passengers values(1137,473);
insert into Passengers values(1076,488);
insert into Passengers values(589 ,504);
insert into Passengers values(1763,509);
insert into Passengers values(172 ,525);
insert into Passengers values(1720,537);
insert into Passengers values(612 ,546);
insert into Passengers values(1588,550);
insert into Passengers values(651 ,553);
insert into Passengers values(363 ,567);
insert into Passengers values(1440,584);
insert into Passengers values(694 ,591);
insert into Passengers values(1338,614);
insert into Passengers values(652 ,631);
insert into Passengers values(1646,632);
insert into Passengers values(369 ,650);
insert into Passengers values(310 ,655);
insert into Passengers values(1006,661);
insert into Passengers values(1111,667);
insert into Passengers values(1556,695);
insert into Passengers values(1020,699);
insert into Passengers values(232 ,734);
insert into Passengers values(1017,785);
insert into Passengers values(516 ,786);
insert into Passengers values(1324,789);
insert into Passengers values(1487,792);
insert into Passengers values(5   ,809);
insert into Passengers values(173 ,847);
insert into Passengers values(982 ,863);
insert into Passengers values(455 ,872);
insert into Passengers values(769 ,879);
insert into Passengers values(260 ,893);
insert into Passengers values(123 ,914);
insert into Passengers values(1117,918);
insert into Passengers values(170 ,929);
insert into Passengers values(788 ,931);
insert into Passengers values(32  ,935);
insert into Passengers values(943 ,943);
insert into Passengers values(532 ,943);
insert into Passengers values(1334,944);
insert into Passengers values(866 ,954);
insert into Passengers values(697 ,959);
insert into Passengers values(255 ,964);

*/
-- resources

insert into light_transport(check_date)
values
	('1970-01-01'),
	('1971-01-01'),
	('2024-01-01'),
	('1945-01-01'),
	('1999-01-01'),
	('1810-01-01'),
	('1996-01-01'),
	('2006-01-01');

insert into resource_spec(resource_type, light_transport_id)
values
	('light_transport', 1),
	('light_transport', 2),
	('light_transport', 3),
	('light_transport', 4),
	('light_transport', 5),
	('light_transport', 6),
	('light_transport', 7),
	('light_transport', 8);

insert into bmp_transport(crews_count, check_date)
values
	(3, '1970-01-01'),
	(5, '1971-01-01'),
	(4, '2023-01-01'),
	(3, '2024-01-01'),
	(4, '2025-01-01'),
	(6, '2022-01-01'),
	(5, '2004-01-01'),
	(4, '2007-01-01');

insert into resource_spec(resource_type, bmp_id)
values
	('bmp', 1),
	('bmp', 2),
	('bmp', 3),
	('bmp', 4),
	('bmp', 5),
	('bmp', 6),
	('bmp', 7),
	('bmp', 8);

insert into auto_weapon(type_, fire_rate, check_date)
values
	('AK-47', 11, '1918-01-01'),
	('M-8',   14, '1943-01-01'),
	('M-8',   17, '1990-01-01'),
	('AK-47', 15, '1945-01-01'),
	('P-90',  23, '1991-01-01'),
	('AK-47', 13, '1970-01-01'),
	('M-8',   15, '1971-01-01'),
	('P-90',  30, '2013-01-01');

insert into resource_spec(resource_type, bmp_id)
values
	('auto', 1),
	('auto', 2),
	('auto', 3),
	('auto', 4),
	('auto', 5),
	('auto', 6),
	('auto', 7),
	('auto', 8);

insert into rocket_weapon(type_, power_, check_date)
values
	('Bohdan', 1500, '1918-01-01'),
	('M-8',    2000, '1943-01-01'),
	('S-30B',  1800, '1945-01-01'),
	('Bohdan', 3000, '1990-01-01'),
	('B-8',     300, '1970-01-01'),
	('BFG-Ar', 9999, '1971-01-01'),
	('Bohdan', 1000, '1950-01-01'),
	('D-12',   5600, '1991-01-01');

insert into resource_spec(resource_type, bmp_id)
values
	('rocket', 1),
	('rocket', 2),
	('rocket', 3),
	('rocket', 4),
	('rocket', 5),
	('rocket', 6),
	('rocket', 7),
	('rocket', 8);

-- resources specs relations

insert into resource(spec, type_, name_)
values
	( 1, 'transport', 'transport1'),
	( 2, 'transport', 'transport2'),
	( 3, 'transport', 'transport3'),
	( 4, 'transport', 'transport4'),
	( 5, 'transport', 'transport5'),
	( 6, 'transport', 'transport6'),
	( 7, 'transport', 'transport7'),
	( 8, 'transport', 'transport8'),
	( 9, 'transport', 'transport9'),
	(10, 'transport', 'transport10'),
	(11, 'transport', 'transport11'),
	(12, 'transport', 'transport12'),
	(13, 'transport', 'transport13'),
	(14, 'transport', 'transport14'),
	(15, 'transport', 'transport15'),
	(16, 'transport', 'transport16'),
	(17, 'weapon', 'weapon1'),
	(18, 'weapon', 'weapon2'),
	(19, 'weapon', 'weapon3'),
	(20, 'weapon', 'weapon4'),
	(21, 'weapon', 'weapon5'),
	(22, 'weapon', 'weapon6'),
	(23, 'weapon', 'weapon7'),
	(24, 'weapon', 'weapon8'),
	(25, 'weapon', 'weapon9'),
	(26, 'weapon', 'weapon10'),
	(27, 'weapon', 'weapon11'),
	(28, 'weapon', 'weapon12'),
	(29, 'weapon', 'weapon13'),
	(30, 'weapon', 'weapon14'),
	(31, 'weapon', 'weapon15'),
	(32, 'weapon', 'weapon16');

-- dislocations

insert into dislocation(country, county, living_point, distinct_)
values
	('Ukraine', 'Kyiv',       'Kyiv',     'Shevchenko'),
	('Ukraine', 'Kriviy rig', 'XYZ',      'Pares'),
	('Ukraine', 'Kyiv',       'Kyiv',     'Dnepro'),
	('Ukraine', 'Kriviy rig', 'Peregmon', 'Usa'),
	('Ukraine', 'Kyiv',       'Kyiv',     'Kreshatik'),
	('Ukraine', 'Kriviy rig', 'Zvavo',    'Chani');

-- military units

insert into distinct_military_unit(name_)
values
	('Tretya Sh B'),
	('Dronivsk'),
	('Patrioti');

-- distinct military units

insert into military_unit(distinct_military_unit, name_)
values
	(1, 'Takin'),
	(1, 'Pagamont'),
	(2, 'Vdacha'),
	(2, 'Tato'),
	(3, 'Najkrashi'),
	(3, 'Kruti');

-- resources relations

insert into resource_military_unit(military_unit_id, resource_id)
values
	(1,  1),
	(2,  2),
	(3,  3),
	(4,  4),
	(5,  5),
	(6,  6),
	(1,  7),
	(2,  8),
	(3,  9),
	(4, 10),
	(5, 11),
	(6, 12),
	(1, 13),
	(2, 14),
	(3, 15),
	(4, 16),
	(5, 17),
	(6, 18),
	(1, 19),
	(2, 20),
	(3, 21),
	(4, 22),
	(5, 23),
	(6, 24),
	(1, 25),
	(2, 26),
	(3, 27),
	(4, 28),
	(5, 29),
	(6, 30),
	(1, 31),
	(2, 32);

-- ranks datas

insert into rank_data(
	rank_setting_date,
	deferment_data,
	military_training_building_name,
	military_training_start_date,
	military_training_finish_date,
	injuries_data
)
values
	('2024-01-01', 'unknown', 'KPI', '2021-01-01', '2025-01-01', 'no'),
	('2023-01-01', 'unknown', 'KPI', '2022-01-01', '2026-01-01', 'yes'),
	('2025-01-01', 'unknown', 'KPI', '2023-01-01', '2022-01-01', 'no'),
	('2022-01-01', 'unknown', 'KPI', '2021-01-01', '2026-01-01', 'no'),
	('2023-01-01', 'unknown', 'KPI', '2023-01-01', '2025-01-01', 'unknown'),
	('2024-01-01', 'unknown', 'KPI', '2022-01-01', '2022-01-01', 'no'),
	('2025-01-01', 'unknown', 'KPI', '2021-01-01', '2026-01-01', 'unknown'),
	('2025-01-01', 'unknown', 'KPI', '2021-01-01', '2027-01-01', 'yes'),
	('2024-01-01', 'unknown', 'KPI', '2023-01-01', '2026-01-01', 'yes'),
	('2025-01-01', 'unknown', 'KPI', '2022-01-01', '2022-01-01', 'yes'),
	('2023-01-01', 'unknown', 'KPI', '2022-01-01', '2022-01-01', 'unknown'),
	('2024-01-01', 'unknown', 'KPI', '2023-01-01', '2026-01-01', 'yes'),
	('2021-01-01', 'unknown', 'KPI', '2021-01-01', '2027-01-01', 'unknown'),
	('2023-01-01', 'unknown', 'KPI', '2022-01-01', '2022-01-01', 'yes'),
	('2025-01-01', 'unknown', 'KPI', '2023-01-01', '2026-01-01', 'yes'),
	('2024-01-01', 'unknown', 'KPI', '2021-01-01', '2027-01-01', 'yes'),
	('2021-01-01', 'unknown', 'KPI', '2023-01-01', '2022-01-01', 'unknown'),
	('2022-01-01', 'unknown', 'KPI', '2022-01-01', '2022-01-01', 'yes'),
	('2024-01-01', 'unknown', 'KPI', '2021-01-01', '2027-01-01', 'yes'),
	('2021-01-01', 'unknown', 'KPI', '2021-01-01', '2022-01-01', 'yes'),
	('2022-01-01', 'unknown', 'KPI', '2022-01-01', '2027-01-01', 'unknown'),
	('2021-01-01', 'unknown', 'KPI', '2023-01-01', '2025-01-01', 'no'),
	('2023-01-01', 'unknown', 'KPI', '2022-01-01', '2026-01-01', 'no');

-- serviceman

insert into serviceman(fio, birth_date, rank_, rank_data_id)
values
	('Arsen',   '2006-01-01', 'general',       1),
	('Denys',   '2007-01-01', 'private',         2),
	('Loleps',  '2005-01-01', 'private',         3),
	('Mia',     '2006-01-01', 'private',       4),
	('Piata',   '2004-01-01', 'flagman',       5),
	('Danya',   '2008-01-01', 'krutoi paren',  6),
	('Popov',   '2006-01-01', 'private',         7),
	('Vadim',   '2007-01-01', 'commander',       8),
	('Andrii',  '2003-01-01', 'flagman',       9),
	('Olena',   '2002-01-01', 'private',      10),
	('Vladik',  '2006-01-01', 'private',      11),
	('Braga',   '2006-01-01', 'krutoi paren', 12),
	('Borya',   '2007-01-01', 'flagman',      13),
	('Ilya',    '2008-01-01', 'private',        14),
	('Maksik',  '2005-01-01', 'general',        15),
	('Dmitro',  '2006-01-01', 'private',      16),
	('Yarik',   '2005-01-01', 'flagman',      17),
	('Kolya',   '2003-01-01', 'private', 18),
	('Sasha',   '2006-01-01', 'private',      19),
	('Derii',   '2005-01-01', 'flagman',      20),
	('KPI',     '2006-01-01', 'private',      21),
	('Anas.',   '2003-01-01', 'private',        22),
	('FictBot', '2000-01-01', 'flagman', 23);

-- specialities

insert into speciality(description, shortened_data)
values
	('Sniper',   'defmeviijewfierike'),
	('Engineer', 'qwefrejnjmefertycr'),
	('Medic',    'rtebryersdertyfjrujrv'),
	('Mechanic', 'furhyfttfhcegrcrnjvr'),
	('Gunner',   'erjuvrttefrujerji'),
	('Spy',      'efhnhrehhuefruer');

-- serviceman affiliation

insert into serviceman_affiliation(serviceman_id, is_commander, unit_id, unit_type)
values
	( 1, true,  1, 'distinct_military_unit'),
	( 2, false, 2, 'military_unit'),
	( 3, false, 3, 'military_unit'),
	( 4, false, 1, 'military_unit'),
	( 5, false, 2, 'military_unit'),
	( 6, false, 3, 'military_unit'),
	( 7, false, 1, 'military_unit'),
	( 8, true,  2, 'distinct_military_unit'),
	( 9, false, 3, 'military_unit'),
	(10, false, 1, 'military_unit'),
	(11, false, 2, 'military_unit'),
	(12, false, 3, 'military_unit'),
	(13, false, 1, 'military_unit'),
	(14, false, 2, 'military_unit'),
	(15, true,  3, 'distinct_military_unit'),
	(16, false, 1, 'military_unit'),
	(17, false, 2, 'military_unit'),
	(18, false, 3, 'military_unit'),
	(19, false, 1, 'military_unit'),
	(20, false, 2, 'military_unit'),
	(21, false, 3, 'military_unit'),
	(22, false, 1, 'military_unit'),
	(23, false, 2, 'military_unit');

-- specialities relations

insert into serviceman_speciality(serviceman_id, speciality_id)
values
	( 1, 2),
	-------
	( 2, 3),
	( 2, 2),
	-------
	( 3, 4),
	-------
	( 4, 1),
	-------
	( 5, 2),
	-------
	( 6, 5),
	( 6, 4),
	-------
	( 7, 2),
	-------
	( 8, 6),
	-------
	( 9, 1),
	-------
	(10, 4),
	(10, 1),
	(10, 2),
	-------
	(11, 1),
	-------
	(12, 6),
	-------
	(13, 2),
	-------
	(14, 5),
	(14, 4),
	-------
	(15, 1),
	-------
	(16, 2),
	-------
	(17, 5),
	-------
	(18, 6),
	-------
	(19, 1),
	-------
	(20, 4),
	-------
	(21, 3),
	(21, 5),
	(21, 4),
	(21, 2),
	-------
	(22, 6),
	-------
	(23, 3);

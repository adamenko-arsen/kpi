-- SECTION: Створити запити для вибірки даних з використанням (разом 8 запитів)

-- 1: Отримати всіх військових, в кого ID більше 50

--select * from serviceman
--where id_ > 50;

-- Task 2: Отримати всіх військових, в кого нема 18 років

--select * from serviceman
--where AGE(CURRENT_DATE, birth_date) < '18 year';

-- Task 3: Отримати всі ID спецільностей, якщо ID військового це 50

--select speciality_id from serviceman_speciality
--where serviceman_id = 80;

-- Task 4: Отримати всіх військових в кого дата народження молодша 2004 року та має ФІО більше 16 або його ранг це путін

--select * from serviceman
--where (length(fio) > 16 or rank_ = 'putin') and birth_date > '2004-01-01';

-- Task 5: Отримати всі дані про ранги якщо дата військових навчань не була почата, але є інформація про відстрочку

--select * from rank_data where military_training_start_date = null and deferment_data != null;

-- Task 6: Отримати всіх військових по полям ID, з фіо з принизливими афексами, а також зробити дні народження на 32 роки старшими

--select id_, 'YA GOVNO ' || fio || ', TAK TOCHNO' as fio, birth_date - interval '32 year' as pizdato_birth_date, zrada_info as birth_date
--from serviceman;

-- Task 7: Отримати всіх військових по полям ID, ФІО, дата рангу, "крутість" (є дані про ранг) якщо ранг це путін

--select id_, fio, rank_data_id, rank_data_id is not null as is_krutoi
--from serviceman where rank_ = 'putin';

-- Task 8: Отримати всіх військових по полям ID, ФІО, інформацію про зраду якщо в ФІО є підстрока денис та інформація про ранг не є відсутньою

--select id_, fio, zrada_info from serviceman
--where fio ~ 'denys' and rank_data_id is null;

/*
select * from serviceman
where fio ~ 'loleps' or fio ~ 'arsen';
--*/

-- SECTION: Створити запити з використанням підзапитів та з’єднань (разом 11 запитів) (в запитах повинні використовуватись 2 та більше таблиць)

-- Task 1: Отримати кількість спеціальностей кожного військовослужбовця

/*
select sm.id_, sm.fio
from serviceman sm
where exists (
    select 1
    from serviceman_speciality ss
    where ss.serviceman_id = sm.id_
);
--*/

-- Task 2: Отримати кількість підрозділів, де є всі військовослужбовці

/*
select sm.id_, sm.fio, (
	select count(*)
	from serviceman_speciality ss 
	where ss.serviceman_id = sm.id_
) as specialty_count
from serviceman sm;
--*/

-- Task 3: Вибирає усіх солдатів, що належать до військових частин, де є хоча б один командир

/*
select id_, fio, birth_date
from serviceman sm
join serviceman_affiliation sa on sm.id_ = sa.serviceman_id
where unit_id in (
	select id_
	from military_unit mu
	join serviceman_affiliation sa on mu.id_ = sa.unit_id
	where sa.is_commander = true
);
--*/

-- Task 4: Обирає всіх військових та всі їхні спецільності

/*
select s.fio, sp.description
form serviceman s
join serviceman_speciality ss on ss.serviceman_id = s.id_
join speciality sp on sp.id_ = ss.speciality_id;
--*/

-- Task 5: Декартовий добуток всіх популбованих військових частин та військових, що належатать лише до ВЧ, де є військові

/*
select mu.name_, s.fio
from military_unit mu
right join serviceman_affiliation sa on sa.unit_id = mu.id_
right join serviceman s on s.id_ = sa.serviceman_id;
--*/

-- Task 6: Вибів військових з підрозділів, де є командири, що використовують певні живі ресурси

/*
select s.fio
from serviceman s
where s.id_ IN (
    select sa.serviceman_id
    from serviceman_affiliation sa
    join military_unit mu on mu.id_ = sa.unit_id
    join resource_military_unit rm on rm.military_unit_id = mu.id_
    where sa.is_commander = true
)
intersect
select s.fio
from serviceman s
join serviceman_speciality ss on ss.serviceman_id = s.id_
join speciality sp on sp.id_ = ss.speciality_id
where sp.description in ('Sniper', 'Spy');
--*/

-- Task 7: Вибір усіх солдатів, які належать до військових частин, і інформації про ці частини

/*
select s.fio, mu.name_ as military_unit_name
from serviceman s
inner join serviceman_affiliation sa on sa.serviceman_id = s.id_
inner join military_unit mu on mu.id_ = sa.unit_id;
--*/

-- Task 8: Вид зброї та хто може мати доступ до озброєння

/*
select fio as name_, 'serviceman' as type
from serviceman
where rank_ = 'private'
	union
		select name_ AS name_, 'Resource' AS type
		from resource
		where type_ = 'artillery';
--*/

-- Task 9: Комбінація усіх ресурсів та військових частин

/*
select mu.name_ as military_unit_name, r.name_ as resource_name
from military_unit mu
cross join resource r;
--*/

-- Task 10:

/*
select
	mu.name_ as military_unit_name,
	r.name_ as resource_name
from resource r
join resource_military_unit rmu on r.id_ = rmu.resource_id
join military_unit mu on rmu.military_unit_id = mu.id_;
--*/

-- Task 11:

/*
select mu.name_ as military_unit_name
from military_unit mu
where exists (
    select 1
    from resource_military_unit rmu
    join resource r on rmu.resource_id = r.id_
    where r.type_ = 'weapon' and rmu.military_unit_id = mu.id_
);
--*/

-- SECTION: Створити запити за словесним описом, наведеним в завданні згідно варіанту.

-- Task: main

-- Description:

-- Треба мати можливість отримувати інформацію про всі
-- частини військового округу, дані про офіцерський,
-- рядовий та сержантський склад, отримувати місця
-- дислокації, дані про наявне озброєння тощо.

-- Code:

/*
select
	dmu.name_ as distinct_military_unit_name,
	mu.name_ as military_unit_name,

	sm.fio as commander_fio,
	sm.birth_date,
	sm.rank_ as commander_rank,

	(
		select
		count(*)
		from resource r
		join resource_military_unit rmu on r.id_ = rmu.resource_id
		where rmu.military_unit_id = mu.id_
	) as resources_count,

	rd.rank_setting_date,
	rd.deferment_data,
	rd.injuries_data
from
	distinct_military_unit dmu
join
	military_unit mu on dmu.id_ = mu.distinct_military_unit
join
	serviceman_affiliation sa on dmu.id_ = sa.unit_id
join
	serviceman sm on sa.serviceman_id = sm.id_
join
	rank_data rd on sm.rank_data_id = rd.id_
where
	sa.is_commander = true
order
	by dmu.name_ asc, mu.name_ asc;
*/

-- Task: a

-- Description:

-- Визначить всі частини певного військового округу, котрі мають в
-- наявному озброєнні БМП.

-- Code:

/*
select
	mu.name_ as military_unit_name,
	(
		select
			count(*)
		from
			resource_spec rs
		join
			resource r on r.spec = rs.id_
		join
			resource_military_unit rmu on rs.id_ = rmu.resource_id
		where
			rmu.military_unit_id = mu.id_
	)
from
	military_unit mu
join
	resource_military_unit rmu on mu.id_ = rmu.military_unit_id
join
	resource r on rmu.resource_id = r.id_
join
	resource_spec rs on r.spec = rs.id_
where
	rs.resource_type = 'bmp';
--*/

-- Task: b

-- Description:

-- Визначить військові підрозділи, котрими командують офіцери
-- щонайменше зі званням підполковника.

-- Code:

--/*
select
	sm.fio as commander_fio,
	unit.type_ as unit_type
from
	(
		(
			select
				'army' as type_,
				name_,
				id_
			from
				army
		)
		union
		(
			select
				'distinct_military_units_union' as type_,
				name_,
				id_
			from
				distinct_military_units_union
		)
		union
		(
			select
				'distinct_military_unit' as type_,
				name_,
				id_
			from
				distinct_military_unit
		)
		union
		(
			select
				'military_unit' as type_,
				name_,
				id_
			from
				military_unit
		)
	) unit
join
	serviceman_affiliation sa on unit.id_ = sa.unit_id
join
	serviceman sm on sa.serviceman_id = sm.id_
where
		sa.is_commander = true
	and
		sm.rank_ in (
			'private', 'flagman', 'putin',
			'generals', 'colonels', 'lieutenant colonels'
		)
	and
		text(sa.unit_type) = text(unit.type_);
--*/

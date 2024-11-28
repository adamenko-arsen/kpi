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

-- Task 2: FAIL

/*
select id_, avg_power 
from (
    select id_, avg(power_) as avg_power
    from rocket_weapon
    group by id_
) as avg_rocket;
--*/

-- Task 3:

/*
select sm.id_, sm.fio, (
	select count(*)
	from serviceman_speciality ss 
	where ss.serviceman_id = sm.id_
) as specialty_count
from serviceman sm;
--*/

-- Task 4:

-- Task 5:

-- Task 6:

-- Task 7:

-- Task 8:

-- Task 9:

-- Task 10:

-- Task 11:

-- SECTION: Створити запити за словесним описом, наведеним в завданні згідно варіанту.

-- Description:

-- Треба мати можливість отримувати інформацію про всі
-- частини військового округу, дані про офіцерський,
-- рядовий та сержантський склад, отримувати місця
-- дислокації, дані про наявне озброєння тощо.

-- Code:

-- SECTION: CREATE ALL TABLES

-- SECTION: DROP ALL TABLES

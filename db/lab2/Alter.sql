alter table serviceman add constraint unique_fio unique (fio);

alter table rank_data rename column rank_setting_date to rank_acquirement_data;

alter table serviceman add column is_zrada bool;

alter table serviceman
	rename column is_zrada to zrada_info,
	alter column zrada_info type varchar(24);

create table godness(id_ serial primary key, is_god varchar(16));

alter table godness rename to is_god;

drop table is_god;

alter table dislocation add column country varchar(64);

alter table serviceman alter column zrada_info varchar(255);

alter table rank_data drop column injuries_data;

-- roles

create role flagman_role;

grant all privilegies on table serviceman to flagman_role;

create role commander_role;

grant select, insert, update on military_unit				to commander_role;
grant select, insert, update on distinct_military_unit		to commander_role;
grant select, insert, update on resource_militaty_unit		to commander_role;
grant select, insert, update on company					to commander_role;
grant select, insert, update on platoon					to commander_role;
grant select, insert, update on department					to commander_role;
grant select, insert, update on serviceman_affiliation		to commander_role;
grant select, insert, update on serviceman					to commander_role;

create role general_role;

grant all privilegies on table military_units_union	to general_role;
grant all privilegies on table military_unit 			to general_role;
grant all privilegies on table serviceman				to general_role;
grant all privilegies on table rank_data				to general_role;
grant all privilegies on table speciality				to general_role;

-- users

create user flagman_user with password 'putin_huilo';
	grant flagman_user to flagman_role;

create user commander_user with password 'dva_stula';
	grant commander_user to commander_role;

create user general_user with password 'za_zelenskoho';
	grant general_user to general_role;

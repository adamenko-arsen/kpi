-- different kinds of weapon

create table rocket_weapon(
	id_			serial primary key,
	type_		varchar(24) not null,
	power_		real not null,
	check_date	date not null,
);

create table artillery_weapon(
	id_			serial primary key,
	type_		varchar(24) not null,
	fire_dist	real not null,
	check_date	date not null,
);

create table auto_weapon(
	id_			serial primary key,
	type_		varchar(24) not null,
	fire_rate	real not null,
	check_date	date not null,
);

create table carabine_weapon(
	id_			serial primary key,
	type_		varchar(24) not null,
	check_date	date not null,
);

-- different kinds of transport

create table wagon_transport(
	id_			serial primary key,
	type_		varchar(24) not null,
	crews_count	int not null,
	check_date	date not null,
);

create table bmp_transport(
	id_			serial primary key,
	crews_count	int not null,
	check_date	date not null,
);

create table light_transport(
	id_			serial primary key,
	check_date	date not null,
);

-- different kinds of resource

create table resource_spec(
	id_				serial primary key,
	table_type_		enum(
		'unknown',
		'rocket',
		'artillery',
		'auto',
		'carabine',
		'wagon',
		'bmp',
		'light_transport'
	) not null,

	rocket_id			int foreign rocket_weapon			(id_),
	artillery_id		int foreign artillery_weapon		(id_),
	auto_id				int foreign auto_weapon				(id_),
	carabine_id			int foreign carabine_weapon			(id_),
	wagon_id			int foreign wagon_weapon			(id_),
	bmp_id				int foreign bmp_weapon				(id_),
	light_transport_id	int foreign light_transport_weapon	(id_),
);

create table resource(
	id_		serial primary key,
	name_	varchar(32) not null,
	type_	varchar(24) not null,
	spec	int references resource_spec(id_),
);

create table resource_militaty_unit(
	primary key (resource_id, militaty_unit_id),
	resource_id			int references resource			(id_) on delete cascade,
	militaty_unit_id	int references military_unit	(id_) on delete cascade,
);

-- dislocation implementation

create table gps_coordinate(
	id_			serial primary key,
	hozizontal	real not null,
	vertical	real not null,
	height		real not null
);

create table dislocation(
	county			varchar(32) not null,
	living_point	varchar(32) not null,
	distinct_		varchar(32) not null,
	gps_coord		int references gps_coordinate(id_),
);

-- serviceman implementation

create table serviceman_speciality(
	primary key (serviceman_id, speciality_id),
	serviceman_id int references serviceman(id_),
	speciality_id int references speciality(id_),
);

create table serviceman(
	id_				serial primary key,
	fio				varchar(64) not null,
	birth_date		date not null,
	rank_			varchar(32) not null,
	rank_data_id	int references rank_data(id_)
);

create table speciality(
	id_				serial primary key,
	description		varchar(64) not null,
	shortened_data	varchar(128) not null,
);

create table rank_data(
	martial_academy_finish_date			date,
	rank_setting_date					date,
	academy_finish_date					date,
	deferment_data						varchar(32),
	military_training_building_name	varchar(128),
	military_training_start_date		date,
	military_training_finish_date		date,
	injuries_data						varchar(64),
);

create table serviceman_affiliation(
	primary key (serviceman_id, unit_id),
	serviceman_id	int references serviceman	(id_) on delete cascade,
	unit_id			int references unit			(id_) on delete cascade,
	is_commander	bool,
);

-- military units

create table department(
	id_		serial primary key,
	name_	varchar(32) not null,
	platoon	int references platoon(id_),
);

create table platoon(
	id_		serial primary key,
	name_	varchar(42) not null,
	company	int references company(id_),
);

create table company(
	id_						serial primary key,
	name_					varchar(56) not null,
	distinct_military_unit	int references distinct_military_unit(id_),
);

create table distinct_military_unit(
	id_				serial primary key,
	name_			varchar(32) not null,
	military_unit	int references military_unit(id_),
);

create table military_unit(
	id_						serial primary key,
	name_					varchar(64),
	military_units_union	int references military_units_union(id_),
);

create table military_units_union(
	id_		serial primary key,
	name_	varchar(96),
	army	int references army(id_),
);

create table army(
	id_		serial primary key,
	name_	varchar(128),
);

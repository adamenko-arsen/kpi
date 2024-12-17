-- different kinds of weapon

CREATE TABLE rocket_weapon (
    id_         SERIAL PRIMARY KEY,
    type_       VARCHAR(24) NOT NULL,
    power_      REAL NOT NULL,
    check_date  DATE NOT NULL
);

CREATE TABLE artillery_weapon (
    id_         SERIAL PRIMARY KEY,
    type_       VARCHAR(24) NOT NULL,
    fire_dist   REAL NOT NULL,
    check_date  DATE NOT NULL
);

CREATE TABLE auto_weapon (
    id_         SERIAL PRIMARY KEY,
    type_       VARCHAR(24) NOT NULL,
    fire_rate   REAL NOT NULL,
    check_date  DATE NOT NULL
);

CREATE TABLE carabine_weapon (
    id_         SERIAL PRIMARY KEY,
    type_       VARCHAR(24) NOT NULL,
    check_date  DATE NOT NULL
);

-- different kinds of transport

CREATE TABLE wagon_transport (
    id_         SERIAL PRIMARY KEY,
    type_       VARCHAR(24) NOT NULL,
    crews_count INT NOT NULL,
    check_date  DATE NOT NULL
);

CREATE TABLE bmp_transport (
    id_         SERIAL PRIMARY KEY,
    crews_count INT NOT NULL,
    check_date  DATE NOT NULL
);

CREATE TABLE light_transport (
    id_         SERIAL PRIMARY KEY,
    check_date  DATE NOT NULL
);

-- different kinds of resource

CREATE TYPE resource_type_enum AS ENUM(
	'unknown', 'rocket', 'artillery',
	'auto', 'carabine', 'wagon',
	'bmp', 'light_transport'
);

CREATE TABLE resource_spec (
    id_                  SERIAL PRIMARY KEY,
    resource_type        resource_type_enum NOT NULL,
    rocket_id            INT REFERENCES rocket_weapon(id_),
    artillery_id         INT REFERENCES artillery_weapon(id_),
    auto_id              INT REFERENCES auto_weapon(id_),
    carabine_id          INT REFERENCES carabine_weapon(id_),
    wagon_id             INT REFERENCES wagon_transport(id_),
    bmp_id               INT REFERENCES bmp_transport(id_),
    light_transport_id   INT REFERENCES light_transport(id_)
);

CREATE TABLE resource (
    id_     SERIAL PRIMARY KEY,
    name_   VARCHAR(32) NOT NULL,
    type_   VARCHAR(24) NOT NULL,
    spec    INT REFERENCES resource_spec(id_)
);

-- dislocation implementation

CREATE TABLE gps_coordinate (
    id_        SERIAL PRIMARY KEY,
    horizontal REAL NOT NULL,
    vertical   REAL NOT NULL,
    height     REAL NOT NULL
);

CREATE TABLE dislocation (
	id_							SERIAL PRIMARY KEY,
	country        VARCHAR(48) NOT NULL,
    county         VARCHAR(32) NOT NULL,
    living_point   VARCHAR(32) NOT NULL,
    distinct_      VARCHAR(32) NOT NULL,
    gps_coord      INT REFERENCES gps_coordinate(id_)
);

-- serviceman implementation

CREATE TABLE rank_data (
	id_							SERIAL PRIMARY KEY,
    martial_academy_finish_date  DATE,
    rank_setting_date           DATE,
    academy_finish_date         DATE,
    deferment_data              VARCHAR(32),
    military_training_building_name VARCHAR(128),
    military_training_start_date DATE,
    military_training_finish_date DATE,
    injuries_data              VARCHAR(64)
);

CREATE TABLE serviceman (
    id_           SERIAL PRIMARY KEY,
    fio           VARCHAR(64) NOT NULL,
    birth_date    DATE NOT NULL,
    rank_         VARCHAR(32) NOT NULL,
    rank_data_id  INT REFERENCES rank_data(id_),
	zrada_info    VARCHAR(255)
);

CREATE TABLE speciality (
    id_            SERIAL PRIMARY KEY,
    description    VARCHAR(64) NOT NULL,
    shortened_data VARCHAR(128) NOT NULL
);

-- military units

CREATE TABLE army (
    id_    SERIAL PRIMARY KEY,
    name_  VARCHAR(128)
);

CREATE TYPE distinct_military_units_union_type AS ENUM(
	'division', 'corp', 'brigade'
);


CREATE TABLE distinct_military_units_union (
    id_    SERIAL PRIMARY KEY,
    name_  VARCHAR(96),
	type_  distinct_military_units_union_type,
    army   INT REFERENCES army(id_)
);

CREATE TABLE distinct_military_unit (
    id_            SERIAL PRIMARY KEY,
    name_          VARCHAR(32) NOT NULL,
    distinct_military_units_union  INT REFERENCES distinct_military_units_union(id_)
);

CREATE TABLE military_unit (
    id_                  SERIAL PRIMARY KEY,
    name_                VARCHAR(64),
    distinct_military_unit INT REFERENCES distinct_military_unit(id_)
);

CREATE TABLE company (
    id_                      SERIAL PRIMARY KEY,
    name_                    VARCHAR(56) NOT NULL,
    military_unit   INT REFERENCES military_unit(id_)
);

CREATE TABLE platoon (
    id_      SERIAL PRIMARY KEY,
    name_    VARCHAR(42) NOT NULL,
    company  INT REFERENCES company(id_)
);

CREATE TABLE department (
    id_       SERIAL PRIMARY KEY,
    name_     VARCHAR(32) NOT NULL,
    platoon   INT REFERENCES platoon(id_)
);

-- servicemen, military distinct units, resources relations

CREATE TYPE unit_type AS ENUM (
	'department', 'platoon', 'company',
	'distinct_military_unit', 'military_unit',
	'distinct_military_units_union', 'army'
);

CREATE TABLE serviceman_affiliation (
    serviceman_id INT REFERENCES serviceman(id_) ON DELETE CASCADE,
    unit_id       INT,
	unit_type     unit_type,
    is_commander  BOOLEAN,
    PRIMARY KEY (serviceman_id, unit_id)
);

CREATE TABLE serviceman_speciality (
    serviceman_id INT REFERENCES serviceman(id_),
    speciality_id INT REFERENCES speciality(id_),
    PRIMARY KEY (serviceman_id, speciality_id)
);

CREATE TABLE resource_military_unit (
    resource_id      INT REFERENCES resource(id_) ON DELETE CASCADE,
    military_unit_id INT REFERENCES military_unit(id_) ON DELETE CASCADE,
    PRIMARY KEY (resource_id, military_unit_id)
);

CREATE TABLE military_unit_dislocation (
    military_unit_id      INT REFERENCES resource(id_) ON DELETE CASCADE,
    dislocation_id                  INT REFERENCES military_unit(id_) ON DELETE CASCADE,
    PRIMARY KEY (dislocation_id, military_unit_id)
);

DROP TABLE IF EXISTS serviceman_speciality CASCADE;
DROP TABLE IF EXISTS resource_military_unit CASCADE;
DROP TABLE IF EXISTS resource_spec CASCADE;
DROP TABLE IF EXISTS resource CASCADE;
DROP TABLE IF EXISTS serviceman_affiliation CASCADE;
DROP TABLE IF EXISTS dislocation CASCADE;
DROP TABLE IF EXISTS gps_coordinate CASCADE;
DROP TABLE IF EXISTS serviceman CASCADE;
DROP TABLE IF EXISTS rank_data CASCADE;
DROP TABLE IF EXISTS speciality CASCADE;
DROP TABLE IF EXISTS unit CASCADE;
DROP TABLE IF EXISTS army CASCADE;
DROP TABLE IF EXISTS distinct_military_units_union CASCADE;
DROP TABLE IF EXISTS distinct_military_unit CASCADE;
DROP TABLE IF EXISTS military_unit CASCADE;
DROP TABLE IF EXISTS military_unit_dislocation CASCADE;
DROP TABLE IF EXISTS company CASCADE;
DROP TABLE IF EXISTS platoon CASCADE;
DROP TABLE IF EXISTS department CASCADE;

-- Drop weapon and transport tables
DROP TABLE IF EXISTS rocket_weapon CASCADE;
DROP TABLE IF EXISTS artillery_weapon CASCADE;
DROP TABLE IF EXISTS auto_weapon CASCADE;
DROP TABLE IF EXISTS carabine_weapon CASCADE;
DROP TABLE IF EXISTS wagon_transport CASCADE;
DROP TABLE IF EXISTS bmp_transport CASCADE;
DROP TABLE IF EXISTS light_transport CASCADE;

-- Drop any remaining tables
DROP TABLE IF EXISTS army CASCADE;

DROP TYPE IF EXISTS resource_type_enum CASCADE;
DROP TYPE IF EXISTS unit_type CASCADE;
DROP TYPE IF EXISTS distinct_military_units_union_type CASCADE;

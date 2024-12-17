--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

-- Started on 2024-11-20 15:43:41

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 16388)
-- Name: pgagent; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgagent;


ALTER SCHEMA pgagent OWNER TO postgres;

--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA pgagent; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';


--
-- TOC entry 2 (class 3079 OID 16389)
-- Name: pgagent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;


--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgagent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';


--
-- TOC entry 975 (class 1247 OID 18290)
-- Name: resource_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.resource_type AS ENUM (
    'unknown',
    'rocket',
    'artillery',
    'auto',
    'carabine',
    'wagon',
    'bmp',
    'light_transport'
);


ALTER TYPE public.resource_type OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 239 (class 1259 OID 18162)
-- Name: army; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.army (
    id_ integer NOT NULL,
    name_ character varying(128)
);


ALTER TABLE public.army OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 18161)
-- Name: army_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.army_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.army_id__seq OWNER TO postgres;

--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 238
-- Name: army_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.army_id__seq OWNED BY public.army.id_;


--
-- TOC entry 255 (class 1259 OID 18248)
-- Name: artillery_weapon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artillery_weapon (
    id_ integer NOT NULL,
    type_ character varying(24) NOT NULL,
    fire_dist real NOT NULL,
    check_date date NOT NULL
);


ALTER TABLE public.artillery_weapon OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 18247)
-- Name: artillery_weapon_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.artillery_weapon_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artillery_weapon_id__seq OWNER TO postgres;

--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 254
-- Name: artillery_weapon_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.artillery_weapon_id__seq OWNED BY public.artillery_weapon.id_;


--
-- TOC entry 257 (class 1259 OID 18255)
-- Name: auto_weapon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auto_weapon (
    id_ integer NOT NULL,
    type_ character varying(24) NOT NULL,
    fire_rate real NOT NULL,
    check_date date NOT NULL
);


ALTER TABLE public.auto_weapon OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 18254)
-- Name: auto_weapon_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auto_weapon_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auto_weapon_id__seq OWNER TO postgres;

--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 256
-- Name: auto_weapon_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auto_weapon_id__seq OWNED BY public.auto_weapon.id_;


--
-- TOC entry 263 (class 1259 OID 18276)
-- Name: bmp_transport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bmp_transport (
    id_ integer NOT NULL,
    crews_count integer NOT NULL,
    check_date date NOT NULL
);


ALTER TABLE public.bmp_transport OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 18275)
-- Name: bmp_transport_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bmp_transport_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bmp_transport_id__seq OWNER TO postgres;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 262
-- Name: bmp_transport_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bmp_transport_id__seq OWNED BY public.bmp_transport.id_;


--
-- TOC entry 259 (class 1259 OID 18262)
-- Name: carabine_weapon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carabine_weapon (
    id_ integer NOT NULL,
    type_ character varying(24) NOT NULL,
    check_date date NOT NULL
);


ALTER TABLE public.carabine_weapon OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 18261)
-- Name: carabine_weapon_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.carabine_weapon_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.carabine_weapon_id__seq OWNER TO postgres;

--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 258
-- Name: carabine_weapon_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carabine_weapon_id__seq OWNED BY public.carabine_weapon.id_;


--
-- TOC entry 247 (class 1259 OID 18205)
-- Name: company; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company (
    id_ integer NOT NULL,
    name_ character varying(56) NOT NULL,
    distinct_military_unit integer
);


ALTER TABLE public.company OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 18204)
-- Name: company_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.company_id__seq OWNER TO postgres;

--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 246
-- Name: company_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_id__seq OWNED BY public.company.id_;


--
-- TOC entry 251 (class 1259 OID 18229)
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    id_ integer NOT NULL,
    name_ character varying(32) NOT NULL,
    platoon integer
);


ALTER TABLE public.department OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 18228)
-- Name: department_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.department_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.department_id__seq OWNER TO postgres;

--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 250
-- Name: department_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.department_id__seq OWNED BY public.department.id_;


--
-- TOC entry 274 (class 1259 OID 18384)
-- Name: dislocation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dislocation (
    id_ integer NOT NULL,
    county character varying(32) NOT NULL,
    living_point character varying(32) NOT NULL,
    distinct_ character varying(32) NOT NULL,
    gps_coord integer,
    country character varying(64)
);


ALTER TABLE public.dislocation OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 18383)
-- Name: dislocation_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dislocation_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dislocation_id__seq OWNER TO postgres;

--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 273
-- Name: dislocation_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dislocation_id__seq OWNED BY public.dislocation.id_;


--
-- TOC entry 245 (class 1259 OID 18193)
-- Name: distinct_military_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.distinct_military_unit (
    id_ integer NOT NULL,
    name_ character varying(32) NOT NULL,
    military_unit integer
);


ALTER TABLE public.distinct_military_unit OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 18192)
-- Name: distinct_military_unit_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.distinct_military_unit_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.distinct_military_unit_id__seq OWNER TO postgres;

--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 244
-- Name: distinct_military_unit_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.distinct_military_unit_id__seq OWNED BY public.distinct_military_unit.id_;


--
-- TOC entry 272 (class 1259 OID 18377)
-- Name: gps_coordinate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gps_coordinate (
    id_ integer NOT NULL,
    hozizontal real NOT NULL,
    vertical real NOT NULL,
    height real NOT NULL
);


ALTER TABLE public.gps_coordinate OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 18376)
-- Name: gps_coordinate_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gps_coordinate_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gps_coordinate_id__seq OWNER TO postgres;

--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 271
-- Name: gps_coordinate_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gps_coordinate_id__seq OWNED BY public.gps_coordinate.id_;


--
-- TOC entry 265 (class 1259 OID 18283)
-- Name: light_transport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.light_transport (
    id_ integer NOT NULL,
    check_date date NOT NULL
);


ALTER TABLE public.light_transport OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 18282)
-- Name: light_transport_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.light_transport_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.light_transport_id__seq OWNER TO postgres;

--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 264
-- Name: light_transport_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.light_transport_id__seq OWNED BY public.light_transport.id_;


--
-- TOC entry 243 (class 1259 OID 18181)
-- Name: military_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.military_unit (
    id_ integer NOT NULL,
    name_ character varying(64),
    military_units_union integer
);


ALTER TABLE public.military_unit OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 18180)
-- Name: military_unit_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.military_unit_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.military_unit_id__seq OWNER TO postgres;

--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 242
-- Name: military_unit_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.military_unit_id__seq OWNED BY public.military_unit.id_;


--
-- TOC entry 241 (class 1259 OID 18169)
-- Name: military_units_union; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.military_units_union (
    id_ integer NOT NULL,
    name_ character varying(96),
    army integer
);


ALTER TABLE public.military_units_union OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 18168)
-- Name: military_units_union_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.military_units_union_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.military_units_union_id__seq OWNER TO postgres;

--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 240
-- Name: military_units_union_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.military_units_union_id__seq OWNED BY public.military_units_union.id_;


--
-- TOC entry 249 (class 1259 OID 18217)
-- Name: platoon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.platoon (
    id_ integer NOT NULL,
    name_ character varying(42) NOT NULL,
    company integer
);


ALTER TABLE public.platoon OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 18216)
-- Name: platoon_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.platoon_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.platoon_id__seq OWNER TO postgres;

--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 248
-- Name: platoon_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.platoon_id__seq OWNED BY public.platoon.id_;


--
-- TOC entry 276 (class 1259 OID 18448)
-- Name: rank_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rank_data (
    id_ integer NOT NULL,
    martial_academy_finish_date date,
    rank_acquirement_data date,
    academy_finish_date date,
    deferment_data character varying(32),
    military_training_building_name character varying(128),
    military_training_start_date date,
    military_training_finish_date date
);


ALTER TABLE public.rank_data OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 18447)
-- Name: rank_data_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rank_data_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rank_data_id__seq OWNER TO postgres;

--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 275
-- Name: rank_data_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rank_data_id__seq OWNED BY public.rank_data.id_;


--
-- TOC entry 269 (class 1259 OID 18350)
-- Name: resource; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource (
    id_ integer NOT NULL,
    name_ character varying(32) NOT NULL,
    type_ character varying(24) NOT NULL,
    spec integer
);


ALTER TABLE public.resource OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 18349)
-- Name: resource_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resource_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resource_id__seq OWNER TO postgres;

--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 268
-- Name: resource_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resource_id__seq OWNED BY public.resource.id_;


--
-- TOC entry 270 (class 1259 OID 18361)
-- Name: resource_militaty_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_militaty_unit (
    resource_id integer NOT NULL,
    militaty_unit_id integer NOT NULL
);


ALTER TABLE public.resource_militaty_unit OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 18308)
-- Name: resource_spec; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource_spec (
    id_ integer NOT NULL,
    table_type_ public.resource_type NOT NULL,
    rocket_id integer,
    artillery_id integer,
    auto_id integer,
    carabine_id integer,
    wagon_id integer,
    bmp_id integer,
    light_transport_id integer
);


ALTER TABLE public.resource_spec OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 18307)
-- Name: resource_spec_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resource_spec_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resource_spec_id__seq OWNER TO postgres;

--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 266
-- Name: resource_spec_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resource_spec_id__seq OWNED BY public.resource_spec.id_;


--
-- TOC entry 253 (class 1259 OID 18241)
-- Name: rocket_weapon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rocket_weapon (
    id_ integer NOT NULL,
    type_ character varying(24) NOT NULL,
    power_ real NOT NULL,
    check_date date NOT NULL
);


ALTER TABLE public.rocket_weapon OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 18240)
-- Name: rocket_weapon_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rocket_weapon_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rocket_weapon_id__seq OWNER TO postgres;

--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 252
-- Name: rocket_weapon_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rocket_weapon_id__seq OWNED BY public.rocket_weapon.id_;


--
-- TOC entry 278 (class 1259 OID 18455)
-- Name: serviceman; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serviceman (
    id_ integer NOT NULL,
    fio character varying(64) NOT NULL,
    birth_date date NOT NULL,
    rank_ character varying(32) NOT NULL,
    rank_data_id integer,
    zrada_info character varying(255),
    spec_id integer
);


ALTER TABLE public.serviceman OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 18473)
-- Name: serviceman_affiliation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serviceman_affiliation (
    serviceman_id integer NOT NULL,
    military_unit_id integer NOT NULL,
    is_commander boolean
);


ALTER TABLE public.serviceman_affiliation OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 18454)
-- Name: serviceman_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serviceman_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serviceman_id__seq OWNER TO postgres;

--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 277
-- Name: serviceman_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serviceman_id__seq OWNED BY public.serviceman.id_;


--
-- TOC entry 282 (class 1259 OID 18488)
-- Name: serviceman_speciality; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serviceman_speciality (
    serviceman_id integer NOT NULL,
    speciality_id integer NOT NULL
);


ALTER TABLE public.serviceman_speciality OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 18467)
-- Name: speciality; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.speciality (
    id_ integer NOT NULL,
    description character varying(64) NOT NULL,
    shortened_data character varying(128) NOT NULL
);


ALTER TABLE public.speciality OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 18466)
-- Name: speciality_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.speciality_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.speciality_id__seq OWNER TO postgres;

--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 279
-- Name: speciality_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.speciality_id__seq OWNED BY public.speciality.id_;


--
-- TOC entry 261 (class 1259 OID 18269)
-- Name: wagon_transport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wagon_transport (
    id_ integer NOT NULL,
    type_ character varying(24) NOT NULL,
    crews_count integer NOT NULL,
    check_date date NOT NULL
);


ALTER TABLE public.wagon_transport OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 18268)
-- Name: wagon_transport_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wagon_transport_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wagon_transport_id__seq OWNER TO postgres;

--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 260
-- Name: wagon_transport_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wagon_transport_id__seq OWNED BY public.wagon_transport.id_;


--
-- TOC entry 4837 (class 2604 OID 18165)
-- Name: army id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.army ALTER COLUMN id_ SET DEFAULT nextval('public.army_id__seq'::regclass);


--
-- TOC entry 4845 (class 2604 OID 18251)
-- Name: artillery_weapon id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artillery_weapon ALTER COLUMN id_ SET DEFAULT nextval('public.artillery_weapon_id__seq'::regclass);


--
-- TOC entry 4846 (class 2604 OID 18258)
-- Name: auto_weapon id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auto_weapon ALTER COLUMN id_ SET DEFAULT nextval('public.auto_weapon_id__seq'::regclass);


--
-- TOC entry 4849 (class 2604 OID 18279)
-- Name: bmp_transport id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bmp_transport ALTER COLUMN id_ SET DEFAULT nextval('public.bmp_transport_id__seq'::regclass);


--
-- TOC entry 4847 (class 2604 OID 18265)
-- Name: carabine_weapon id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carabine_weapon ALTER COLUMN id_ SET DEFAULT nextval('public.carabine_weapon_id__seq'::regclass);


--
-- TOC entry 4841 (class 2604 OID 18208)
-- Name: company id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company ALTER COLUMN id_ SET DEFAULT nextval('public.company_id__seq'::regclass);


--
-- TOC entry 4843 (class 2604 OID 18232)
-- Name: department id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department ALTER COLUMN id_ SET DEFAULT nextval('public.department_id__seq'::regclass);


--
-- TOC entry 4854 (class 2604 OID 18387)
-- Name: dislocation id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dislocation ALTER COLUMN id_ SET DEFAULT nextval('public.dislocation_id__seq'::regclass);


--
-- TOC entry 4840 (class 2604 OID 18196)
-- Name: distinct_military_unit id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distinct_military_unit ALTER COLUMN id_ SET DEFAULT nextval('public.distinct_military_unit_id__seq'::regclass);


--
-- TOC entry 4853 (class 2604 OID 18380)
-- Name: gps_coordinate id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gps_coordinate ALTER COLUMN id_ SET DEFAULT nextval('public.gps_coordinate_id__seq'::regclass);


--
-- TOC entry 4850 (class 2604 OID 18286)
-- Name: light_transport id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.light_transport ALTER COLUMN id_ SET DEFAULT nextval('public.light_transport_id__seq'::regclass);


--
-- TOC entry 4839 (class 2604 OID 18184)
-- Name: military_unit id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.military_unit ALTER COLUMN id_ SET DEFAULT nextval('public.military_unit_id__seq'::regclass);


--
-- TOC entry 4838 (class 2604 OID 18172)
-- Name: military_units_union id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.military_units_union ALTER COLUMN id_ SET DEFAULT nextval('public.military_units_union_id__seq'::regclass);


--
-- TOC entry 4842 (class 2604 OID 18220)
-- Name: platoon id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platoon ALTER COLUMN id_ SET DEFAULT nextval('public.platoon_id__seq'::regclass);


--
-- TOC entry 4855 (class 2604 OID 18451)
-- Name: rank_data id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rank_data ALTER COLUMN id_ SET DEFAULT nextval('public.rank_data_id__seq'::regclass);


--
-- TOC entry 4852 (class 2604 OID 18353)
-- Name: resource id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource ALTER COLUMN id_ SET DEFAULT nextval('public.resource_id__seq'::regclass);


--
-- TOC entry 4851 (class 2604 OID 18311)
-- Name: resource_spec id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_spec ALTER COLUMN id_ SET DEFAULT nextval('public.resource_spec_id__seq'::regclass);


--
-- TOC entry 4844 (class 2604 OID 18244)
-- Name: rocket_weapon id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rocket_weapon ALTER COLUMN id_ SET DEFAULT nextval('public.rocket_weapon_id__seq'::regclass);


--
-- TOC entry 4856 (class 2604 OID 18458)
-- Name: serviceman id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceman ALTER COLUMN id_ SET DEFAULT nextval('public.serviceman_id__seq'::regclass);


--
-- TOC entry 4857 (class 2604 OID 18470)
-- Name: speciality id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speciality ALTER COLUMN id_ SET DEFAULT nextval('public.speciality_id__seq'::regclass);


--
-- TOC entry 4848 (class 2604 OID 18272)
-- Name: wagon_transport id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wagon_transport ALTER COLUMN id_ SET DEFAULT nextval('public.wagon_transport_id__seq'::regclass);


--
-- TOC entry 4799 (class 0 OID 16390)
-- Dependencies: 223
-- Data for Name: pga_jobagent; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobagent (jagpid, jaglogintime, jagstation) FROM stdin;
8124	2024-11-19 20:02:30.884783+00	DESKTOP-HABH36H
\.


--
-- TOC entry 4800 (class 0 OID 16399)
-- Dependencies: 225
-- Data for Name: pga_jobclass; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
\.


--
-- TOC entry 4801 (class 0 OID 16409)
-- Dependencies: 227
-- Data for Name: pga_job; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
\.


--
-- TOC entry 4803 (class 0 OID 16457)
-- Dependencies: 231
-- Data for Name: pga_schedule; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
\.


--
-- TOC entry 4804 (class 0 OID 16485)
-- Dependencies: 233
-- Data for Name: pga_exception; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
\.


--
-- TOC entry 4805 (class 0 OID 16499)
-- Dependencies: 235
-- Data for Name: pga_joblog; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
\.


--
-- TOC entry 4802 (class 0 OID 16433)
-- Dependencies: 229
-- Data for Name: pga_jobstep; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
\.


--
-- TOC entry 4806 (class 0 OID 16515)
-- Dependencies: 237
-- Data for Name: pga_jobsteplog; Type: TABLE DATA; Schema: pgagent; Owner: postgres
--

COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
\.


--
-- TOC entry 5109 (class 0 OID 18162)
-- Dependencies: 239
-- Data for Name: army; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.army (id_, name_) FROM stdin;
\.


--
-- TOC entry 5125 (class 0 OID 18248)
-- Dependencies: 255
-- Data for Name: artillery_weapon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artillery_weapon (id_, type_, fire_dist, check_date) FROM stdin;
\.


--
-- TOC entry 5127 (class 0 OID 18255)
-- Dependencies: 257
-- Data for Name: auto_weapon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auto_weapon (id_, type_, fire_rate, check_date) FROM stdin;
\.


--
-- TOC entry 5133 (class 0 OID 18276)
-- Dependencies: 263
-- Data for Name: bmp_transport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bmp_transport (id_, crews_count, check_date) FROM stdin;
\.


--
-- TOC entry 5129 (class 0 OID 18262)
-- Dependencies: 259
-- Data for Name: carabine_weapon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carabine_weapon (id_, type_, check_date) FROM stdin;
\.


--
-- TOC entry 5117 (class 0 OID 18205)
-- Dependencies: 247
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.company (id_, name_, distinct_military_unit) FROM stdin;
\.


--
-- TOC entry 5121 (class 0 OID 18229)
-- Dependencies: 251
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.department (id_, name_, platoon) FROM stdin;
\.


--
-- TOC entry 5144 (class 0 OID 18384)
-- Dependencies: 274
-- Data for Name: dislocation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dislocation (id_, county, living_point, distinct_, gps_coord, country) FROM stdin;
\.


--
-- TOC entry 5115 (class 0 OID 18193)
-- Dependencies: 245
-- Data for Name: distinct_military_unit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.distinct_military_unit (id_, name_, military_unit) FROM stdin;
\.


--
-- TOC entry 5142 (class 0 OID 18377)
-- Dependencies: 272
-- Data for Name: gps_coordinate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gps_coordinate (id_, hozizontal, vertical, height) FROM stdin;
\.


--
-- TOC entry 5135 (class 0 OID 18283)
-- Dependencies: 265
-- Data for Name: light_transport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.light_transport (id_, check_date) FROM stdin;
\.


--
-- TOC entry 5113 (class 0 OID 18181)
-- Dependencies: 243
-- Data for Name: military_unit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.military_unit (id_, name_, military_units_union) FROM stdin;
\.


--
-- TOC entry 5111 (class 0 OID 18169)
-- Dependencies: 241
-- Data for Name: military_units_union; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.military_units_union (id_, name_, army) FROM stdin;
\.


--
-- TOC entry 5119 (class 0 OID 18217)
-- Dependencies: 249
-- Data for Name: platoon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.platoon (id_, name_, company) FROM stdin;
\.


--
-- TOC entry 5146 (class 0 OID 18448)
-- Dependencies: 276
-- Data for Name: rank_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rank_data (id_, martial_academy_finish_date, rank_acquirement_data, academy_finish_date, deferment_data, military_training_building_name, military_training_start_date, military_training_finish_date) FROM stdin;
\.


--
-- TOC entry 5139 (class 0 OID 18350)
-- Dependencies: 269
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource (id_, name_, type_, spec) FROM stdin;
\.


--
-- TOC entry 5140 (class 0 OID 18361)
-- Dependencies: 270
-- Data for Name: resource_militaty_unit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_militaty_unit (resource_id, militaty_unit_id) FROM stdin;
\.


--
-- TOC entry 5137 (class 0 OID 18308)
-- Dependencies: 267
-- Data for Name: resource_spec; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resource_spec (id_, table_type_, rocket_id, artillery_id, auto_id, carabine_id, wagon_id, bmp_id, light_transport_id) FROM stdin;
\.


--
-- TOC entry 5123 (class 0 OID 18241)
-- Dependencies: 253
-- Data for Name: rocket_weapon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rocket_weapon (id_, type_, power_, check_date) FROM stdin;
\.


--
-- TOC entry 5148 (class 0 OID 18455)
-- Dependencies: 278
-- Data for Name: serviceman; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serviceman (id_, fio, birth_date, rank_, rank_data_id, zrada_info, spec_id) FROM stdin;
177	loleps mia arsen	2004-01-01	putin	\N	yeah oh baby	1
220	grishenko anton jonodan	2005-01-01	huilo	\N	konechno ze	\N
221	lenyaua vova daniil	2007-01-01	denchik	\N	net	\N
222	jojo mia vladimir	2001-01-01	putin	\N	ganba	\N
223	putin denys vova	2006-01-01	huilo	\N	kak vsegda	\N
224	loleps katya vova	2003-01-01	da	\N	net	\N
225	hutsan daniil lena	2000-01-01	admiral	\N	slehka	\N
226	lenyaua bodya jo	2000-01-01	huilo	\N	ne znayu	\N
227	borisov denys joster	2005-01-01	pidor	\N	konechno ze	\N
228	hutsan danya vova	2003-01-01	pidor	\N	kak vsegda	\N
229	loleps joster vova	2005-01-01	denchik	\N	vosmozno	\N
230	hutsan loleps sveta	2004-01-01	denchik	\N	da	\N
231	hutsan arsen daniil	2007-01-01	putin	\N	ne znayu	\N
232	lenyaua joster vova	2000-01-01	hrin yoho zna	\N	zlo	\N
233	poroshenko danya loleps	2001-01-01	denchik	\N	da	\N
234	lenyaua jo nick	2003-01-01	general	\N	vosmozno	\N
235	loleps artem bohdan	2006-01-01	admiral	\N	kak vsegda	\N
236	hutsan vova artem	2005-01-01	pidor	\N	zrada	\N
237	borisov bodya vladimir	2003-01-01	commander	\N	vosmozno	\N
238	jojo jonodan vladimir	2005-01-01	huilo	\N	ganba	\N
239	loleps loleps jonodan	2002-01-01	putin	\N	ne znayu	\N
240	zelenskiy nick katya	2007-01-01	putin	\N	net	\N
241	hutsan vova bodya	2005-01-01	putin	\N	slehka	\N
242	loleps arsen vova	2004-01-01	admiral	\N	zrada	\N
243	grishenko daniil arsen	2004-01-01	admin	\N	net	\N
244	lenyaua bodya danya	2005-01-01	net	\N	ganba	\N
245	hutsan bodya lena	2006-01-01	admin	\N	zrada	\N
246	putin mia danya	2006-01-01	putin	\N	zlo	\N
247	putin daniil artem	2002-01-01	huilo	\N	kak vsegda	\N
248	loleps jonodan bodya	2000-01-01	general	\N	zrada	\N
249	zelenskiy jo nick	2005-01-01	da	\N	zlo	\N
250	grishenko lena jonodan	2002-01-01	general	\N	kak vsegda	\N
251	putin vova katya	2007-01-01	putin	\N	konechno ze	\N
252	loleps daniil sveta	2001-01-01	pidor	\N	ganba	\N
253	zelenskiy arsen emma	2001-01-01	huilo	\N	kak vsegda	\N
254	hutsan sveta daniil	2005-01-01	denchik	\N	da	\N
255	loleps jo mia	2004-01-01	general	\N	vosmozno	\N
256	poroshenko nick vladimir	2001-01-01	radovoy	\N	ne znayu	\N
257	lenyaua nick nick	2000-01-01	commander	\N	vosmozno	\N
258	grishenko joster anton	2004-01-01	pidor	\N	zlo	\N
259	zelenskiy katya denys	2003-01-01	putin	\N	ganba	\N
260	borisov denys vladimir	2000-01-01	huilo	\N	net	\N
261	hutsan daniil vova	2004-01-01	denchik	\N	konechno ze	\N
262	borisov anton mia	2006-01-01	general	\N	zrada	\N
263	jojo jonodan joster	2007-01-01	general	\N	kak vsegda	\N
264	poroshenko denys anton	2004-01-01	commander	\N	ganba	\N
265	putin jo danya	2004-01-01	general	\N	zlo	\N
266	loleps nick vova	2004-01-01	da	\N	ganba	\N
267	putin mia loleps	2004-01-01	huilo	\N	net	\N
268	zelenskiy daniil arsen	2001-01-01	denchik	\N	ne znayu	\N
269	lenyaua denys nick	2005-01-01	da	\N	da	\N
270	borisov artem sveta	2005-01-01	radovoy	\N	kak vsegda	\N
271	putin anton mia	2001-01-01	huilo	\N	konechno ze	\N
272	jojo joster jonodan	2001-01-01	denchik	\N	da	\N
273	hutsan katya joster	2005-01-01	denchik	\N	kak vsegda	\N
274	hutsan bohdan artem	2007-01-01	da	\N	zrada	\N
275	poroshenko jo sveta	2004-01-01	radovoy	\N	zlo	\N
276	grishenko nick katya	2001-01-01	admin	\N	konechno ze	\N
277	hutsan sveta loleps	2004-01-01	pidor	\N	net	\N
278	lenyaua nick joster	2002-01-01	da	\N	ganba	\N
78	jojo vova emma	2005-01-01	putin	\N	konechno ze	\N
79	poroshenko anton katya	2007-01-01	net	\N	net	\N
80	zelenskiy arsen nick	2005-01-01	commander	\N	vosmozno	\N
81	hutsan danya jo	2005-01-01	hrin yoho zna	\N	ganba	\N
82	jojo lena anton	2006-01-01	radovoy	\N	kak vsegda	\N
83	zelenskiy jo joster	2007-01-01	commander	\N	ne znayu	\N
84	jojo nick mia	2000-01-01	huilo	\N	ganba	\N
85	putin anton vova	2003-01-01	commander	\N	ganba	\N
86	grishenko jonodan katya	2005-01-01	net	\N	zrada	\N
87	hutsan emma danya	2001-01-01	putin	\N	zlo	\N
88	zelenskiy vladimir artem	2004-01-01	da	\N	net	\N
89	hutsan jonodan danya	2000-01-01	denchik	\N	ganba	\N
90	putin danya bohdan	2000-01-01	admin	\N	ganba	\N
91	hutsan anton sveta	2006-01-01	hrin yoho zna	\N	slehka	\N
92	hutsan emma bohdan	2004-01-01	pidor	\N	ne znayu	\N
93	grishenko arsen vladimir	2007-01-01	net	\N	ne znayu	\N
94	grishenko sveta danya	2001-01-01	admiral	\N	zlo	\N
95	jojo emma danya	2006-01-01	admiral	\N	zrada	\N
96	lenyaua bohdan jonodan	2004-01-01	admiral	\N	vosmozno	\N
97	jojo arsen lena	2001-01-01	admin	\N	da	\N
98	lenyaua arsen bodya	2007-01-01	huilo	\N	zlo	\N
99	putin vladimir nick	2002-01-01	hrin yoho zna	\N	konechno ze	\N
100	poroshenko katya bodya	2007-01-01	denchik	\N	kak vsegda	\N
101	loleps vova arsen	2006-01-01	admin	\N	vosmozno	\N
102	putin katya bodya	2006-01-01	commander	\N	konechno ze	\N
103	putin katya mia	2007-01-01	putin	\N	net	\N
104	lenyaua emma vladimir	2006-01-01	admin	\N	konechno ze	\N
105	zelenskiy lena arsen	2002-01-01	commander	\N	net	\N
106	loleps lena lena	2000-01-01	putin	\N	ganba	\N
107	hutsan nick anton	2001-01-01	denchik	\N	konechno ze	\N
108	hutsan bohdan danya	2004-01-01	admin	\N	kak vsegda	\N
109	lenyaua danya mia	2007-01-01	general	\N	zlo	\N
110	borisov artem emma	2006-01-01	radovoy	\N	kak vsegda	\N
111	grishenko vladimir arsen	2003-01-01	net	\N	da	\N
112	hutsan bohdan bodya	2002-01-01	denchik	\N	ganba	\N
113	jojo bodya emma	2004-01-01	net	\N	ganba	\N
114	poroshenko jonodan arsen	2006-01-01	putin	\N	ne znayu	\N
115	jojo vova danya	2000-01-01	huilo	\N	slehka	\N
116	zelenskiy artem emma	2006-01-01	denchik	\N	zrada	\N
117	lenyaua bodya anton	2005-01-01	admin	\N	ne znayu	\N
118	grishenko anton jonodan	2005-01-01	huilo	\N	konechno ze	\N
119	lenyaua vova daniil	2007-01-01	denchik	\N	net	\N
120	jojo mia vladimir	2001-01-01	putin	\N	ganba	\N
121	putin denys vova	2006-01-01	huilo	\N	kak vsegda	\N
122	loleps katya vova	2003-01-01	da	\N	net	\N
123	hutsan daniil lena	2000-01-01	admiral	\N	slehka	\N
124	lenyaua bodya jo	2000-01-01	huilo	\N	ne znayu	\N
125	borisov denys joster	2005-01-01	pidor	\N	konechno ze	\N
126	hutsan danya vova	2003-01-01	pidor	\N	kak vsegda	\N
127	loleps joster vova	2005-01-01	denchik	\N	vosmozno	\N
128	hutsan loleps sveta	2004-01-01	denchik	\N	da	\N
129	hutsan arsen daniil	2007-01-01	putin	\N	ne znayu	\N
130	lenyaua joster vova	2000-01-01	hrin yoho zna	\N	zlo	\N
131	poroshenko danya loleps	2001-01-01	denchik	\N	da	\N
132	lenyaua jo nick	2003-01-01	general	\N	vosmozno	\N
133	loleps artem bohdan	2006-01-01	admiral	\N	kak vsegda	\N
134	hutsan vova artem	2005-01-01	pidor	\N	zrada	\N
135	borisov bodya vladimir	2003-01-01	commander	\N	vosmozno	\N
136	jojo jonodan vladimir	2005-01-01	huilo	\N	ganba	\N
137	loleps loleps jonodan	2002-01-01	putin	\N	ne znayu	\N
138	zelenskiy nick katya	2007-01-01	putin	\N	net	\N
139	hutsan vova bodya	2005-01-01	putin	\N	slehka	\N
140	loleps arsen vova	2004-01-01	admiral	\N	zrada	\N
141	grishenko daniil arsen	2004-01-01	admin	\N	net	\N
142	lenyaua bodya danya	2005-01-01	net	\N	ganba	\N
143	hutsan bodya lena	2006-01-01	admin	\N	zrada	\N
144	putin mia danya	2006-01-01	putin	\N	zlo	\N
145	putin daniil artem	2002-01-01	huilo	\N	kak vsegda	\N
146	loleps jonodan bodya	2000-01-01	general	\N	zrada	\N
147	zelenskiy jo nick	2005-01-01	da	\N	zlo	\N
148	grishenko lena jonodan	2002-01-01	general	\N	kak vsegda	\N
149	putin vova katya	2007-01-01	putin	\N	konechno ze	\N
150	loleps daniil sveta	2001-01-01	pidor	\N	ganba	\N
151	zelenskiy arsen emma	2001-01-01	huilo	\N	kak vsegda	\N
152	hutsan sveta daniil	2005-01-01	denchik	\N	da	\N
153	loleps jo mia	2004-01-01	general	\N	vosmozno	\N
154	poroshenko nick vladimir	2001-01-01	radovoy	\N	ne znayu	\N
155	lenyaua nick nick	2000-01-01	commander	\N	vosmozno	\N
156	grishenko joster anton	2004-01-01	pidor	\N	zlo	\N
157	zelenskiy katya denys	2003-01-01	putin	\N	ganba	\N
158	borisov denys vladimir	2000-01-01	huilo	\N	net	\N
159	hutsan daniil vova	2004-01-01	denchik	\N	konechno ze	\N
160	borisov anton mia	2006-01-01	general	\N	zrada	\N
161	jojo jonodan joster	2007-01-01	general	\N	kak vsegda	\N
162	poroshenko denys anton	2004-01-01	commander	\N	ganba	\N
163	putin jo danya	2004-01-01	general	\N	zlo	\N
164	loleps nick vova	2004-01-01	da	\N	ganba	\N
165	putin mia loleps	2004-01-01	huilo	\N	net	\N
166	zelenskiy daniil arsen	2001-01-01	denchik	\N	ne znayu	\N
167	lenyaua denys nick	2005-01-01	da	\N	da	\N
168	borisov artem sveta	2005-01-01	radovoy	\N	kak vsegda	\N
169	putin anton mia	2001-01-01	huilo	\N	konechno ze	\N
170	jojo joster jonodan	2001-01-01	denchik	\N	da	\N
171	hutsan katya joster	2005-01-01	denchik	\N	kak vsegda	\N
172	hutsan bohdan artem	2007-01-01	da	\N	zrada	\N
173	poroshenko jo sveta	2004-01-01	radovoy	\N	zlo	\N
174	grishenko nick katya	2001-01-01	admin	\N	konechno ze	\N
175	hutsan sveta loleps	2004-01-01	pidor	\N	net	\N
176	lenyaua nick joster	2002-01-01	da	\N	ganba	\N
179	loleps mia arsen	2004-01-01	putin	\N	slehka	\N
180	jojo vova emma	2005-01-01	putin	\N	konechno ze	\N
181	poroshenko anton katya	2007-01-01	net	\N	net	\N
182	zelenskiy arsen nick	2005-01-01	commander	\N	vosmozno	\N
183	hutsan danya jo	2005-01-01	hrin yoho zna	\N	ganba	\N
184	jojo lena anton	2006-01-01	radovoy	\N	kak vsegda	\N
185	zelenskiy jo joster	2007-01-01	commander	\N	ne znayu	\N
186	jojo nick mia	2000-01-01	huilo	\N	ganba	\N
187	putin anton vova	2003-01-01	commander	\N	ganba	\N
188	grishenko jonodan katya	2005-01-01	net	\N	zrada	\N
189	hutsan emma danya	2001-01-01	putin	\N	zlo	\N
190	zelenskiy vladimir artem	2004-01-01	da	\N	net	\N
191	hutsan jonodan danya	2000-01-01	denchik	\N	ganba	\N
192	putin danya bohdan	2000-01-01	admin	\N	ganba	\N
193	hutsan anton sveta	2006-01-01	hrin yoho zna	\N	slehka	\N
194	hutsan emma bohdan	2004-01-01	pidor	\N	ne znayu	\N
195	grishenko arsen vladimir	2007-01-01	net	\N	ne znayu	\N
196	grishenko sveta danya	2001-01-01	admiral	\N	zlo	\N
197	jojo emma danya	2006-01-01	admiral	\N	zrada	\N
198	lenyaua bohdan jonodan	2004-01-01	admiral	\N	vosmozno	\N
199	jojo arsen lena	2001-01-01	admin	\N	da	\N
200	lenyaua arsen bodya	2007-01-01	huilo	\N	zlo	\N
201	putin vladimir nick	2002-01-01	hrin yoho zna	\N	konechno ze	\N
202	poroshenko katya bodya	2007-01-01	denchik	\N	kak vsegda	\N
203	loleps vova arsen	2006-01-01	admin	\N	vosmozno	\N
204	putin katya bodya	2006-01-01	commander	\N	konechno ze	\N
205	putin katya mia	2007-01-01	putin	\N	net	\N
206	lenyaua emma vladimir	2006-01-01	admin	\N	konechno ze	\N
207	zelenskiy lena arsen	2002-01-01	commander	\N	net	\N
208	loleps lena lena	2000-01-01	putin	\N	ganba	\N
209	hutsan nick anton	2001-01-01	denchik	\N	konechno ze	\N
210	hutsan bohdan danya	2004-01-01	admin	\N	kak vsegda	\N
211	lenyaua danya mia	2007-01-01	general	\N	zlo	\N
212	borisov artem emma	2006-01-01	radovoy	\N	kak vsegda	\N
213	grishenko vladimir arsen	2003-01-01	net	\N	da	\N
214	hutsan bohdan bodya	2002-01-01	denchik	\N	ganba	\N
215	jojo bodya emma	2004-01-01	net	\N	ganba	\N
216	poroshenko jonodan arsen	2006-01-01	putin	\N	ne znayu	\N
217	jojo vova danya	2000-01-01	huilo	\N	slehka	\N
218	zelenskiy artem emma	2006-01-01	denchik	\N	zrada	\N
219	lenyaua bodya anton	2005-01-01	admin	\N	ne znayu	\N
\.


--
-- TOC entry 5151 (class 0 OID 18473)
-- Dependencies: 281
-- Data for Name: serviceman_affiliation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serviceman_affiliation (serviceman_id, military_unit_id, is_commander) FROM stdin;
\.


--
-- TOC entry 5152 (class 0 OID 18488)
-- Dependencies: 282
-- Data for Name: serviceman_speciality; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serviceman_speciality (serviceman_id, speciality_id) FROM stdin;
\.


--
-- TOC entry 5150 (class 0 OID 18467)
-- Dependencies: 280
-- Data for Name: speciality; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.speciality (id_, description, shortened_data) FROM stdin;
1	ip-35 student	ip-355 student
\.


--
-- TOC entry 5131 (class 0 OID 18269)
-- Dependencies: 261
-- Data for Name: wagon_transport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wagon_transport (id_, type_, crews_count, check_date) FROM stdin;
\.


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 238
-- Name: army_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.army_id__seq', 1, false);


--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 254
-- Name: artillery_weapon_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artillery_weapon_id__seq', 1, false);


--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 256
-- Name: auto_weapon_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auto_weapon_id__seq', 1, false);


--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 262
-- Name: bmp_transport_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bmp_transport_id__seq', 1, false);


--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 258
-- Name: carabine_weapon_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carabine_weapon_id__seq', 1, false);


--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 246
-- Name: company_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_id__seq', 1, false);


--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 250
-- Name: department_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_id__seq', 1, false);


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 273
-- Name: dislocation_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dislocation_id__seq', 1, false);


--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 244
-- Name: distinct_military_unit_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.distinct_military_unit_id__seq', 1, false);


--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 271
-- Name: gps_coordinate_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gps_coordinate_id__seq', 1, false);


--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 264
-- Name: light_transport_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.light_transport_id__seq', 1, false);


--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 242
-- Name: military_unit_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.military_unit_id__seq', 1, false);


--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 240
-- Name: military_units_union_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.military_units_union_id__seq', 1, false);


--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 248
-- Name: platoon_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.platoon_id__seq', 1, false);


--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 275
-- Name: rank_data_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rank_data_id__seq', 1, false);


--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 268
-- Name: resource_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resource_id__seq', 1, false);


--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 266
-- Name: resource_spec_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resource_spec_id__seq', 1, false);


--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 252
-- Name: rocket_weapon_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rocket_weapon_id__seq', 1, false);


--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 277
-- Name: serviceman_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serviceman_id__seq', 278, true);


--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 279
-- Name: speciality_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.speciality_id__seq', 1, true);


--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 260
-- Name: wagon_transport_id__seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wagon_transport_id__seq', 1, false);


--
-- TOC entry 4893 (class 2606 OID 18167)
-- Name: army army_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.army
    ADD CONSTRAINT army_pkey PRIMARY KEY (id_);


--
-- TOC entry 4909 (class 2606 OID 18253)
-- Name: artillery_weapon artillery_weapon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artillery_weapon
    ADD CONSTRAINT artillery_weapon_pkey PRIMARY KEY (id_);


--
-- TOC entry 4911 (class 2606 OID 18260)
-- Name: auto_weapon auto_weapon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auto_weapon
    ADD CONSTRAINT auto_weapon_pkey PRIMARY KEY (id_);


--
-- TOC entry 4917 (class 2606 OID 18281)
-- Name: bmp_transport bmp_transport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bmp_transport
    ADD CONSTRAINT bmp_transport_pkey PRIMARY KEY (id_);


--
-- TOC entry 4913 (class 2606 OID 18267)
-- Name: carabine_weapon carabine_weapon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carabine_weapon
    ADD CONSTRAINT carabine_weapon_pkey PRIMARY KEY (id_);


--
-- TOC entry 4901 (class 2606 OID 18210)
-- Name: company company_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id_);


--
-- TOC entry 4905 (class 2606 OID 18234)
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id_);


--
-- TOC entry 4929 (class 2606 OID 18389)
-- Name: dislocation dislocation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dislocation
    ADD CONSTRAINT dislocation_pkey PRIMARY KEY (id_);


--
-- TOC entry 4899 (class 2606 OID 18198)
-- Name: distinct_military_unit distinct_military_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distinct_military_unit
    ADD CONSTRAINT distinct_military_unit_pkey PRIMARY KEY (id_);


--
-- TOC entry 4927 (class 2606 OID 18382)
-- Name: gps_coordinate gps_coordinate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gps_coordinate
    ADD CONSTRAINT gps_coordinate_pkey PRIMARY KEY (id_);


--
-- TOC entry 4919 (class 2606 OID 18288)
-- Name: light_transport light_transport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.light_transport
    ADD CONSTRAINT light_transport_pkey PRIMARY KEY (id_);


--
-- TOC entry 4897 (class 2606 OID 18186)
-- Name: military_unit military_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.military_unit
    ADD CONSTRAINT military_unit_pkey PRIMARY KEY (id_);


--
-- TOC entry 4895 (class 2606 OID 18174)
-- Name: military_units_union military_units_union_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.military_units_union
    ADD CONSTRAINT military_units_union_pkey PRIMARY KEY (id_);


--
-- TOC entry 4903 (class 2606 OID 18222)
-- Name: platoon platoon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platoon
    ADD CONSTRAINT platoon_pkey PRIMARY KEY (id_);


--
-- TOC entry 4931 (class 2606 OID 18453)
-- Name: rank_data rank_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rank_data
    ADD CONSTRAINT rank_data_pkey PRIMARY KEY (id_);


--
-- TOC entry 4925 (class 2606 OID 18365)
-- Name: resource_militaty_unit resource_militaty_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_militaty_unit
    ADD CONSTRAINT resource_militaty_unit_pkey PRIMARY KEY (resource_id, militaty_unit_id);


--
-- TOC entry 4923 (class 2606 OID 18355)
-- Name: resource resource_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id_);


--
-- TOC entry 4921 (class 2606 OID 18313)
-- Name: resource_spec resource_spec_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_spec
    ADD CONSTRAINT resource_spec_pkey PRIMARY KEY (id_);


--
-- TOC entry 4907 (class 2606 OID 18246)
-- Name: rocket_weapon rocket_weapon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rocket_weapon
    ADD CONSTRAINT rocket_weapon_pkey PRIMARY KEY (id_);


--
-- TOC entry 4937 (class 2606 OID 18477)
-- Name: serviceman_affiliation serviceman_affiliation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceman_affiliation
    ADD CONSTRAINT serviceman_affiliation_pkey PRIMARY KEY (serviceman_id, military_unit_id);


--
-- TOC entry 4933 (class 2606 OID 18460)
-- Name: serviceman serviceman_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceman
    ADD CONSTRAINT serviceman_pkey PRIMARY KEY (id_);


--
-- TOC entry 4939 (class 2606 OID 18492)
-- Name: serviceman_speciality serviceman_speciality_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceman_speciality
    ADD CONSTRAINT serviceman_speciality_pkey PRIMARY KEY (serviceman_id, speciality_id);


--
-- TOC entry 4935 (class 2606 OID 18472)
-- Name: speciality speciality_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speciality
    ADD CONSTRAINT speciality_pkey PRIMARY KEY (id_);


--
-- TOC entry 4915 (class 2606 OID 18274)
-- Name: wagon_transport wagon_transport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wagon_transport
    ADD CONSTRAINT wagon_transport_pkey PRIMARY KEY (id_);


--
-- TOC entry 4943 (class 2606 OID 18211)
-- Name: company company_distinct_military_unit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_distinct_military_unit_fkey FOREIGN KEY (distinct_military_unit) REFERENCES public.distinct_military_unit(id_);


--
-- TOC entry 4945 (class 2606 OID 18235)
-- Name: department department_platoon_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_platoon_fkey FOREIGN KEY (platoon) REFERENCES public.platoon(id_);


--
-- TOC entry 4956 (class 2606 OID 18390)
-- Name: dislocation dislocation_gps_coord_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dislocation
    ADD CONSTRAINT dislocation_gps_coord_fkey FOREIGN KEY (gps_coord) REFERENCES public.gps_coordinate(id_);


--
-- TOC entry 4942 (class 2606 OID 18199)
-- Name: distinct_military_unit distinct_military_unit_military_unit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distinct_military_unit
    ADD CONSTRAINT distinct_military_unit_military_unit_fkey FOREIGN KEY (military_unit) REFERENCES public.military_unit(id_);


--
-- TOC entry 4941 (class 2606 OID 18187)
-- Name: military_unit military_unit_military_units_union_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.military_unit
    ADD CONSTRAINT military_unit_military_units_union_fkey FOREIGN KEY (military_units_union) REFERENCES public.military_units_union(id_);


--
-- TOC entry 4940 (class 2606 OID 18175)
-- Name: military_units_union military_units_union_army_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.military_units_union
    ADD CONSTRAINT military_units_union_army_fkey FOREIGN KEY (army) REFERENCES public.army(id_);


--
-- TOC entry 4944 (class 2606 OID 18223)
-- Name: platoon platoon_company_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platoon
    ADD CONSTRAINT platoon_company_fkey FOREIGN KEY (company) REFERENCES public.company(id_);


--
-- TOC entry 4954 (class 2606 OID 18371)
-- Name: resource_militaty_unit resource_militaty_unit_militaty_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_militaty_unit
    ADD CONSTRAINT resource_militaty_unit_militaty_unit_id_fkey FOREIGN KEY (militaty_unit_id) REFERENCES public.military_unit(id_) ON DELETE CASCADE;


--
-- TOC entry 4955 (class 2606 OID 18366)
-- Name: resource_militaty_unit resource_militaty_unit_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_militaty_unit
    ADD CONSTRAINT resource_militaty_unit_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resource(id_) ON DELETE CASCADE;


--
-- TOC entry 4946 (class 2606 OID 18319)
-- Name: resource_spec resource_spec_artillery_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_spec
    ADD CONSTRAINT resource_spec_artillery_id_fkey FOREIGN KEY (artillery_id) REFERENCES public.artillery_weapon(id_);


--
-- TOC entry 4947 (class 2606 OID 18324)
-- Name: resource_spec resource_spec_auto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_spec
    ADD CONSTRAINT resource_spec_auto_id_fkey FOREIGN KEY (auto_id) REFERENCES public.auto_weapon(id_);


--
-- TOC entry 4948 (class 2606 OID 18339)
-- Name: resource_spec resource_spec_bmp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_spec
    ADD CONSTRAINT resource_spec_bmp_id_fkey FOREIGN KEY (bmp_id) REFERENCES public.bmp_transport(id_);


--
-- TOC entry 4949 (class 2606 OID 18329)
-- Name: resource_spec resource_spec_carabine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_spec
    ADD CONSTRAINT resource_spec_carabine_id_fkey FOREIGN KEY (carabine_id) REFERENCES public.carabine_weapon(id_);


--
-- TOC entry 4953 (class 2606 OID 18356)
-- Name: resource resource_spec_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_spec_fkey FOREIGN KEY (spec) REFERENCES public.resource_spec(id_);


--
-- TOC entry 4950 (class 2606 OID 18344)
-- Name: resource_spec resource_spec_light_transport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_spec
    ADD CONSTRAINT resource_spec_light_transport_id_fkey FOREIGN KEY (light_transport_id) REFERENCES public.light_transport(id_);


--
-- TOC entry 4951 (class 2606 OID 18314)
-- Name: resource_spec resource_spec_rocket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_spec
    ADD CONSTRAINT resource_spec_rocket_id_fkey FOREIGN KEY (rocket_id) REFERENCES public.rocket_weapon(id_);


--
-- TOC entry 4952 (class 2606 OID 18334)
-- Name: resource_spec resource_spec_wagon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource_spec
    ADD CONSTRAINT resource_spec_wagon_id_fkey FOREIGN KEY (wagon_id) REFERENCES public.wagon_transport(id_);


--
-- TOC entry 4959 (class 2606 OID 18483)
-- Name: serviceman_affiliation serviceman_affiliation_military_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceman_affiliation
    ADD CONSTRAINT serviceman_affiliation_military_unit_id_fkey FOREIGN KEY (military_unit_id) REFERENCES public.military_unit(id_) ON DELETE CASCADE;


--
-- TOC entry 4960 (class 2606 OID 18478)
-- Name: serviceman_affiliation serviceman_affiliation_serviceman_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceman_affiliation
    ADD CONSTRAINT serviceman_affiliation_serviceman_id_fkey FOREIGN KEY (serviceman_id) REFERENCES public.serviceman(id_) ON DELETE CASCADE;


--
-- TOC entry 4957 (class 2606 OID 18461)
-- Name: serviceman serviceman_rank_data_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceman
    ADD CONSTRAINT serviceman_rank_data_id_fkey FOREIGN KEY (rank_data_id) REFERENCES public.rank_data(id_);


--
-- TOC entry 4958 (class 2606 OID 18526)
-- Name: serviceman serviceman_spec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceman
    ADD CONSTRAINT serviceman_spec_id_fkey FOREIGN KEY (spec_id) REFERENCES public.speciality(id_);


--
-- TOC entry 4961 (class 2606 OID 18493)
-- Name: serviceman_speciality serviceman_speciality_serviceman_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceman_speciality
    ADD CONSTRAINT serviceman_speciality_serviceman_id_fkey FOREIGN KEY (serviceman_id) REFERENCES public.serviceman(id_);


--
-- TOC entry 4962 (class 2606 OID 18498)
-- Name: serviceman_speciality serviceman_speciality_speciality_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serviceman_speciality
    ADD CONSTRAINT serviceman_speciality_speciality_id_fkey FOREIGN KEY (speciality_id) REFERENCES public.speciality(id_);


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE company; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.company TO commander_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.company TO commander_user;


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE department; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.department TO commander_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.department TO commander_user;


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE distinct_military_unit; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.distinct_military_unit TO commander_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.distinct_military_unit TO commander_user;


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE military_unit; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.military_unit TO commander_role;
GRANT ALL ON TABLE public.military_unit TO general_role;
GRANT ALL ON TABLE public.military_unit TO general_user;
GRANT SELECT,INSERT,UPDATE ON TABLE public.military_unit TO commander_user;


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE military_units_union; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.military_units_union TO general_role;
GRANT ALL ON TABLE public.military_units_union TO general_user;


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE platoon; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.platoon TO commander_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.platoon TO commander_user;


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE rank_data; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rank_data TO general_role;
GRANT ALL ON TABLE public.rank_data TO general_user;


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE resource_militaty_unit; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.resource_militaty_unit TO commander_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.resource_militaty_unit TO commander_user;


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 278
-- Name: TABLE serviceman; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.serviceman TO flagman_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.serviceman TO commander_role;
GRANT ALL ON TABLE public.serviceman TO general_role;
GRANT ALL ON TABLE public.serviceman TO general_user;
GRANT ALL ON TABLE public.serviceman TO flagman_user;
GRANT SELECT,INSERT,UPDATE ON TABLE public.serviceman TO commander_user;


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 281
-- Name: TABLE serviceman_affiliation; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.serviceman_affiliation TO commander_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.serviceman_affiliation TO commander_user;


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 280
-- Name: TABLE speciality; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.speciality TO general_role;
GRANT ALL ON TABLE public.speciality TO general_user;


-- Completed on 2024-11-20 15:43:41

--
-- PostgreSQL database dump complete
--


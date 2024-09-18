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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: administrative_gender; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.administrative_gender AS ENUM (
    'male',
    'female',
    'other',
    'unknown'
);


--
-- Name: data_absent_reason; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.data_absent_reason AS ENUM (
    'unknown',
    'asked-unknown',
    'temp-unknown',
    'not-asked',
    'asked-declined',
    'masked',
    'not-applicable',
    'unsupported',
    'as-text',
    'error',
    'not-a-number',
    'negative-infinity',
    'positive-infinity',
    'not-performed',
    'not-permitted'
);


--
-- Name: diagnostic_report_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.diagnostic_report_status AS ENUM (
    'registered',
    'partial',
    'preliminary',
    'final',
    'amended',
    'corrected',
    'appended',
    'cancelled',
    'entered-in-error',
    'unknown'
);


--
-- Name: observation_range_category; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.observation_range_category AS ENUM (
    'reference',
    'critical',
    'absolute'
);


--
-- Name: observation_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.observation_status AS ENUM (
    'registered',
    'preliminary',
    'final',
    'amended',
    'corrected',
    'cancelled',
    'entered-in-error',
    'unknown'
);


--
-- Name: publication_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.publication_status AS ENUM (
    'draft',
    'active',
    'retired',
    'unknown'
);


--
-- Name: my_unaccent(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.my_unaccent(text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT public.unaccent('public.unaccent', $1) $_$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accession_panels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accession_panels (
    id bigint NOT NULL,
    accession_id bigint,
    panel_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: accession_panels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accession_panels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accession_panels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accession_panels_id_seq OWNED BY public.accession_panels.id;


--
-- Name: accessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accessions (
    id bigint NOT NULL,
    patient_id bigint,
    drawn_at timestamp without time zone,
    drawer_id bigint,
    received_at timestamp without time zone,
    receiver_id bigint,
    reported_at timestamp without time zone,
    reporter_id bigint,
    doctor_id bigint,
    icd9 character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    emailed_doctor_at timestamp without time zone,
    emailed_patient_at timestamp without time zone,
    status public.diagnostic_report_status
);


--
-- Name: accessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accessions_id_seq OWNED BY public.accessions.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.claims (
    id bigint NOT NULL,
    accession_id bigint,
    number character varying,
    external_number character varying,
    claimed_at timestamp without time zone,
    insurance_provider_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: claims_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.claims_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: claims_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.claims_id_seq OWNED BY public.claims.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departments (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    code character varying,
    loinc_class character varying,
    "position" integer
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.doctors (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying,
    accessions_count integer DEFAULT 0,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    gender public.administrative_gender,
    organization boolean DEFAULT false,
    quotes_count integer DEFAULT 0
);


--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.doctors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doctors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.doctors_id_seq OWNED BY public.doctors.id;


--
-- Name: insurance_providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.insurance_providers (
    id bigint NOT NULL,
    name character varying,
    price_list_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: insurance_providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.insurance_providers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: insurance_providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.insurance_providers_id_seq OWNED BY public.insurance_providers.id;


--
-- Name: lab_test_panels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lab_test_panels (
    id bigint NOT NULL,
    lab_test_id bigint,
    panel_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: lab_test_panels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lab_test_panels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_test_panels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lab_test_panels_id_seq OWNED BY public.lab_test_panels.id;


--
-- Name: lab_test_value_option_joints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lab_test_value_option_joints (
    id bigint NOT NULL,
    lab_test_value_id bigint,
    lab_test_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: lab_test_value_option_joints_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lab_test_value_option_joints_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_test_value_option_joints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lab_test_value_option_joints_id_seq OWNED BY public.lab_test_value_option_joints.id;


--
-- Name: lab_test_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lab_test_values (
    id bigint NOT NULL,
    value character varying,
    flag character varying,
    note text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "numeric" boolean,
    snomed character varying,
    loinc character varying
);


--
-- Name: lab_test_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lab_test_values_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_test_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lab_test_values_id_seq OWNED BY public.lab_test_values.id;


--
-- Name: lab_tests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lab_tests (
    id bigint NOT NULL,
    code character varying,
    name character varying,
    description text,
    decimals integer,
    department_id bigint,
    unit_id bigint,
    procedure character varying,
    derivation boolean,
    also_numeric boolean,
    ratio boolean,
    range boolean,
    fraction boolean,
    text_length integer,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    loinc character varying,
    remarks text,
    status public.publication_status DEFAULT 'active'::public.publication_status,
    fasting_status_duration interval,
    patient_preparation text
);


--
-- Name: lab_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lab_tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lab_tests_id_seq OWNED BY public.lab_tests.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notes (
    id bigint NOT NULL,
    content text,
    department_id bigint,
    noticeable_id bigint,
    noticeable_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


--
-- Name: observations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.observations (
    id bigint NOT NULL,
    value character varying,
    lab_test_id bigint,
    accession_id bigint,
    lab_test_value_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status public.observation_status,
    data_absent_reason public.data_absent_reason
);


--
-- Name: observations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.observations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: observations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.observations_id_seq OWNED BY public.observations.id;


--
-- Name: panels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.panels (
    id bigint NOT NULL,
    code character varying,
    name character varying,
    description character varying,
    procedure character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    loinc character varying,
    status public.publication_status DEFAULT 'active'::public.publication_status,
    fasting_status_duration interval,
    patient_preparation text,
    "position" integer
);


--
-- Name: panels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.panels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: panels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.panels_id_seq OWNED BY public.panels.id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patients (
    id bigint NOT NULL,
    given_name character varying,
    middle_name character varying,
    family_name character varying,
    family_name2 character varying,
    gender character varying,
    birthdate date,
    identifier character varying,
    insurance_provider_id bigint,
    phone character varying(32),
    email character varying(64),
    animal_type integer,
    policy_number character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    partner_name character varying,
    cellular character varying(32),
    address jsonb DEFAULT '{}'::jsonb,
    deceased boolean,
    identifier_type integer,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.patients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.patients_id_seq OWNED BY public.patients.id;


--
-- Name: price_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.price_lists (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status integer DEFAULT 0 NOT NULL
);


--
-- Name: price_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.price_lists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: price_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.price_lists_id_seq OWNED BY public.price_lists.id;


--
-- Name: prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prices (
    id bigint NOT NULL,
    amount numeric(8,2),
    price_list_id bigint NOT NULL,
    priceable_id bigint NOT NULL,
    priceable_type character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: prices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.prices_id_seq OWNED BY public.prices.id;


--
-- Name: qualified_intervals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.qualified_intervals (
    id bigint NOT NULL,
    range_low_value numeric,
    range_high_value numeric,
    old_gender character varying,
    old_min_age integer,
    old_max_age integer,
    old_age_unit character varying,
    lab_test_id bigint,
    animal_type integer,
    condition character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    category public.observation_range_category,
    context character varying,
    interpretation_id bigint,
    gender public.administrative_gender,
    age_low character varying,
    age_high character varying,
    gestational_age_low character varying,
    gestational_age_high character varying,
    rank integer
);


--
-- Name: qualified_intervals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.qualified_intervals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: qualified_intervals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.qualified_intervals_id_seq OWNED BY public.qualified_intervals.id;


--
-- Name: quote_line_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quote_line_items (
    id bigint NOT NULL,
    quote_id uuid NOT NULL,
    item_type character varying,
    item_id bigint,
    discount_value numeric DEFAULT 0.0 NOT NULL,
    discount_unit integer DEFAULT 0 NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: quote_line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quote_line_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quote_line_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quote_line_items_id_seq OWNED BY public.quote_line_items.id;


--
-- Name: quotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quotes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    serial_number bigint NOT NULL,
    price_list_id bigint NOT NULL,
    created_by_id bigint NOT NULL,
    approved_by_id bigint,
    expires_at timestamp(6) without time zone,
    approved_at timestamp(6) without time zone,
    service_request_id bigint,
    patient_id bigint,
    emailed_patient_at timestamp(6) without time zone,
    doctor_id bigint,
    status integer DEFAULT 0 NOT NULL,
    shipping_and_handling numeric DEFAULT 0.0 NOT NULL,
    note text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    parent_quote_id uuid,
    version_number integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.units (
    id bigint NOT NULL,
    expression character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ucum character varying,
    si character varying,
    conversion_factor numeric
);


--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying,
    email character varying,
    encrypted_password character varying NOT NULL,
    initials character varying,
    language character varying,
    last_request_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_at timestamp without time zone,
    last_sign_in_ip character varying,
    current_sign_in_ip character varying,
    sign_in_count integer DEFAULT 0 NOT NULL,
    first_name character varying(32),
    last_name character varying(32),
    prefix character varying(16),
    suffix character varying(16),
    admin boolean DEFAULT false NOT NULL,
    register character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_token character varying(255),
    remember_created_at timestamp without time zone,
    unlock_token character varying(255),
    locked_at timestamp without time zone,
    failed_attempts integer DEFAULT 0,
    signature text,
    descender boolean,
    webauthn_id character varying,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: webauthn_credentials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.webauthn_credentials (
    id bigint NOT NULL,
    external_id character varying NOT NULL,
    public_key character varying NOT NULL,
    nickname character varying NOT NULL,
    sign_count bigint DEFAULT 0 NOT NULL,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: webauthn_credentials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.webauthn_credentials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: webauthn_credentials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.webauthn_credentials_id_seq OWNED BY public.webauthn_credentials.id;


--
-- Name: accession_panels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accession_panels ALTER COLUMN id SET DEFAULT nextval('public.accession_panels_id_seq'::regclass);


--
-- Name: accessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accessions ALTER COLUMN id SET DEFAULT nextval('public.accessions_id_seq'::regclass);


--
-- Name: claims id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.claims ALTER COLUMN id SET DEFAULT nextval('public.claims_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: doctors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors ALTER COLUMN id SET DEFAULT nextval('public.doctors_id_seq'::regclass);


--
-- Name: insurance_providers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insurance_providers ALTER COLUMN id SET DEFAULT nextval('public.insurance_providers_id_seq'::regclass);


--
-- Name: lab_test_panels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lab_test_panels ALTER COLUMN id SET DEFAULT nextval('public.lab_test_panels_id_seq'::regclass);


--
-- Name: lab_test_value_option_joints id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lab_test_value_option_joints ALTER COLUMN id SET DEFAULT nextval('public.lab_test_value_option_joints_id_seq'::regclass);


--
-- Name: lab_test_values id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lab_test_values ALTER COLUMN id SET DEFAULT nextval('public.lab_test_values_id_seq'::regclass);


--
-- Name: lab_tests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lab_tests ALTER COLUMN id SET DEFAULT nextval('public.lab_tests_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- Name: observations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observations ALTER COLUMN id SET DEFAULT nextval('public.observations_id_seq'::regclass);


--
-- Name: panels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.panels ALTER COLUMN id SET DEFAULT nextval('public.panels_id_seq'::regclass);


--
-- Name: patients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients ALTER COLUMN id SET DEFAULT nextval('public.patients_id_seq'::regclass);


--
-- Name: price_lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_lists ALTER COLUMN id SET DEFAULT nextval('public.price_lists_id_seq'::regclass);


--
-- Name: prices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prices ALTER COLUMN id SET DEFAULT nextval('public.prices_id_seq'::regclass);


--
-- Name: qualified_intervals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.qualified_intervals ALTER COLUMN id SET DEFAULT nextval('public.qualified_intervals_id_seq'::regclass);


--
-- Name: quote_line_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quote_line_items ALTER COLUMN id SET DEFAULT nextval('public.quote_line_items_id_seq'::regclass);


--
-- Name: units id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: webauthn_credentials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webauthn_credentials ALTER COLUMN id SET DEFAULT nextval('public.webauthn_credentials_id_seq'::regclass);


--
-- Name: accession_panels accession_panels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accession_panels
    ADD CONSTRAINT accession_panels_pkey PRIMARY KEY (id);


--
-- Name: accessions accessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accessions
    ADD CONSTRAINT accessions_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: claims claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.claims
    ADD CONSTRAINT claims_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: insurance_providers insurance_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insurance_providers
    ADD CONSTRAINT insurance_providers_pkey PRIMARY KEY (id);


--
-- Name: lab_test_panels lab_test_panels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lab_test_panels
    ADD CONSTRAINT lab_test_panels_pkey PRIMARY KEY (id);


--
-- Name: lab_test_value_option_joints lab_test_value_option_joints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lab_test_value_option_joints
    ADD CONSTRAINT lab_test_value_option_joints_pkey PRIMARY KEY (id);


--
-- Name: lab_test_values lab_test_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lab_test_values
    ADD CONSTRAINT lab_test_values_pkey PRIMARY KEY (id);


--
-- Name: lab_tests lab_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lab_tests
    ADD CONSTRAINT lab_tests_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: observations observations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_pkey PRIMARY KEY (id);


--
-- Name: panels panels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.panels
    ADD CONSTRAINT panels_pkey PRIMARY KEY (id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: price_lists price_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_lists
    ADD CONSTRAINT price_lists_pkey PRIMARY KEY (id);


--
-- Name: prices prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prices
    ADD CONSTRAINT prices_pkey PRIMARY KEY (id);


--
-- Name: qualified_intervals qualified_intervals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.qualified_intervals
    ADD CONSTRAINT qualified_intervals_pkey PRIMARY KEY (id);


--
-- Name: quote_line_items quote_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quote_line_items
    ADD CONSTRAINT quote_line_items_pkey PRIMARY KEY (id);


--
-- Name: quotes quotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT quotes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: index_accession_panels_on_accession_id_and_panel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accession_panels_on_accession_id_and_panel_id ON public.accession_panels USING btree (accession_id, panel_id);


--
-- Name: index_accessions_on_doctor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accessions_on_doctor_id ON public.accessions USING btree (doctor_id);


--
-- Name: index_accessions_on_drawer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accessions_on_drawer_id ON public.accessions USING btree (drawer_id);


--
-- Name: index_accessions_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accessions_on_patient_id ON public.accessions USING btree (patient_id);


--
-- Name: index_accessions_on_receiver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accessions_on_receiver_id ON public.accessions USING btree (receiver_id);


--
-- Name: index_accessions_on_reporter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accessions_on_reporter_id ON public.accessions USING btree (reporter_id);


--
-- Name: index_claims_on_accession_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_claims_on_accession_id ON public.claims USING btree (accession_id);


--
-- Name: index_claims_on_claimed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_claims_on_claimed_at ON public.claims USING btree (claimed_at);


--
-- Name: index_claims_on_insurance_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_claims_on_insurance_provider_id ON public.claims USING btree (insurance_provider_id);


--
-- Name: index_departments_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_departments_on_name ON public.departments USING btree (name);


--
-- Name: index_departments_on_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_departments_on_position ON public.departments USING btree ("position");


--
-- Name: index_doctors_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_doctors_on_name ON public.doctors USING btree (name);


--
-- Name: index_insurance_providers_on_price_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_insurance_providers_on_price_list_id ON public.insurance_providers USING btree (price_list_id);


--
-- Name: index_lab_test_panels_on_lab_test_id_and_panel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_test_panels_on_lab_test_id_and_panel_id ON public.lab_test_panels USING btree (lab_test_id, panel_id);


--
-- Name: index_lab_test_value_option_joints_on_lab_test_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_test_value_option_joints_on_lab_test_id ON public.lab_test_value_option_joints USING btree (lab_test_id);


--
-- Name: index_lab_test_value_option_joints_on_lab_test_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_test_value_option_joints_on_lab_test_value_id ON public.lab_test_value_option_joints USING btree (lab_test_value_id);


--
-- Name: index_lab_tests_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_lab_tests_on_code ON public.lab_tests USING btree (code);


--
-- Name: index_lab_tests_on_department_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_tests_on_department_id ON public.lab_tests USING btree (department_id);


--
-- Name: index_lab_tests_on_loinc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_tests_on_loinc ON public.lab_tests USING btree (loinc);


--
-- Name: index_lab_tests_on_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_tests_on_position ON public.lab_tests USING btree ("position");


--
-- Name: index_lab_tests_on_unit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_tests_on_unit_id ON public.lab_tests USING btree (unit_id);


--
-- Name: index_notes_on_department_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_department_id ON public.notes USING btree (department_id);


--
-- Name: index_notes_on_noticeable_id_and_noticeable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_noticeable_id_and_noticeable_type ON public.notes USING btree (noticeable_id, noticeable_type);


--
-- Name: index_observations_on_accession_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_observations_on_accession_id ON public.observations USING btree (accession_id);


--
-- Name: index_observations_on_lab_test_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_observations_on_lab_test_id ON public.observations USING btree (lab_test_id);


--
-- Name: index_panels_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_panels_on_code ON public.panels USING btree (code);


--
-- Name: index_panels_on_loinc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_panels_on_loinc ON public.panels USING btree (loinc);


--
-- Name: index_panels_on_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_panels_on_position ON public.panels USING btree ("position");


--
-- Name: index_patients_on_insurance_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_insurance_provider_id ON public.patients USING btree (insurance_provider_id);


--
-- Name: index_patients_on_lower_family_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_lower_family_name ON public.patients USING btree (lower(public.my_unaccent((family_name)::text)));


--
-- Name: index_patients_on_partner_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_partner_name ON public.patients USING btree (partner_name);


--
-- Name: index_patients_on_policy_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_policy_number ON public.patients USING btree (policy_number);


--
-- Name: index_patients_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_updated_at ON public.patients USING btree (updated_at);


--
-- Name: index_patients_search; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_search ON public.patients USING gin (((((((to_tsvector('simple'::regconfig, public.my_unaccent(COALESCE((identifier)::text, ''::text))) || to_tsvector('simple'::regconfig, public.my_unaccent(COALESCE((family_name)::text, ''::text)))) || to_tsvector('simple'::regconfig, public.my_unaccent(COALESCE((family_name2)::text, ''::text)))) || to_tsvector('simple'::regconfig, public.my_unaccent(COALESCE((partner_name)::text, ''::text)))) || to_tsvector('simple'::regconfig, public.my_unaccent(COALESCE((given_name)::text, ''::text)))) || to_tsvector('simple'::regconfig, public.my_unaccent(COALESCE((middle_name)::text, ''::text))))));


--
-- Name: index_prices_on_price_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_prices_on_price_list_id ON public.prices USING btree (price_list_id);


--
-- Name: index_prices_on_priceable_id_and_priceable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_prices_on_priceable_id_and_priceable_type ON public.prices USING btree (priceable_id, priceable_type);


--
-- Name: index_qualified_intervals_on_interpretation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_qualified_intervals_on_interpretation_id ON public.qualified_intervals USING btree (interpretation_id);


--
-- Name: index_qualified_intervals_on_lab_test_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_qualified_intervals_on_lab_test_id ON public.qualified_intervals USING btree (lab_test_id);


--
-- Name: index_quote_line_items_on_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quote_line_items_on_item ON public.quote_line_items USING btree (item_type, item_id);


--
-- Name: index_quote_line_items_on_quote_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quote_line_items_on_quote_id ON public.quote_line_items USING btree (quote_id);


--
-- Name: index_quotes_on_approved_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_approved_by_id ON public.quotes USING btree (approved_by_id);


--
-- Name: index_quotes_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_created_by_id ON public.quotes USING btree (created_by_id);


--
-- Name: index_quotes_on_doctor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_doctor_id ON public.quotes USING btree (doctor_id);


--
-- Name: index_quotes_on_parent_quote_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_parent_quote_id ON public.quotes USING btree (parent_quote_id);


--
-- Name: index_quotes_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_patient_id ON public.quotes USING btree (patient_id);


--
-- Name: index_quotes_on_price_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_price_list_id ON public.quotes USING btree (price_list_id);


--
-- Name: index_quotes_on_serial_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_serial_number ON public.quotes USING btree (serial_number);


--
-- Name: index_quotes_on_service_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_service_request_id ON public.quotes USING btree (service_request_id);


--
-- Name: index_units_on_expression; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_units_on_expression ON public.units USING btree (expression);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON public.users USING btree (username);


--
-- Name: index_webauthn_credentials_on_external_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_webauthn_credentials_on_external_id ON public.webauthn_credentials USING btree (external_id);


--
-- Name: index_webauthn_credentials_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_webauthn_credentials_on_user_id ON public.webauthn_credentials USING btree (user_id);


--
-- Name: quote_line_items fk_rails_125d880df3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quote_line_items
    ADD CONSTRAINT fk_rails_125d880df3 FOREIGN KEY (quote_id) REFERENCES public.quotes(id);


--
-- Name: quotes fk_rails_4d07b0b28d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT fk_rails_4d07b0b28d FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: quotes fk_rails_7bf70aac95; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT fk_rails_7bf70aac95 FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: quotes fk_rails_a0b35899e1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT fk_rails_a0b35899e1 FOREIGN KEY (service_request_id) REFERENCES public.accessions(id);


--
-- Name: webauthn_credentials fk_rails_a4355aef77; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webauthn_credentials
    ADD CONSTRAINT fk_rails_a4355aef77 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: quotes fk_rails_aab6d70298; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT fk_rails_aab6d70298 FOREIGN KEY (price_list_id) REFERENCES public.price_lists(id);


--
-- Name: quotes fk_rails_b0ecd8cc37; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT fk_rails_b0ecd8cc37 FOREIGN KEY (doctor_id) REFERENCES public.doctors(id);


--
-- Name: quotes fk_rails_b7ab1b9172; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT fk_rails_b7ab1b9172 FOREIGN KEY (parent_quote_id) REFERENCES public.quotes(id);


--
-- Name: quotes fk_rails_e0eda0a328; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT fk_rails_e0eda0a328 FOREIGN KEY (approved_by_id) REFERENCES public.users(id);


--
-- Name: qualified_intervals fk_rails_fa3ecce1d4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.qualified_intervals
    ADD CONSTRAINT fk_rails_fa3ecce1d4 FOREIGN KEY (interpretation_id) REFERENCES public.lab_test_values(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20240112000000'),
('20230624000001'),
('20230612000006'),
('20230612000005'),
('20230612000004'),
('20230612000003'),
('20230612000002'),
('20230612000001'),
('20230611000002'),
('20230611000001'),
('20230607000001'),
('20230524000001'),
('20230517220001'),
('20201123000002'),
('20201123000001'),
('20201117000001'),
('20201023000002'),
('20201023000001'),
('20201017000002'),
('20201017000001'),
('20201005000001'),
('20201003000001'),
('20200929000001'),
('20200925000001'),
('20200922000001'),
('20200905000001'),
('20200824000002'),
('20200824000001'),
('20200806230748'),
('20180904171938'),
('20180704040107'),
('20180701205553'),
('20180610055354'),
('20180323000000'),
('20170922131801'),
('20170812200001'),
('20170812200000'),
('20170803000000'),
('20170507064755'),
('20161016181514'),
('20161016173522'),
('20150116215040'),
('20150116215039'),
('20141003113152'),
('20140911171632');


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

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
-- Name: my_unaccent(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.my_unaccent(text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT public.unaccent('public.unaccent', $1) $_$;


--
-- Name: accession_panels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accession_panels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accession_panels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accession_panels (
    id bigint DEFAULT nextval('public.accession_panels_id_seq'::regclass) NOT NULL,
    accession_id bigint,
    panel_id bigint,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: accessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accessions (
    id bigint DEFAULT nextval('public.accessions_id_seq'::regclass) NOT NULL,
    patient_id bigint,
    drawn_at timestamp with time zone,
    drawer_id bigint,
    received_at timestamp with time zone,
    receiver_id bigint,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    reported_at timestamp with time zone,
    reporter_id bigint,
    doctor_id bigint,
    icd9 character varying(510) DEFAULT NULL::character varying,
    emailed_doctor_at timestamp without time zone,
    emailed_patient_at timestamp without time zone,
    status public.diagnostic_report_status
);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: claims_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.claims_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.claims (
    id bigint DEFAULT nextval('public.claims_id_seq'::regclass) NOT NULL,
    accession_id bigint,
    number character varying(510) DEFAULT NULL::character varying,
    external_number character varying(510) DEFAULT NULL::character varying,
    claimed_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    insurance_provider_id bigint
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departments (
    id bigint DEFAULT nextval('public.departments_id_seq'::regclass) NOT NULL,
    name character varying(510) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.doctors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.doctors (
    id bigint DEFAULT nextval('public.doctors_id_seq'::regclass) NOT NULL,
    name character varying(510) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    gender character varying(510) DEFAULT NULL::character varying,
    email character varying,
    accessions_count integer DEFAULT 0
);


--
-- Name: insurance_providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.insurance_providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: insurance_providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.insurance_providers (
    id bigint DEFAULT nextval('public.insurance_providers_id_seq'::regclass) NOT NULL,
    name character varying(510) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    price_list_id bigint
);


--
-- Name: lab_test_panels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lab_test_panels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_test_panels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lab_test_panels (
    id bigint DEFAULT nextval('public.lab_test_panels_id_seq'::regclass) NOT NULL,
    lab_test_id bigint,
    panel_id bigint,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: lab_test_value_option_joints_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lab_test_value_option_joints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_test_value_option_joints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lab_test_value_option_joints (
    id bigint DEFAULT nextval('public.lab_test_value_option_joints_id_seq'::regclass) NOT NULL,
    lab_test_value_id bigint,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    lab_test_id bigint
);


--
-- Name: lab_test_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lab_test_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_test_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lab_test_values (
    id bigint DEFAULT nextval('public.lab_test_values_id_seq'::regclass) NOT NULL,
    value character varying(510) DEFAULT NULL::character varying,
    flag character varying(510) DEFAULT NULL::character varying,
    note text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    "numeric" boolean,
    snomed character varying,
    loinc character varying
);


--
-- Name: lab_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lab_tests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_tests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lab_tests (
    id bigint DEFAULT nextval('public.lab_tests_id_seq'::regclass) NOT NULL,
    code character varying(510) DEFAULT NULL::character varying,
    name character varying(510) DEFAULT NULL::character varying,
    description text,
    decimals integer,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    department_id bigint,
    unit_id bigint,
    procedure integer,
    derivation boolean,
    also_numeric boolean,
    ratio boolean,
    range boolean,
    fraction boolean,
    text_length integer,
    "position" integer,
    loinc character varying,
    remarks text
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notes (
    id bigint DEFAULT nextval('public.notes_id_seq'::regclass) NOT NULL,
    content text,
    department_id bigint,
    noticeable_id bigint,
    noticeable_type character varying(510) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: observations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.observations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: observations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.observations (
    id bigint DEFAULT nextval('public.observations_id_seq'::regclass) NOT NULL,
    value character varying(510) DEFAULT NULL::character varying,
    lab_test_id bigint,
    accession_id bigint,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    lab_test_value_id bigint,
    status public.observation_status,
    data_absent_reason public.data_absent_reason
);


--
-- Name: panels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.panels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: panels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.panels (
    id bigint DEFAULT nextval('public.panels_id_seq'::regclass) NOT NULL,
    code character varying(510) DEFAULT NULL::character varying,
    name character varying(510) DEFAULT NULL::character varying,
    description character varying(510) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    procedure integer,
    loinc character varying
);


--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patients (
    id bigint DEFAULT nextval('public.patients_id_seq'::regclass) NOT NULL,
    given_name character varying(510) DEFAULT NULL::character varying,
    middle_name character varying(510) DEFAULT NULL::character varying,
    family_name character varying(510) DEFAULT NULL::character varying,
    family_name2 character varying(510) DEFAULT NULL::character varying,
    gender character varying(510) DEFAULT NULL::character varying,
    birthdate date,
    identifier character varying(510) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    insurance_provider_id bigint,
    phone character varying(64) DEFAULT NULL::character varying,
    email character varying(128) DEFAULT NULL::character varying,
    animal_type integer,
    policy_number character varying(510) DEFAULT NULL::character varying,
    partner_name character varying,
    cellular character varying(32),
    address jsonb DEFAULT '{}'::jsonb,
    deceased boolean,
    identifier_type integer
);


--
-- Name: price_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.price_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: price_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.price_lists (
    id bigint DEFAULT nextval('public.price_lists_id_seq'::regclass) NOT NULL,
    name character varying(510) NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: prices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prices (
    id bigint DEFAULT nextval('public.prices_id_seq'::regclass) NOT NULL,
    amount numeric(8,2) DEFAULT NULL::numeric,
    price_list_id bigint NOT NULL,
    priceable_id bigint NOT NULL,
    priceable_type character varying(510) NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: qualified_intervals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.qualified_intervals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: qualified_intervals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.qualified_intervals (
    id bigint DEFAULT nextval('public.qualified_intervals_id_seq'::regclass) NOT NULL,
    old_gender character varying(510) DEFAULT NULL::character varying,
    old_min_age integer,
    old_max_age integer,
    old_age_unit character varying(510) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    lab_test_id bigint,
    range_low_value numeric,
    range_high_value numeric,
    animal_type integer,
    condition character varying,
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(510) NOT NULL
);


--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.units (
    id bigint DEFAULT nextval('public.units_id_seq'::regclass) NOT NULL,
    expression character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    ucum character varying,
    si character varying,
    conversion_factor numeric
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint DEFAULT nextval('public.users_id_seq'::regclass) NOT NULL,
    username character varying(510) DEFAULT NULL::character varying,
    email character varying(510) DEFAULT NULL::character varying,
    encrypted_password character varying(510) NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    initials character varying(510) DEFAULT NULL::character varying,
    language character varying(510) DEFAULT NULL::character varying,
    last_request_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    current_sign_in_at timestamp with time zone,
    last_sign_in_ip character varying(510) DEFAULT NULL::character varying,
    current_sign_in_ip character varying(510) DEFAULT NULL::character varying,
    sign_in_count integer DEFAULT 0 NOT NULL,
    first_name character varying(64) DEFAULT NULL::character varying,
    last_name character varying(64) DEFAULT NULL::character varying,
    prefix character varying(32) DEFAULT NULL::character varying,
    suffix character varying(32) DEFAULT NULL::character varying,
    admin boolean DEFAULT false NOT NULL,
    register character varying(510) DEFAULT NULL::character varying,
    confirmation_token character varying(510) DEFAULT NULL::character varying,
    confirmed_at timestamp with time zone,
    confirmation_sent_at timestamp with time zone,
    unconfirmed_email character varying(510) DEFAULT NULL::character varying,
    reset_password_token character varying(510) DEFAULT NULL::character varying,
    reset_password_sent_at timestamp with time zone,
    remember_token character varying(510) DEFAULT NULL::character varying,
    remember_created_at timestamp with time zone,
    unlock_token character varying(510) DEFAULT NULL::character varying,
    locked_at timestamp with time zone,
    failed_attempts integer DEFAULT 0,
    signature text,
    descender boolean
);


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
-- Name: index_accessions_on_reported_at_and_drawn_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accessions_on_reported_at_and_drawn_at ON public.accessions USING btree (reported_at, drawn_at);


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

CREATE INDEX index_lab_tests_on_code ON public.lab_tests USING btree (code);


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
-- Name: index_observations_on_lab_test_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_observations_on_lab_test_value_id ON public.observations USING btree (lab_test_value_id);


--
-- Name: index_panels_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_panels_on_code ON public.panels USING btree (code);


--
-- Name: index_panels_on_loinc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_panels_on_loinc ON public.panels USING btree (loinc);


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
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


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
('20140911171632'),
('20141003113152'),
('20150116215039'),
('20150116215040'),
('20161016173522'),
('20161016181514'),
('20170507064755'),
('20170803000000'),
('20170812200000'),
('20170812200001'),
('20170922131801'),
('20180323000000'),
('20180610055354'),
('20180701205553'),
('20180704040107'),
('20180904171938'),
('20200806230748'),
('20200824000001'),
('20200824000002'),
('20200905000001'),
('20200922000001'),
('20200925000001'),
('20200929000001'),
('20201003000001'),
('20201005000001'),
('20201017000001'),
('20201017000002'),
('20201023000001'),
('20201023000002');



SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET search_path = public, pg_catalog;

--
-- Name: my_unaccent(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION my_unaccent(character varying) RETURNS character varying
    LANGUAGE sql IMMUTABLE
    AS $_$ select unaccent('unaccent', $1::text); $_$;


--
-- Name: accession_panels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accession_panels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accession_panels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accession_panels (
    id integer DEFAULT nextval('accession_panels_id_seq'::regclass) NOT NULL,
    accession_id integer,
    panel_id integer,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: accessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accessions (
    id integer DEFAULT nextval('accessions_id_seq'::regclass) NOT NULL,
    patient_id integer,
    drawn_at timestamp with time zone,
    drawer_id integer,
    received_at timestamp with time zone,
    receiver_id integer,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    reported_at timestamp with time zone,
    reporter_id integer,
    doctor_id integer,
    icd9 character varying(510) DEFAULT NULL::character varying
);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: claims_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE claims_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE claims (
    id integer DEFAULT nextval('claims_id_seq'::regclass) NOT NULL,
    accession_id integer,
    number character varying(510) DEFAULT NULL::character varying,
    external_number character varying(510) DEFAULT NULL::character varying,
    claimed_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    insurance_provider_id integer
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE departments (
    id integer DEFAULT nextval('departments_id_seq'::regclass) NOT NULL,
    name character varying(510) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE doctors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE doctors (
    id integer DEFAULT nextval('doctors_id_seq'::regclass) NOT NULL,
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

CREATE SEQUENCE insurance_providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: insurance_providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE insurance_providers (
    id integer DEFAULT nextval('insurance_providers_id_seq'::regclass) NOT NULL,
    name character varying(510) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    price_list_id integer
);


--
-- Name: lab_test_panels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lab_test_panels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_test_panels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE lab_test_panels (
    id integer DEFAULT nextval('lab_test_panels_id_seq'::regclass) NOT NULL,
    lab_test_id integer,
    panel_id integer,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: lab_test_value_option_joints_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lab_test_value_option_joints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_test_value_option_joints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE lab_test_value_option_joints (
    id integer DEFAULT nextval('lab_test_value_option_joints_id_seq'::regclass) NOT NULL,
    lab_test_value_id integer,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    lab_test_id integer
);


--
-- Name: lab_test_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lab_test_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_test_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE lab_test_values (
    id integer DEFAULT nextval('lab_test_values_id_seq'::regclass) NOT NULL,
    value character varying(510) DEFAULT NULL::character varying,
    flag character varying(510) DEFAULT NULL::character varying,
    note text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: lab_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lab_tests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lab_tests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE lab_tests (
    id integer DEFAULT nextval('lab_tests_id_seq'::regclass) NOT NULL,
    code character varying(510) DEFAULT NULL::character varying,
    name character varying(510) DEFAULT NULL::character varying,
    description text,
    decimals integer,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    department_id integer,
    unit_id integer,
    procedure integer,
    derivation boolean,
    also_numeric boolean,
    ratio boolean,
    range boolean,
    fraction boolean,
    text_length integer,
    "position" integer
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notes (
    id integer DEFAULT nextval('notes_id_seq'::regclass) NOT NULL,
    content text,
    department_id integer,
    noticeable_id integer,
    noticeable_type character varying(510) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: panels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE panels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: panels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE panels (
    id integer DEFAULT nextval('panels_id_seq'::regclass) NOT NULL,
    code character varying(510) DEFAULT NULL::character varying,
    name character varying(510) DEFAULT NULL::character varying,
    description character varying(510) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    procedure integer
);


--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE patients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE patients (
    id integer DEFAULT nextval('patients_id_seq'::regclass) NOT NULL,
    given_name character varying(510) DEFAULT NULL::character varying,
    middle_name character varying(510) DEFAULT NULL::character varying,
    family_name character varying(510) DEFAULT NULL::character varying,
    family_name2 character varying(510) DEFAULT NULL::character varying,
    gender character varying(510) DEFAULT NULL::character varying,
    birthdate date,
    identifier character varying(510) DEFAULT NULL::character varying,
    address text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    insurance_provider_id integer,
    phone character varying(64) DEFAULT NULL::character varying,
    email character varying(128) DEFAULT NULL::character varying,
    animal_type integer,
    policy_number character varying(510) DEFAULT NULL::character varying,
    partner_name character varying
);


--
-- Name: price_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE price_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: price_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE price_lists (
    id integer DEFAULT nextval('price_lists_id_seq'::regclass) NOT NULL,
    name character varying(510) NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: prices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE prices (
    id integer DEFAULT nextval('prices_id_seq'::regclass) NOT NULL,
    amount numeric(8,2) DEFAULT NULL::numeric,
    price_list_id integer NOT NULL,
    priceable_id integer NOT NULL,
    priceable_type character varying(510) NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: reference_ranges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reference_ranges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reference_ranges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE reference_ranges (
    id integer DEFAULT nextval('reference_ranges_id_seq'::regclass) NOT NULL,
    gender character varying(510) DEFAULT NULL::character varying,
    min_age integer,
    max_age integer,
    age_unit character varying(510) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    lab_test_id integer,
    min numeric(15,5) DEFAULT NULL::numeric,
    max numeric(15,5) DEFAULT NULL::numeric,
    animal_type integer,
    description character varying(510) DEFAULT NULL::character varying
);


--
-- Name: results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE results (
    id integer DEFAULT nextval('results_id_seq'::regclass) NOT NULL,
    value character varying(510) DEFAULT NULL::character varying,
    lab_test_id integer,
    accession_id integer,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    lab_test_value_id integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying(510) NOT NULL
);


--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE units (
    id integer DEFAULT nextval('units_id_seq'::regclass) NOT NULL,
    name character varying(510) DEFAULT NULL::character varying,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer DEFAULT nextval('users_id_seq'::regclass) NOT NULL,
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
    failed_attempts integer DEFAULT 0
);


--
-- Name: accession_panels accession_panels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accession_panels
    ADD CONSTRAINT accession_panels_pkey PRIMARY KEY (id);


--
-- Name: accessions accessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accessions
    ADD CONSTRAINT accessions_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: claims claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY claims
    ADD CONSTRAINT claims_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: insurance_providers insurance_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY insurance_providers
    ADD CONSTRAINT insurance_providers_pkey PRIMARY KEY (id);


--
-- Name: lab_test_panels lab_test_panels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lab_test_panels
    ADD CONSTRAINT lab_test_panels_pkey PRIMARY KEY (id);


--
-- Name: lab_test_value_option_joints lab_test_value_option_joints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lab_test_value_option_joints
    ADD CONSTRAINT lab_test_value_option_joints_pkey PRIMARY KEY (id);


--
-- Name: lab_test_values lab_test_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lab_test_values
    ADD CONSTRAINT lab_test_values_pkey PRIMARY KEY (id);


--
-- Name: lab_tests lab_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lab_tests
    ADD CONSTRAINT lab_tests_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: panels panels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY panels
    ADD CONSTRAINT panels_pkey PRIMARY KEY (id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: price_lists price_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY price_lists
    ADD CONSTRAINT price_lists_pkey PRIMARY KEY (id);


--
-- Name: prices prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY prices
    ADD CONSTRAINT prices_pkey PRIMARY KEY (id);


--
-- Name: reference_ranges reference_ranges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reference_ranges
    ADD CONSTRAINT reference_ranges_pkey PRIMARY KEY (id);


--
-- Name: results results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_accession_panels_on_accession_id_and_panel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accession_panels_on_accession_id_and_panel_id ON accession_panels USING btree (accession_id, panel_id);


--
-- Name: index_accessions_on_doctor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accessions_on_doctor_id ON accessions USING btree (doctor_id);


--
-- Name: index_accessions_on_drawer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accessions_on_drawer_id ON accessions USING btree (drawer_id);


--
-- Name: index_accessions_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accessions_on_patient_id ON accessions USING btree (patient_id);


--
-- Name: index_accessions_on_receiver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accessions_on_receiver_id ON accessions USING btree (receiver_id);


--
-- Name: index_accessions_on_reported_at_and_drawn_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accessions_on_reported_at_and_drawn_at ON accessions USING btree (reported_at, drawn_at);


--
-- Name: index_accessions_on_reporter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accessions_on_reporter_id ON accessions USING btree (reporter_id);


--
-- Name: index_claims_on_accession_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_claims_on_accession_id ON claims USING btree (accession_id);


--
-- Name: index_claims_on_claimed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_claims_on_claimed_at ON claims USING btree (claimed_at);


--
-- Name: index_claims_on_insurance_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_claims_on_insurance_provider_id ON claims USING btree (insurance_provider_id);


--
-- Name: index_departments_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_departments_on_name ON departments USING btree (name);


--
-- Name: index_doctors_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_doctors_on_name ON doctors USING btree (name);


--
-- Name: index_insurance_providers_on_price_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_insurance_providers_on_price_list_id ON insurance_providers USING btree (price_list_id);


--
-- Name: index_lab_test_panels_on_lab_test_id_and_panel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_test_panels_on_lab_test_id_and_panel_id ON lab_test_panels USING btree (lab_test_id, panel_id);


--
-- Name: index_lab_test_value_option_joints_on_lab_test_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_test_value_option_joints_on_lab_test_id ON lab_test_value_option_joints USING btree (lab_test_id);


--
-- Name: index_lab_test_value_option_joints_on_lab_test_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_test_value_option_joints_on_lab_test_value_id ON lab_test_value_option_joints USING btree (lab_test_value_id);


--
-- Name: index_lab_tests_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_tests_on_code ON lab_tests USING btree (code);


--
-- Name: index_lab_tests_on_department_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_tests_on_department_id ON lab_tests USING btree (department_id);


--
-- Name: index_lab_tests_on_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_tests_on_position ON lab_tests USING btree ("position");


--
-- Name: index_lab_tests_on_unit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lab_tests_on_unit_id ON lab_tests USING btree (unit_id);


--
-- Name: index_notes_on_department_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_department_id ON notes USING btree (department_id);


--
-- Name: index_notes_on_noticeable_id_and_noticeable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_noticeable_id_and_noticeable_type ON notes USING btree (noticeable_id, noticeable_type);


--
-- Name: index_panels_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_panels_on_code ON panels USING btree (code);


--
-- Name: index_patients_on_insurance_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_insurance_provider_id ON patients USING btree (insurance_provider_id);


--
-- Name: index_patients_on_lower_family_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_lower_family_name ON patients USING btree (lower((my_unaccent(family_name))::text));


--
-- Name: index_patients_on_partner_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_partner_name ON patients USING btree (partner_name);


--
-- Name: index_patients_on_policy_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_policy_number ON patients USING btree (policy_number);


--
-- Name: index_patients_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_updated_at ON patients USING btree (updated_at);


--
-- Name: index_patients_search; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_search ON patients USING gin (((((((to_tsvector('simple'::regconfig, (my_unaccent((COALESCE((identifier)::text, ''::text))::character varying))::text) || to_tsvector('simple'::regconfig, (my_unaccent((COALESCE((family_name)::text, ''::text))::character varying))::text)) || to_tsvector('simple'::regconfig, (my_unaccent((COALESCE((family_name2)::text, ''::text))::character varying))::text)) || to_tsvector('simple'::regconfig, (my_unaccent((COALESCE((partner_name)::text, ''::text))::character varying))::text)) || to_tsvector('simple'::regconfig, (my_unaccent((COALESCE((given_name)::text, ''::text))::character varying))::text)) || to_tsvector('simple'::regconfig, (my_unaccent((COALESCE((middle_name)::text, ''::text))::character varying))::text))));


--
-- Name: index_prices_on_price_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_prices_on_price_list_id ON prices USING btree (price_list_id);


--
-- Name: index_prices_on_priceable_id_and_priceable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_prices_on_priceable_id_and_priceable_type ON prices USING btree (priceable_id, priceable_type);


--
-- Name: index_reference_ranges_on_lab_test_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reference_ranges_on_lab_test_id ON reference_ranges USING btree (lab_test_id);


--
-- Name: index_results_on_accession_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_results_on_accession_id ON results USING btree (accession_id);


--
-- Name: index_results_on_lab_test_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_results_on_lab_test_id ON results USING btree (lab_test_id);


--
-- Name: index_results_on_lab_test_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_results_on_lab_test_value_id ON results USING btree (lab_test_value_id);


--
-- Name: index_units_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_units_on_name ON units USING btree (name);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


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
('20170812200001');



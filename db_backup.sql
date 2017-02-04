--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: answer; Type: TYPE; Schema: public; Owner: postgres
--

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: questions; Type: TABLE; Schema: public; Owner: wzsaizbidqbckt
--

CREATE TABLE questions (
    id integer NOT NULL,
    text text NOT NULL,
    answers text[]
);


ALTER TABLE questions OWNER TO wzsaizbidqbckt;

--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: wzsaizbidqbckt
--

COPY questions (id, text, answers) FROM stdin;
\.


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: wzsaizbidqbckt
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--


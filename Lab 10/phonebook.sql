--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 16.8

-- Started on 2025-04-20 15:52:59

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16399)
-- Name: phonebook; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.phonebook (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    phone character varying(20) NOT NULL
);


ALTER TABLE public.phonebook OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16398)
-- Name: phonebook_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.phonebook_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.phonebook_id_seq OWNER TO postgres;

--
-- TOC entry 4787 (class 0 OID 0)
-- Dependencies: 215
-- Name: phonebook_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.phonebook_id_seq OWNED BY public.phonebook.id;


--
-- TOC entry 4634 (class 2604 OID 16402)
-- Name: phonebook id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phonebook ALTER COLUMN id SET DEFAULT nextval('public.phonebook_id_seq'::regclass);


--
-- TOC entry 4781 (class 0 OID 16399)
-- Dependencies: 216
-- Data for Name: phonebook; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.phonebook (id, name, phone) FROM stdin;
2	Aliya	+77001112233
3	Timur	+77009998877
4	Diana	+77005554433
5	Nursultan	+77007776655
\.


--
-- TOC entry 4788 (class 0 OID 0)
-- Dependencies: 215
-- Name: phonebook_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.phonebook_id_seq', 5, true);


--
-- TOC entry 4636 (class 2606 OID 16404)
-- Name: phonebook phonebook_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phonebook
    ADD CONSTRAINT phonebook_pkey PRIMARY KEY (id);


-- Completed on 2025-04-20 15:52:59

--
-- PostgreSQL database dump complete
--


--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 16.8

-- Started on 2025-04-20 16:43:41

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
-- TOC entry 216 (class 1259 OID 16407)
-- Name: game_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.game_user (
    id integer NOT NULL,
    username character varying(50) NOT NULL
);


ALTER TABLE public.game_user OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16406)
-- Name: game_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.game_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.game_user_id_seq OWNER TO postgres;

--
-- TOC entry 4802 (class 0 OID 0)
-- Dependencies: 215
-- Name: game_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.game_user_id_seq OWNED BY public.game_user.id;


--
-- TOC entry 218 (class 1259 OID 16416)
-- Name: user_score; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_score (
    id integer NOT NULL,
    user_id integer,
    level integer NOT NULL,
    score integer DEFAULT 0,
    state text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_score OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16415)
-- Name: user_score_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_score_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_score_id_seq OWNER TO postgres;

--
-- TOC entry 4803 (class 0 OID 0)
-- Dependencies: 217
-- Name: user_score_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_score_id_seq OWNED BY public.user_score.id;


--
-- TOC entry 4639 (class 2604 OID 16410)
-- Name: game_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_user ALTER COLUMN id SET DEFAULT nextval('public.game_user_id_seq'::regclass);


--
-- TOC entry 4640 (class 2604 OID 16419)
-- Name: user_score id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_score ALTER COLUMN id SET DEFAULT nextval('public.user_score_id_seq'::regclass);


--
-- TOC entry 4794 (class 0 OID 16407)
-- Dependencies: 216
-- Data for Name: game_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.game_user (id, username) FROM stdin;
1	postgre
2	yasmina
3	postgres
\.


--
-- TOC entry 4796 (class 0 OID 16416)
-- Dependencies: 218
-- Data for Name: user_score; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_score (id, user_id, level, score, state, created_at) FROM stdin;
1	2	1	0	{"snake": [[580, 100], [560, 100], [540, 100]], "food": [360, 220], "direction": [20, 0]}	2025-04-20 16:38:06.332334
2	3	1	0	{"snake": [[580, 100], [560, 100], [540, 100]], "food": [60, 40], "direction": [20, 0]}	2025-04-20 16:38:20.004613
3	3	1	0	{"snake": [[580, 100], [560, 100], [540, 100]], "food": [480, 120], "direction": [20, 0]}	2025-04-20 16:38:37.676402
4	3	1	0	{"snake": [[580, 100], [560, 100], [540, 100]], "food": [300, 120], "direction": [20, 0]}	2025-04-20 16:42:08.118977
5	2	1	0	{"snake": [[580, 380], [580, 360], [580, 340]], "food": [460, 360], "direction": [0, 20]}	2025-04-20 16:42:24.574111
\.


--
-- TOC entry 4804 (class 0 OID 0)
-- Dependencies: 215
-- Name: game_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.game_user_id_seq', 3, true);


--
-- TOC entry 4805 (class 0 OID 0)
-- Dependencies: 217
-- Name: user_score_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_score_id_seq', 5, true);


--
-- TOC entry 4644 (class 2606 OID 16412)
-- Name: game_user game_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_user
    ADD CONSTRAINT game_user_pkey PRIMARY KEY (id);


--
-- TOC entry 4646 (class 2606 OID 16414)
-- Name: game_user game_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_user
    ADD CONSTRAINT game_user_username_key UNIQUE (username);


--
-- TOC entry 4648 (class 2606 OID 16425)
-- Name: user_score user_score_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_score
    ADD CONSTRAINT user_score_pkey PRIMARY KEY (id);


--
-- TOC entry 4649 (class 2606 OID 16426)
-- Name: user_score user_score_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_score
    ADD CONSTRAINT user_score_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.game_user(id);


-- Completed on 2025-04-20 16:43:42

--
-- PostgreSQL database dump complete
--


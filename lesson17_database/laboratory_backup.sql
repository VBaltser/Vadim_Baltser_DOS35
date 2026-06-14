--
-- PostgreSQL database dump
--

\restrict GCUjEJ3RhDOTQSYIVIXPGEWTFHfJktcDSKIJ992qp0hrbb81ym362roH74UgMPc

-- Dumped from database version 16.14 (Ubuntu 16.14-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.14 (Ubuntu 16.14-0ubuntu0.24.04.1)

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
-- Name: analysis; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.analysis (
    an_id integer NOT NULL,
    an_name character varying(200) NOT NULL,
    an_cost numeric(10,2) NOT NULL,
    an_price numeric(10,2) NOT NULL,
    an_group integer NOT NULL,
    CONSTRAINT analysis_an_cost_check CHECK ((an_cost >= (0)::numeric)),
    CONSTRAINT analysis_an_price_check CHECK ((an_price >= (0)::numeric))
);


ALTER TABLE public.analysis OWNER TO admin;

--
-- Name: analysis_an_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.analysis_an_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.analysis_an_id_seq OWNER TO admin;

--
-- Name: analysis_an_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.analysis_an_id_seq OWNED BY public.analysis.an_id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.groups (
    gr_id integer NOT NULL,
    gr_name character varying(100) NOT NULL,
    gr_temp character varying(50) NOT NULL
);


ALTER TABLE public.groups OWNER TO admin;

--
-- Name: groups_gr_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.groups_gr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groups_gr_id_seq OWNER TO admin;

--
-- Name: groups_gr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.groups_gr_id_seq OWNED BY public.groups.gr_id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.orders (
    ord_id integer NOT NULL,
    ord_datetime timestamp without time zone DEFAULT now() NOT NULL,
    ord_an integer NOT NULL
);


ALTER TABLE public.orders OWNER TO admin;

--
-- Name: orders_ord_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.orders_ord_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_ord_id_seq OWNER TO admin;

--
-- Name: orders_ord_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.orders_ord_id_seq OWNED BY public.orders.ord_id;


--
-- Name: analysis an_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.analysis ALTER COLUMN an_id SET DEFAULT nextval('public.analysis_an_id_seq'::regclass);


--
-- Name: groups gr_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.groups ALTER COLUMN gr_id SET DEFAULT nextval('public.groups_gr_id_seq'::regclass);


--
-- Name: orders ord_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.orders ALTER COLUMN ord_id SET DEFAULT nextval('public.orders_ord_id_seq'::regclass);


--
-- Data for Name: analysis; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.analysis (an_id, an_name, an_cost, an_price, an_group) FROM stdin;
1	Глюкоза	45.00	120.00	1
2	АЛТ	55.00	150.00	1
3	АСТ	55.00	150.00	1
4	Общий анализ крови	80.00	250.00	2
5	СОЭ	30.00	90.00	2
6	Ферритин	90.00	280.00	3
7	ТТГ	110.00	350.00	5
8	Посев на флору	120.00	400.00	4
9	Креатинин	50.00	130.00	1
10	Витамин D	150.00	500.00	3
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.groups (gr_id, gr_name, gr_temp) FROM stdin;
1	Биохимия	+2...+8 °C
2	Гематология	+18...+25 °C
3	Иммунология	-20 °C
4	Микробиология	+2...+8 °C
5	Гормоны	+2...+8 °C
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.orders (ord_id, ord_datetime, ord_an) FROM stdin;
1	2026-06-01 09:15:00	1
2	2026-06-01 09:15:00	4
3	2026-06-01 10:30:00	2
4	2026-06-01 11:00:00	7
5	2026-06-02 08:45:00	4
6	2026-06-02 08:45:00	5
7	2026-06-02 14:20:00	10
8	2026-06-03 09:00:00	1
9	2026-06-03 09:00:00	3
10	2026-06-03 09:00:00	8
11	2026-06-04 16:50:00	6
12	2026-06-05 07:30:00	9
\.


--
-- Name: analysis_an_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.analysis_an_id_seq', 10, true);


--
-- Name: groups_gr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.groups_gr_id_seq', 5, true);


--
-- Name: orders_ord_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.orders_ord_id_seq', 12, true);


--
-- Name: analysis analysis_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.analysis
    ADD CONSTRAINT analysis_pkey PRIMARY KEY (an_id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (gr_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (ord_id);


--
-- Name: analysis analysis_an_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.analysis
    ADD CONSTRAINT analysis_an_group_fkey FOREIGN KEY (an_group) REFERENCES public.groups(gr_id);


--
-- Name: orders orders_ord_an_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_ord_an_fkey FOREIGN KEY (ord_an) REFERENCES public.analysis(an_id);


--
-- PostgreSQL database dump complete
--

\unrestrict GCUjEJ3RhDOTQSYIVIXPGEWTFHfJktcDSKIJ992qp0hrbb81ym362roH74UgMPc


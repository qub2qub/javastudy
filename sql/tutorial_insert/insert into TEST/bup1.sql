--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.5
-- Dumped by pg_dump version 9.4.5
-- Started on 2016-04-22 16:13:25 MSK

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 7 (class 2615 OID 16385)
-- Name: test; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA test;


ALTER SCHEMA test OWNER TO postgres;

SET search_path = test, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 186 (class 1259 OID 16758)
-- Name: category; Type: TABLE; Schema: test; Owner: postgres; Tablespace: 
--

CREATE TABLE category (
    id bigint NOT NULL,
    title character varying(255),
    parent_category bigint
);


ALTER TABLE category OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 16756)
-- Name: category_id_seq; Type: SEQUENCE; Schema: test; Owner: postgres
--

CREATE SEQUENCE category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE category_id_seq OWNER TO postgres;

--
-- TOC entry 2195 (class 0 OID 0)
-- Dependencies: 185
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: postgres
--

ALTER SEQUENCE category_id_seq OWNED BY category.id;


--
-- TOC entry 184 (class 1259 OID 16499)
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: test; Owner: postgres
--

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hibernate_sequence OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 16766)
-- Name: order; Type: TABLE; Schema: test; Owner: postgres; Tablespace: 
--

CREATE TABLE "order" (
    id bigint NOT NULL,
    status boolean,
    user_id bigint
);


ALTER TABLE "order" OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 16764)
-- Name: order_id_seq; Type: SEQUENCE; Schema: test; Owner: postgres
--

CREATE SEQUENCE order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE order_id_seq OWNER TO postgres;

--
-- TOC entry 2196 (class 0 OID 0)
-- Dependencies: 187
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: postgres
--

ALTER SEQUENCE order_id_seq OWNED BY "order".id;


--
-- TOC entry 190 (class 1259 OID 16774)
-- Name: order_item; Type: TABLE; Schema: test; Owner: postgres; Tablespace: 
--

CREATE TABLE order_item (
    id bigint NOT NULL,
    count integer,
    sell_price numeric(19,2),
    order_id bigint,
    product_id bigint
);


ALTER TABLE order_item OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 16772)
-- Name: order_item_id_seq; Type: SEQUENCE; Schema: test; Owner: postgres
--

CREATE SEQUENCE order_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE order_item_id_seq OWNER TO postgres;

--
-- TOC entry 2197 (class 0 OID 0)
-- Dependencies: 189
-- Name: order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: postgres
--

ALTER SEQUENCE order_item_id_seq OWNED BY order_item.id;


--
-- TOC entry 192 (class 1259 OID 16782)
-- Name: person; Type: TABLE; Schema: test; Owner: postgres; Tablespace: 
--

CREATE TABLE person (
    id bigint NOT NULL,
    age integer,
    firstname character varying(255),
    lastname character varying(255),
    salary numeric(19,2)
);


ALTER TABLE person OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 16780)
-- Name: person_id_seq; Type: SEQUENCE; Schema: test; Owner: postgres
--

CREATE SEQUENCE person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person_id_seq OWNER TO postgres;

--
-- TOC entry 2198 (class 0 OID 0)
-- Dependencies: 191
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: postgres
--

ALTER SEQUENCE person_id_seq OWNED BY person.id;


--
-- TOC entry 194 (class 1259 OID 16793)
-- Name: product; Type: TABLE; Schema: test; Owner: postgres; Tablespace: 
--

CREATE TABLE product (
    id bigint NOT NULL,
    description character varying(255),
    price numeric(19,2),
    title character varying(255),
    product_category_id bigint
);


ALTER TABLE product OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 16791)
-- Name: product_id_seq; Type: SEQUENCE; Schema: test; Owner: postgres
--

CREATE SEQUENCE product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE product_id_seq OWNER TO postgres;

--
-- TOC entry 2199 (class 0 OID 0)
-- Dependencies: 193
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: postgres
--

ALTER SEQUENCE product_id_seq OWNED BY product.id;


--
-- TOC entry 196 (class 1259 OID 16804)
-- Name: role; Type: TABLE; Schema: test; Owner: postgres; Tablespace: 
--

CREATE TABLE role (
    id bigint NOT NULL,
    title character varying(255)
);


ALTER TABLE role OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 16802)
-- Name: role_id_seq; Type: SEQUENCE; Schema: test; Owner: postgres
--

CREATE SEQUENCE role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE role_id_seq OWNER TO postgres;

--
-- TOC entry 2200 (class 0 OID 0)
-- Dependencies: 195
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: postgres
--

ALTER SEQUENCE role_id_seq OWNED BY role.id;


--
-- TOC entry 198 (class 1259 OID 16812)
-- Name: users; Type: TABLE; Schema: test; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id bigint NOT NULL,
    person_id bigint
);


ALTER TABLE users OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 16810)
-- Name: users_id_seq; Type: SEQUENCE; Schema: test; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO postgres;

--
-- TOC entry 2201 (class 0 OID 0)
-- Dependencies: 197
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: postgres
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- TOC entry 199 (class 1259 OID 16818)
-- Name: users_roles; Type: TABLE; Schema: test; Owner: postgres; Tablespace: 
--

CREATE TABLE users_roles (
    user_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE users_roles OWNER TO postgres;

--
-- TOC entry 2035 (class 2604 OID 16761)
-- Name: id; Type: DEFAULT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY category ALTER COLUMN id SET DEFAULT nextval('category_id_seq'::regclass);


--
-- TOC entry 2036 (class 2604 OID 16769)
-- Name: id; Type: DEFAULT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY "order" ALTER COLUMN id SET DEFAULT nextval('order_id_seq'::regclass);


--
-- TOC entry 2037 (class 2604 OID 16777)
-- Name: id; Type: DEFAULT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY order_item ALTER COLUMN id SET DEFAULT nextval('order_item_id_seq'::regclass);


--
-- TOC entry 2038 (class 2604 OID 16785)
-- Name: id; Type: DEFAULT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY person ALTER COLUMN id SET DEFAULT nextval('person_id_seq'::regclass);


--
-- TOC entry 2039 (class 2604 OID 16796)
-- Name: id; Type: DEFAULT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY product ALTER COLUMN id SET DEFAULT nextval('product_id_seq'::regclass);


--
-- TOC entry 2040 (class 2604 OID 16807)
-- Name: id; Type: DEFAULT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY role ALTER COLUMN id SET DEFAULT nextval('role_id_seq'::regclass);


--
-- TOC entry 2041 (class 2604 OID 16815)
-- Name: id; Type: DEFAULT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- TOC entry 2177 (class 0 OID 16758)
-- Dependencies: 186
-- Data for Name: category; Type: TABLE DATA; Schema: test; Owner: postgres
--

COPY category (id, title, parent_category) FROM stdin;
1	ROOT	\N
2	Electronics	1
3	PC	2
4	Laptop	2
5	Printer	2
\.


--
-- TOC entry 2202 (class 0 OID 0)
-- Dependencies: 185
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: test; Owner: postgres
--

SELECT pg_catalog.setval('category_id_seq', 5, true);


--
-- TOC entry 2203 (class 0 OID 0)
-- Dependencies: 184
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: test; Owner: postgres
--

SELECT pg_catalog.setval('hibernate_sequence', 14, true);


--
-- TOC entry 2179 (class 0 OID 16766)
-- Dependencies: 188
-- Data for Name: order; Type: TABLE DATA; Schema: test; Owner: postgres
--

COPY "order" (id, status, user_id) FROM stdin;
1	f	1
2	t	2
3	t	1
\.


--
-- TOC entry 2204 (class 0 OID 0)
-- Dependencies: 187
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: test; Owner: postgres
--

SELECT pg_catalog.setval('order_id_seq', 3, true);


--
-- TOC entry 2181 (class 0 OID 16774)
-- Dependencies: 190
-- Data for Name: order_item; Type: TABLE DATA; Schema: test; Owner: postgres
--

COPY order_item (id, count, sell_price, order_id, product_id) FROM stdin;
1	1	200.00	1	1
2	2	450.00	2	2
3	2	200.00	3	1
\.


--
-- TOC entry 2205 (class 0 OID 0)
-- Dependencies: 189
-- Name: order_item_id_seq; Type: SEQUENCE SET; Schema: test; Owner: postgres
--

SELECT pg_catalog.setval('order_item_id_seq', 3, true);


--
-- TOC entry 2183 (class 0 OID 16782)
-- Dependencies: 192
-- Data for Name: person; Type: TABLE DATA; Schema: test; Owner: postgres
--

COPY person (id, age, firstname, lastname, salary) FROM stdin;
1	30	Ivan	Petrov	123000.00
2	45	Sidor	Kruglov	45600.00
\.


--
-- TOC entry 2206 (class 0 OID 0)
-- Dependencies: 191
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: test; Owner: postgres
--

SELECT pg_catalog.setval('person_id_seq', 2, true);


--
-- TOC entry 2185 (class 0 OID 16793)
-- Dependencies: 194
-- Data for Name: product; Type: TABLE DATA; Schema: test; Owner: postgres
--

COPY product (id, description, price, title, product_category_id) FROM stdin;
2	Inspiron i5558	450.00	Dell Laptop	4
1	Old computer from 2009	200.00	Desctop_Intel	3
4	Retina, Core i7, 16Gb	1800.00	MacBook Pro 15"	4
3	Basic BW printer	100.00	HP M1132 Printer	5
5	Office works	600.00	Compaq Tower	3
6	Huge Big Scanner and Printer	999.00	Xerox MultiWork	5
7	Game NoteBook MSI	999.00	AlienWare	4
\.


--
-- TOC entry 2207 (class 0 OID 0)
-- Dependencies: 193
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: test; Owner: postgres
--

SELECT pg_catalog.setval('product_id_seq', 7, true);


--
-- TOC entry 2187 (class 0 OID 16804)
-- Dependencies: 196
-- Data for Name: role; Type: TABLE DATA; Schema: test; Owner: postgres
--

COPY role (id, title) FROM stdin;
\.


--
-- TOC entry 2208 (class 0 OID 0)
-- Dependencies: 195
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: test; Owner: postgres
--

SELECT pg_catalog.setval('role_id_seq', 1, false);


--
-- TOC entry 2189 (class 0 OID 16812)
-- Dependencies: 198
-- Data for Name: users; Type: TABLE DATA; Schema: test; Owner: postgres
--

COPY users (id, person_id) FROM stdin;
1	1
2	2
\.


--
-- TOC entry 2209 (class 0 OID 0)
-- Dependencies: 197
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: test; Owner: postgres
--

SELECT pg_catalog.setval('users_id_seq', 2, true);


--
-- TOC entry 2190 (class 0 OID 16818)
-- Dependencies: 199
-- Data for Name: users_roles; Type: TABLE DATA; Schema: test; Owner: postgres
--

COPY users_roles (user_id, role_id) FROM stdin;
\.


--
-- TOC entry 2043 (class 2606 OID 16763)
-- Name: category_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- TOC entry 2047 (class 2606 OID 16779)
-- Name: order_item_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- TOC entry 2045 (class 2606 OID 16771)
-- Name: order_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- TOC entry 2049 (class 2606 OID 16790)
-- Name: person_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- TOC entry 2051 (class 2606 OID 16801)
-- Name: product_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 2053 (class 2606 OID 16809)
-- Name: role_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- TOC entry 2055 (class 2606 OID 16817)
-- Name: users_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2057 (class 2606 OID 16822)
-- Name: users_roles_pkey; Type: CONSTRAINT; Schema: test; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users_roles
    ADD CONSTRAINT users_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- TOC entry 2065 (class 2606 OID 16858)
-- Name: fk2o0jvgh89lemvvo17cbqvdxaa; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY users_roles
    ADD CONSTRAINT fk2o0jvgh89lemvvo17cbqvdxaa FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 2061 (class 2606 OID 16838)
-- Name: fk551losx9j75ss5d6bfsqvijna; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fk551losx9j75ss5d6bfsqvijna FOREIGN KEY (product_id) REFERENCES product(id);


--
-- TOC entry 2058 (class 2606 OID 16823)
-- Name: fkaicb6e7sl98i1qgcisd5kjkbs; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY category
    ADD CONSTRAINT fkaicb6e7sl98i1qgcisd5kjkbs FOREIGN KEY (parent_category) REFERENCES category(id);


--
-- TOC entry 2063 (class 2606 OID 16848)
-- Name: fkd21kkcigxa21xuby5i3va9ncs; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fkd21kkcigxa21xuby5i3va9ncs FOREIGN KEY (person_id) REFERENCES person(id);


--
-- TOC entry 2062 (class 2606 OID 16843)
-- Name: fkid4vcfgj211k2uqjuex1x7xq0; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY product
    ADD CONSTRAINT fkid4vcfgj211k2uqjuex1x7xq0 FOREIGN KEY (product_category_id) REFERENCES category(id);


--
-- TOC entry 2059 (class 2606 OID 16828)
-- Name: fks9p0s8b1nh7m2no87xxteu83x; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY "order"
    ADD CONSTRAINT fks9p0s8b1nh7m2no87xxteu83x FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 2064 (class 2606 OID 16853)
-- Name: fkt4v0rrweyk393bdgt107vdx0x; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY users_roles
    ADD CONSTRAINT fkt4v0rrweyk393bdgt107vdx0x FOREIGN KEY (role_id) REFERENCES role(id);


--
-- TOC entry 2060 (class 2606 OID 16833)
-- Name: fkt6wv8m7eshksp5kp8w4b2d1dm; Type: FK CONSTRAINT; Schema: test; Owner: postgres
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT fkt6wv8m7eshksp5kp8w4b2d1dm FOREIGN KEY (order_id) REFERENCES "order"(id);


-- Completed on 2016-04-22 16:13:25 MSK

--
-- PostgreSQL database dump complete
--


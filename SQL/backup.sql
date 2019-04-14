--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.11
-- Dumped by pg_dump version 11.2 (Debian 11.2-1)

-- Started on 2019-04-14 11:29:09 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2224 (class 1262 OID 16385)
-- Name: comms; Type: DATABASE; Schema: -; Owner: marion
--

CREATE DATABASE comms WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'fr_FR.UTF-8' LC_CTYPE = 'fr_FR.UTF-8';


ALTER DATABASE comms OWNER TO marion;

\connect comms

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 191 (class 1259 OID 16882)
-- Name: supply; Type: TABLE; Schema: public; Owner: marion
--

CREATE TABLE public.supply (
    id_supply integer NOT NULL,
    date date DEFAULT ('now'::text)::date NOT NULL,
    seller text,
    description text NOT NULL,
    price numeric NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    care boolean DEFAULT true NOT NULL
);


ALTER TABLE public.supply OWNER TO marion;

--
-- TOC entry 2225 (class 0 OID 0)
-- Dependencies: 191
-- Name: COLUMN supply.care; Type: COMMENT; Schema: public; Owner: marion
--

COMMENT ON COLUMN public.supply.care IS 'Consomable';


--
-- TOC entry 190 (class 1259 OID 16880)
-- Name: buy_id_buy_seq; Type: SEQUENCE; Schema: public; Owner: marion
--

CREATE SEQUENCE public.buy_id_buy_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.buy_id_buy_seq OWNER TO marion;

--
-- TOC entry 2226 (class 0 OID 0)
-- Dependencies: 190
-- Name: buy_id_buy_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: marion
--

ALTER SEQUENCE public.buy_id_buy_seq OWNED BY public.supply.id_supply;


--
-- TOC entry 186 (class 1259 OID 16850)
-- Name: constructor; Type: TABLE; Schema: public; Owner: marion
--

CREATE TABLE public.constructor (
    id_constructor integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.constructor OWNER TO marion;

--
-- TOC entry 185 (class 1259 OID 16848)
-- Name: constructor_id_constructor_seq; Type: SEQUENCE; Schema: public; Owner: marion
--

CREATE SEQUENCE public.constructor_id_constructor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.constructor_id_constructor_seq OWNER TO marion;

--
-- TOC entry 2227 (class 0 OID 0)
-- Dependencies: 185
-- Name: constructor_id_constructor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: marion
--

ALTER SEQUENCE public.constructor_id_constructor_seq OWNED BY public.constructor.id_constructor;


--
-- TOC entry 189 (class 1259 OID 16865)
-- Name: motorcycle; Type: TABLE; Schema: public; Owner: marion
--

CREATE TABLE public.motorcycle (
    id_motorcycle integer NOT NULL,
    id_constructor integer NOT NULL,
    name text,
    ref text NOT NULL,
    mileage integer DEFAULT 0 NOT NULL,
    registration text
);


ALTER TABLE public.motorcycle OWNER TO marion;

--
-- TOC entry 2228 (class 0 OID 0)
-- Dependencies: 189
-- Name: COLUMN motorcycle.name; Type: COMMENT; Schema: public; Owner: marion
--

COMMENT ON COLUMN public.motorcycle.name IS 'Commercial name. Ex: CB750 Sevenfifty';


--
-- TOC entry 2229 (class 0 OID 0)
-- Dependencies: 189
-- Name: COLUMN motorcycle.ref; Type: COMMENT; Schema: public; Owner: marion
--

COMMENT ON COLUMN public.motorcycle.ref IS 'Mine type. Ex: RC42';


--
-- TOC entry 188 (class 1259 OID 16863)
-- Name: motorcycle_id_constructor_seq; Type: SEQUENCE; Schema: public; Owner: marion
--

CREATE SEQUENCE public.motorcycle_id_constructor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.motorcycle_id_constructor_seq OWNER TO marion;

--
-- TOC entry 2230 (class 0 OID 0)
-- Dependencies: 188
-- Name: motorcycle_id_constructor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: marion
--

ALTER SEQUENCE public.motorcycle_id_constructor_seq OWNED BY public.motorcycle.id_constructor;


--
-- TOC entry 187 (class 1259 OID 16861)
-- Name: motorcycle_id_motorcycle_seq; Type: SEQUENCE; Schema: public; Owner: marion
--

CREATE SEQUENCE public.motorcycle_id_motorcycle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.motorcycle_id_motorcycle_seq OWNER TO marion;

--
-- TOC entry 2231 (class 0 OID 0)
-- Dependencies: 187
-- Name: motorcycle_id_motorcycle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: marion
--

ALTER SEQUENCE public.motorcycle_id_motorcycle_seq OWNED BY public.motorcycle.id_motorcycle;


--
-- TOC entry 197 (class 1259 OID 17001)
-- Name: oper_type; Type: TABLE; Schema: public; Owner: marion
--

CREATE TABLE public.oper_type (
    id_type integer,
    id_oper integer
);


ALTER TABLE public.oper_type OWNER TO marion;

--
-- TOC entry 193 (class 1259 OID 16895)
-- Name: operation; Type: TABLE; Schema: public; Owner: marion
--

CREATE TABLE public.operation (
    id_oper integer NOT NULL,
    id_motorcycle integer,
    date date DEFAULT ('now'::text)::date NOT NULL,
    comment text,
    mileage integer NOT NULL
);


ALTER TABLE public.operation OWNER TO marion;

--
-- TOC entry 196 (class 1259 OID 16992)
-- Name: type_operation; Type: TABLE; Schema: public; Owner: marion
--

CREATE TABLE public.type_operation (
    id_type integer NOT NULL,
    name text
);


ALTER TABLE public.type_operation OWNER TO marion;

--
-- TOC entry 199 (class 1259 OID 17026)
-- Name: nsr; Type: VIEW; Schema: public; Owner: marion
--

CREATE VIEW public.nsr AS
 SELECT operation.id_oper,
    operation.id_motorcycle,
    operation.date,
    type_operation.name AS type,
    operation.comment,
    operation.mileage
   FROM public.operation,
    public.type_operation,
    public.oper_type
  WHERE ((oper_type.id_type = type_operation.id_type) AND (oper_type.id_oper = operation.id_oper) AND (operation.id_motorcycle = 2))
  ORDER BY operation.mileage;


ALTER TABLE public.nsr OWNER TO marion;

--
-- TOC entry 194 (class 1259 OID 16970)
-- Name: oper_supply; Type: TABLE; Schema: public; Owner: marion
--

CREATE TABLE public.oper_supply (
    id_oper integer,
    id_supply integer,
    quantity integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.oper_supply OWNER TO marion;

--
-- TOC entry 192 (class 1259 OID 16893)
-- Name: operation_id_oper_seq; Type: SEQUENCE; Schema: public; Owner: marion
--

CREATE SEQUENCE public.operation_id_oper_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.operation_id_oper_seq OWNER TO marion;

--
-- TOC entry 2232 (class 0 OID 0)
-- Dependencies: 192
-- Name: operation_id_oper_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: marion
--

ALTER SEQUENCE public.operation_id_oper_seq OWNED BY public.operation.id_oper;


--
-- TOC entry 198 (class 1259 OID 17022)
-- Name: sevenfifty; Type: VIEW; Schema: public; Owner: marion
--

CREATE VIEW public.sevenfifty AS
 SELECT operation.id_oper,
    operation.id_motorcycle,
    operation.date,
    type_operation.name AS type,
    operation.comment,
    operation.mileage
   FROM public.operation,
    public.type_operation,
    public.oper_type
  WHERE ((oper_type.id_type = type_operation.id_type) AND (oper_type.id_oper = operation.id_oper) AND (operation.id_motorcycle = 1))
  ORDER BY operation.mileage;


ALTER TABLE public.sevenfifty OWNER TO marion;

--
-- TOC entry 195 (class 1259 OID 16990)
-- Name: type_operation_id_type_seq; Type: SEQUENCE; Schema: public; Owner: marion
--

CREATE SEQUENCE public.type_operation_id_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.type_operation_id_type_seq OWNER TO marion;

--
-- TOC entry 2233 (class 0 OID 0)
-- Dependencies: 195
-- Name: type_operation_id_type_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: marion
--

ALTER SEQUENCE public.type_operation_id_type_seq OWNED BY public.type_operation.id_type;


--
-- TOC entry 200 (class 1259 OID 17041)
-- Name: unused_supply; Type: VIEW; Schema: public; Owner: marion
--

CREATE VIEW public.unused_supply AS
 SELECT supply.id_supply,
    supply.date,
    supply.seller,
    supply.description,
    supply.price,
    supply.quantity
   FROM (public.supply
     LEFT JOIN public.oper_supply ON ((supply.id_supply = oper_supply.id_supply)))
  WHERE (supply.care AND (oper_supply.id_supply IS NULL));


ALTER TABLE public.unused_supply OWNER TO marion;

--
-- TOC entry 2056 (class 2604 OID 16853)
-- Name: constructor id_constructor; Type: DEFAULT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.constructor ALTER COLUMN id_constructor SET DEFAULT nextval('public.constructor_id_constructor_seq'::regclass);


--
-- TOC entry 2057 (class 2604 OID 16868)
-- Name: motorcycle id_motorcycle; Type: DEFAULT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.motorcycle ALTER COLUMN id_motorcycle SET DEFAULT nextval('public.motorcycle_id_motorcycle_seq'::regclass);


--
-- TOC entry 2058 (class 2604 OID 16869)
-- Name: motorcycle id_constructor; Type: DEFAULT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.motorcycle ALTER COLUMN id_constructor SET DEFAULT nextval('public.motorcycle_id_constructor_seq'::regclass);


--
-- TOC entry 2064 (class 2604 OID 16898)
-- Name: operation id_oper; Type: DEFAULT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.operation ALTER COLUMN id_oper SET DEFAULT nextval('public.operation_id_oper_seq'::regclass);


--
-- TOC entry 2060 (class 2604 OID 16885)
-- Name: supply id_supply; Type: DEFAULT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.supply ALTER COLUMN id_supply SET DEFAULT nextval('public.buy_id_buy_seq'::regclass);


--
-- TOC entry 2067 (class 2604 OID 16995)
-- Name: type_operation id_type; Type: DEFAULT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.type_operation ALTER COLUMN id_type SET DEFAULT nextval('public.type_operation_id_type_seq'::regclass);


--
-- TOC entry 2207 (class 0 OID 16850)
-- Dependencies: 186
-- Data for Name: constructor; Type: TABLE DATA; Schema: public; Owner: marion
--

INSERT INTO public.constructor (id_constructor, name) VALUES (1, 'Honda');
INSERT INTO public.constructor (id_constructor, name) VALUES (2, 'Yamaha');
INSERT INTO public.constructor (id_constructor, name) VALUES (3, 'Suzuki');
INSERT INTO public.constructor (id_constructor, name) VALUES (4, 'Kawasaki');
INSERT INTO public.constructor (id_constructor, name) VALUES (5, 'Derbi');
INSERT INTO public.constructor (id_constructor, name) VALUES (6, 'Triumph');
INSERT INTO public.constructor (id_constructor, name) VALUES (7, 'Ducati');


--
-- TOC entry 2210 (class 0 OID 16865)
-- Dependencies: 189
-- Data for Name: motorcycle; Type: TABLE DATA; Schema: public; Owner: marion
--

INSERT INTO public.motorcycle (id_motorcycle, id_constructor, name, ref, mileage, registration) VALUES (2, 1, 'NSR', 'JC22', 0, NULL);
INSERT INTO public.motorcycle (id_motorcycle, id_constructor, name, ref, mileage, registration) VALUES (1, 1, 'SevenFifty', 'RC42', 0, 'CA-103-MZ');


--
-- TOC entry 2215 (class 0 OID 16970)
-- Dependencies: 194
-- Data for Name: oper_supply; Type: TABLE DATA; Schema: public; Owner: marion
--

INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (158, 18, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (158, 20, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (165, 38, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (165, 42, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (172, 49, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (164, 43, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (169, 37, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (163, 44, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (152, 6, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (157, 16, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (171, 48, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (151, 4, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (151, 7, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (150, 3, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (170, 36, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (170, 24, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (156, 17, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (155, 15, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (155, 19, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (168, 46, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (168, 47, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (153, 10, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (162, 35, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (154, 9, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (154, 8, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (159, 21, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (161, 22, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (161, 23, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (166, 45, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (149, 2, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (160, 24, 1);
INSERT INTO public.oper_supply (id_oper, id_supply, quantity) VALUES (160, 25, 1);


--
-- TOC entry 2218 (class 0 OID 17001)
-- Dependencies: 197
-- Data for Name: oper_type; Type: TABLE DATA; Schema: public; Owner: marion
--

INSERT INTO public.oper_type (id_type, id_oper) VALUES (2, 149);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (17, 150);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (4, 151);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (8, 151);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (3, 152);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (13, 152);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (5, 153);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (4, 154);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (11, 154);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (6, 155);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (14, 156);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (14, 157);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (16, 158);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (9, 158);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (18, 159);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (4, 160);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (14, 161);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (3, 162);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (13, 162);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (19, 163);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (7, 164);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (8, 165);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (14, 166);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (1, 167);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (12, 168);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (2, 168);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (10, 169);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (4, 170);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (11, 170);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (12, 171);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (2, 171);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (3, 172);
INSERT INTO public.oper_type (id_type, id_oper) VALUES (13, 173);


--
-- TOC entry 2214 (class 0 OID 16895)
-- Dependencies: 193
-- Data for Name: operation; Type: TABLE DATA; Schema: public; Owner: marion
--

INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (149, 1, '2018-04-19', 'Pneu arrière BT023', 25000);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (150, 1, '2018-04-19', 'Plaque d’immatriculation', 25000);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (151, 1, '2018-04-22', 'Entretien fourche', 25000);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (152, 1, '2018-04-22', 'Plaquettes avant', 25000);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (153, 1, '2018-05-07', 'Réparation démarreur', 26500);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (154, 1, '2018-06-25', 'Vidange', 28900);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (155, 1, '2018-07-08', 'Kit chaine RK 15x42', 29500);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (156, 1, '2018-07-08', 'Extensions gardes-boue', 29500);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (157, 1, '2018-07-08', 'Saute-vent fumé', 29500);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (158, 1, '2018-07-15', 'Durits frein avia', 29972);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (159, 1, '2018-08-13', 'Changement moteur', 29972);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (160, 1, '2018-08-13', 'Vidange', 29972);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (161, 1, '2018-08-15', 'Feux additionnels', 29972);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (162, 1, '2018-09-02', 'Changement plaquettes avant G&D', 31507);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (163, 1, '2018-09-28', 'Changement fourche', 32018);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (164, 1, '2018-09-27', 'Roulements direction', 32018);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (165, 1, '2018-09-10', 'Reconditionnement amortisseurs AR', 32176);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (166, 1, '2018-10-01', 'Passage de roue', 32176);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (167, 1, '2018-10-07', 'Vérifications roulements AR', 33005);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (168, 1, '2018-12-16', 'Changement roue arrière', 34801);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (169, 1, '2019-01-01', 'Changement filtre à air', 35292);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (170, 1, '2019-01-01', 'Vidange', 35292);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (171, 1, '2019-03-08', 'Changement roue avant', 38484);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (172, 1, '2019-03-08', 'Changement plaquettes avant G&D', 38484);
INSERT INTO public.operation (id_oper, id_motorcycle, date, comment, mileage) VALUES (173, 1, '2019-03-15', 'Nettoyage graissage étriers avant', 38530);


--
-- TOC entry 2212 (class 0 OID 16882)
-- Dependencies: 191
-- Data for Name: supply; Type: TABLE DATA; Schema: public; Owner: marion
--

INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (2, '2018-04-19', 'Mécamick', 'Pneu arrière BT023', 150.00, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (6, '2018-04-22', 'Amazon', 'Paire plaquettes avant', 32.00, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (7, '2018-04-22', 'Amazon', 'Huile fourche', 22.00, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (20, '2018-07-10', 'Mécamick', 'Liquide freins DOT5.1', 12.00, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (39, '2018-09-17', 'Wemoto', 'Kit révision fourche', 57.00, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (47, '2018-12-15', 'Mécamick', 'Achat + montage pneu AR', 150.00, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (48, '2019-02-15', '123pneus', 'Pneu avant T31', 99.00, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (4, '2018-04-22', 'Amazon', 'Joints spi et caches poussières fourche', 12.90, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (5, '2018-04-22', 'Amazon', 'Graisse cuivre 500g', 14.90, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (8, '2018-04-23', 'Leclerc', 'Huile moteur 10W40 semi-synth Tech9', 6.79, 3, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (9, '2018-05-03', 'Wemoto', 'Filtre à huile HiFlo', 6.18, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (10, '2018-05-03', 'Wemoto', 'Kit réparation démarreur', 31.70, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (42, '2018-04-22', '123roulement', 'Joints amortisseurs', 32.34, 2, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (11, '2018-06-07', 'Wemoto', 'Kit roulements arrière + caches poussière', 34.61, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (12, '2018-06-07', 'Wemoto', 'Kit roulements avant avec caches poussières', 16.50, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (13, '2018-06-07', 'Wemoto', 'Bougies NGK', 3.87, 4, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (14, '2018-06-09', 'Wemoto', 'Caches-poussières roulements arrière', 18.37, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (15, '2018-06-23', 'moto24h', 'Kit chaîne origine 114 maillons', 136.94, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (19, '2018-06-28', 'Amazon', 'Couronne 42 dents', 37.95, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (24, '2018-08-13', 'Leclerc', 'Huile moteur 10W40 semi-synth Tech9', 6.79, 3, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (25, '2018-08-13', 'Amazon', 'Joint silicone Bardahl', 17.44, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (29, '2018-08-16', 'AliExpress', 'LED BA9S yellow', 0.24, 10, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (30, '2018-08-16', 'AliExpress', 'LED T5 green', 0.13, 10, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (31, '2018-08-16', 'AliExpress', 'LED T10 white', 0.40, 4, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (32, '2018-08-16', 'AliExpress', 'LED T5 white', 0.06, 20, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (33, '2018-08-16', 'AliExpress', 'Cosses plates 6.3 mm M+F', 0.01, 200, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (35, '2018-09-01', 'AliExpress', 'Plaquettes avant SOMMET', 8.99, 2, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (36, '2018-09-17', 'Wemoto', 'Filtre à huile HiFlo', 6.86, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (37, '2018-09-17', 'Wemoto', 'Filtre à air HiFlo', 16.07, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (38, '2018-09-17', 'Wemoto', 'Huile fourche 5W', 11.51, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (40, '2018-09-17', 'Wemoto', 'Frais de port commande 17.09.2018', 9.09, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (41, '2018-09-18', 'Amazon', 'Huile fourche 15W', 22.95, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (43, '2018-09-20', 'Ebay', 'Jeu de roulements direction', 21.29, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (49, '2019-02-16', 'AliExpress', 'Plaquettes avant SOMMET', 8.36, 2, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (50, '2019-03-15', 'Wemoto', 'Filtre à huile HiFlo', 6.86, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (51, '2019-03-15', 'Wemoto', 'Filtre à air HiFlo', 16.07, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (54, '2019-03-15', 'Wemoto', 'Bouchon goupille. Frein avant', 2.22, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (55, '2019-03-15', 'Wemoto', 'Kit roulements avant avec caches poussières', 16.50, 1, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (56, '2019-03-16', 'AliExpress', 'Contacteur frein avant', 0.89, 3, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (1, '2018-04-14', 'Anthony HAVARD', 'Achat Seven Fifty 124000 km', 1300.00, 1, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (3, '2018-04-19', 'Mécamick', 'Plaque d’immatriculation', 20.00, 1, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (17, '2018-06-24', 'AliExpress', 'Extension garde-boue', 8.74, 2, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (16, '2018-06-24', 'AliExpress', 'Saute-vent fumé', 16.60, 1, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (18, '2018-06-24', 'AliExpress', 'Durits avia', 6.84, 3, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (21, '2018-07-14', 'oncfredo', 'Moteur SevenFifty 50000 km', 300.00, 1, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (23, '2018-07-22', 'AliExpress', 'Prise relais 5 broches', 0.74, 1, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (22, '2018-07-22', 'AliExpress', 'Relais 5 broches', 0.98, 2, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (26, '2018-08-16', 'AliExpress', 'Centrale clignotants', 2.99, 1, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (27, '2018-08-16', 'AliExpress', 'LED BAY15D white', 1.77, 2, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (28, '2018-08-16', 'AliExpress', 'LED H4 6000K', 8.49, 2, true);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (34, '2018-08-16', 'AliExpress', 'Chargeur USB', 3.01, 1, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (44, '2018-09-21', 'oncfredo', 'Fourche 50000 km', 140.00, 1, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (45, '2018-04-03', 'Leboncoin', 'Passage de roue TDM', 25.00, 1, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (46, '2018-12-09', 'Leboncoin', 'Roues avant et arrière', 25.00, 2, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (52, '2019-03-15', 'Wemoto', 'Vis embout de guidon', 1.25, 2, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (53, '2019-03-15', 'Wemoto', 'Embout de guidon', 22.15, 1, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (57, '2019-04-07', 'AliExpress', 'MC frein Adelin D14', 35.24, 1, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (58, '2019-04-07', 'AliExpress', 'Contacteur hydraulique 10x1.25mm', 2.35, 1, false);
INSERT INTO public.supply (id_supply, date, seller, description, price, quantity, care) VALUES (59, '2019-04-07', 'AliExpress', 'Levier embrayage stunt 22mm', 24.07, 1, false);


--
-- TOC entry 2217 (class 0 OID 16992)
-- Dependencies: 196
-- Data for Name: type_operation; Type: TABLE DATA; Schema: public; Owner: marion
--

INSERT INTO public.type_operation (id_type, name) VALUES (1, 'Divers');
INSERT INTO public.type_operation (id_type, name) VALUES (2, 'Changement pneu');
INSERT INTO public.type_operation (id_type, name) VALUES (3, 'Changement plaquettes');
INSERT INTO public.type_operation (id_type, name) VALUES (4, 'Vidange');
INSERT INTO public.type_operation (id_type, name) VALUES (5, 'Réfection');
INSERT INTO public.type_operation (id_type, name) VALUES (6, 'Kit chaine');
INSERT INTO public.type_operation (id_type, name) VALUES (7, 'Roulements');
INSERT INTO public.type_operation (id_type, name) VALUES (8, 'Joints spi');
INSERT INTO public.type_operation (id_type, name) VALUES (9, 'Purge');
INSERT INTO public.type_operation (id_type, name) VALUES (10, 'Filtre à air');
INSERT INTO public.type_operation (id_type, name) VALUES (11, 'Filtre à huile');
INSERT INTO public.type_operation (id_type, name) VALUES (12, 'Changement roue');
INSERT INTO public.type_operation (id_type, name) VALUES (13, 'Entretien étrier');
INSERT INTO public.type_operation (id_type, name) VALUES (14, 'Montage accessoire');
INSERT INTO public.type_operation (id_type, name) VALUES (15, 'Démontage accessoire');
INSERT INTO public.type_operation (id_type, name) VALUES (16, 'Changement accessoire');
INSERT INTO public.type_operation (id_type, name) VALUES (18, 'Changement moteur');
INSERT INTO public.type_operation (id_type, name) VALUES (19, 'Changement fourche');
INSERT INTO public.type_operation (id_type, name) VALUES (17, 'Plaque immatriculation');


--
-- TOC entry 2234 (class 0 OID 0)
-- Dependencies: 190
-- Name: buy_id_buy_seq; Type: SEQUENCE SET; Schema: public; Owner: marion
--

SELECT pg_catalog.setval('public.buy_id_buy_seq', 59, true);


--
-- TOC entry 2235 (class 0 OID 0)
-- Dependencies: 185
-- Name: constructor_id_constructor_seq; Type: SEQUENCE SET; Schema: public; Owner: marion
--

SELECT pg_catalog.setval('public.constructor_id_constructor_seq', 7, true);


--
-- TOC entry 2236 (class 0 OID 0)
-- Dependencies: 188
-- Name: motorcycle_id_constructor_seq; Type: SEQUENCE SET; Schema: public; Owner: marion
--

SELECT pg_catalog.setval('public.motorcycle_id_constructor_seq', 1, false);


--
-- TOC entry 2237 (class 0 OID 0)
-- Dependencies: 187
-- Name: motorcycle_id_motorcycle_seq; Type: SEQUENCE SET; Schema: public; Owner: marion
--

SELECT pg_catalog.setval('public.motorcycle_id_motorcycle_seq', 2, true);


--
-- TOC entry 2238 (class 0 OID 0)
-- Dependencies: 192
-- Name: operation_id_oper_seq; Type: SEQUENCE SET; Schema: public; Owner: marion
--

SELECT pg_catalog.setval('public.operation_id_oper_seq', 175, true);


--
-- TOC entry 2239 (class 0 OID 0)
-- Dependencies: 195
-- Name: type_operation_id_type_seq; Type: SEQUENCE SET; Schema: public; Owner: marion
--

SELECT pg_catalog.setval('public.type_operation_id_type_seq', 19, true);


--
-- TOC entry 2075 (class 2606 OID 16892)
-- Name: supply buy_pkey; Type: CONSTRAINT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.supply
    ADD CONSTRAINT buy_pkey PRIMARY KEY (id_supply);


--
-- TOC entry 2069 (class 2606 OID 16860)
-- Name: constructor constructor_name_key; Type: CONSTRAINT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.constructor
    ADD CONSTRAINT constructor_name_key UNIQUE (name);


--
-- TOC entry 2071 (class 2606 OID 16858)
-- Name: constructor constructor_pkey; Type: CONSTRAINT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.constructor
    ADD CONSTRAINT constructor_pkey PRIMARY KEY (id_constructor);


--
-- TOC entry 2073 (class 2606 OID 16874)
-- Name: motorcycle motorcycle_pkey; Type: CONSTRAINT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.motorcycle
    ADD CONSTRAINT motorcycle_pkey PRIMARY KEY (id_motorcycle);


--
-- TOC entry 2077 (class 2606 OID 16904)
-- Name: operation operation_pkey; Type: CONSTRAINT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.operation
    ADD CONSTRAINT operation_pkey PRIMARY KEY (id_oper);


--
-- TOC entry 2079 (class 2606 OID 17000)
-- Name: type_operation type_operation_pkey; Type: CONSTRAINT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.type_operation
    ADD CONSTRAINT type_operation_pkey PRIMARY KEY (id_type);


--
-- TOC entry 2080 (class 2606 OID 16875)
-- Name: motorcycle motorcycle_id_constructor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.motorcycle
    ADD CONSTRAINT motorcycle_id_constructor_fkey FOREIGN KEY (id_constructor) REFERENCES public.constructor(id_constructor);


--
-- TOC entry 2082 (class 2606 OID 16973)
-- Name: oper_supply oper_supply_id_oper_fkey; Type: FK CONSTRAINT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.oper_supply
    ADD CONSTRAINT oper_supply_id_oper_fkey FOREIGN KEY (id_oper) REFERENCES public.operation(id_oper);


--
-- TOC entry 2083 (class 2606 OID 16978)
-- Name: oper_supply oper_supply_id_supply_fkey; Type: FK CONSTRAINT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.oper_supply
    ADD CONSTRAINT oper_supply_id_supply_fkey FOREIGN KEY (id_supply) REFERENCES public.supply(id_supply);


--
-- TOC entry 2085 (class 2606 OID 17009)
-- Name: oper_type oper_type_id_oper_fkey; Type: FK CONSTRAINT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.oper_type
    ADD CONSTRAINT oper_type_id_oper_fkey FOREIGN KEY (id_oper) REFERENCES public.operation(id_oper);


--
-- TOC entry 2084 (class 2606 OID 17004)
-- Name: oper_type oper_type_id_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.oper_type
    ADD CONSTRAINT oper_type_id_type_fkey FOREIGN KEY (id_type) REFERENCES public.type_operation(id_type);


--
-- TOC entry 2081 (class 2606 OID 16905)
-- Name: operation operation_id_motorcycle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: marion
--

ALTER TABLE ONLY public.operation
    ADD CONSTRAINT operation_id_motorcycle_fkey FOREIGN KEY (id_motorcycle) REFERENCES public.motorcycle(id_motorcycle);


-- Completed on 2019-04-14 11:29:13 CEST

--
-- PostgreSQL database dump complete
--


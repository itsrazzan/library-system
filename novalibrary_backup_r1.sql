--
-- PostgreSQL database dump
--

\restrict Pa8Je4MvaFx56sLD2E3v4vwpN8LykmimdEfbnOvywHjRX0tA09hlTeTekLwrSLT

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

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
-- Name: get_user_for_auth(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_for_auth(p_username character varying) RETURNS TABLE(id integer, username character varying, hashed_password character varying, status character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
     RETURN QUERY
     SELECT u.id, u.username, u.password, u.status
     FROM username u
     WHERE u.username = p_username;
END;
$$;


ALTER FUNCTION public.get_user_for_auth(p_username character varying) OWNER TO postgres;

--
-- Name: login_user_with_role(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.login_user_with_role(p_username character varying, p_password character varying) RETURNS TABLE(user_id integer, username character varying, role character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.username,
        u.status
    FROM username u
    WHERE u.username = p_username
      AND u.password = p_password;
END;
$$;


ALTER FUNCTION public.login_user_with_role(p_username character varying, p_password character varying) OWNER TO postgres;

--
-- Name: update_book_status(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_book_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
if tg_op = 'insert' then
update book set book_status = false
where book_id = new.nook_id;
end if;

if tg_op = 'update' and new.return_date is not null then
update book set book_status = true
where book_id = new.book_id;
end if;
return new;
end;
$$;


ALTER FUNCTION public.update_book_status() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: book; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book (
    book_id integer NOT NULL,
    category_id integer NOT NULL,
    book_title character varying(100) NOT NULL,
    author character varying(100),
    publisher character varying(255),
    published_year date,
    image_path character varying(255),
    book_status boolean DEFAULT true
);


ALTER TABLE public.book OWNER TO postgres;

--
-- Name: bookcategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookcategory (
    category_id integer NOT NULL,
    category_name character varying(100) NOT NULL,
    explanation text
);


ALTER TABLE public.bookcategory OWNER TO postgres;

--
-- Name: booklending; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booklending (
    loan_id integer NOT NULL,
    book_id integer NOT NULL,
    loan_date date DEFAULT CURRENT_DATE NOT NULL,
    due_date date NOT NULL,
    return_date date,
    CONSTRAINT check_loan_date CHECK ((loan_date <= due_date))
);


ALTER TABLE public.booklending OWNER TO postgres;

--
-- Name: bookreturn; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookreturn (
    return_id integer NOT NULL,
    loan_id integer NOT NULL,
    return_date date NOT NULL,
    penalty_id integer
);


ALTER TABLE public.bookreturn OWNER TO postgres;

--
-- Name: penalty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.penalty (
    penalty_id integer NOT NULL,
    id integer NOT NULL,
    large_fines integer NOT NULL
);


ALTER TABLE public.penalty OWNER TO postgres;

--
-- Name: penalty_penalty_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.penalty_penalty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.penalty_penalty_id_seq OWNER TO postgres;

--
-- Name: penalty_penalty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.penalty_penalty_id_seq OWNED BY public.penalty.penalty_id;


--
-- Name: username; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.username (
    id integer NOT NULL,
    username character varying(20) NOT NULL,
    password character varying(255) NOT NULL,
    status character varying(100),
    name character varying(100),
    email character varying(100),
    phone_number character varying(20)
);


ALTER TABLE public.username OWNER TO postgres;

--
-- Name: waiting_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.waiting_list (
    waiting_id integer NOT NULL,
    book_id integer NOT NULL,
    id integer NOT NULL,
    request_date date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.waiting_list OWNER TO postgres;

--
-- Name: waiting_list_waiting_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.waiting_list_waiting_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.waiting_list_waiting_id_seq OWNER TO postgres;

--
-- Name: waiting_list_waiting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.waiting_list_waiting_id_seq OWNED BY public.waiting_list.waiting_id;


--
-- Name: penalty penalty_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penalty ALTER COLUMN penalty_id SET DEFAULT nextval('public.penalty_penalty_id_seq'::regclass);


--
-- Name: waiting_list waiting_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waiting_list ALTER COLUMN waiting_id SET DEFAULT nextval('public.waiting_list_waiting_id_seq'::regclass);


--
-- Data for Name: book; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book (book_id, category_id, book_title, author, publisher, published_year, image_path, book_status) FROM stdin;
1	1	Laskar Pelangi	Andrea Hirata	Bentang Pustaka	2005-01-01	/images/books/laskar_pelangi.jpeg	t
2	1	Sang Pemimpi	Andrea Hirata	Bentang Pustaka	2006-01-01	/images/books/sang_pemimpi.jpeg	t
3	1	Edensor	Andrea Hirata	Bentang Pustaka	2007-01-01	/images/books/edensor.jpeg	t
4	1	Maryamah Karpov	Andrea Hirata	Bentang Pustaka	2008-01-01	/images/books/maryamah_karpov.jpeg	t
5	1	Perahu Kertas	Dee Lestari	Bentang Pustaka	2009-01-01	/images/books/perahu_kertas.jpeg	t
6	1	Supernova	Dee Lestari	Truedee Pustaka	2001-01-01	/images/books/supernova.jpeg	t
7	1	Rectoverso	Dee Lestari	Bentang Pustaka	2008-01-01	/images/books/rectoverso.jpeg	t
8	1	Ayat-Ayat Cinta	Habiburrahman El Shirazy	Republika	2004-01-01	/images/books/ayat_ayat_cinta.jpeg	t
9	1	Ketika Cinta Bertasbih	Habiburrahman El Shirazy	Republika	2007-01-01	/images/books/kcb.jpeg	t
10	1	Dalam Mihrab Cinta	Habiburrahman El Shirazy	Republika	2009-01-01	/images/books/dalam_mihrab_cinta.jpeg	t
11	1	Negeri 5 Menara	Ahmad Fuadi	Gramedia	2009-01-01	/images/books/negeri_5_menara.jpeg	t
12	1	Ranah 3 Warna	Ahmad Fuadi	Gramedia	2011-01-01	/images/books/ranah_3_warna.jpeg	t
13	1	Rantau 1 Muara	Ahmad Fuadi	Gramedia	2013-01-01	/images/books/rantau_1_muara.jpeg	t
14	1	Bumi	Tere Liye	Gramedia	2014-01-01	/images/books/bumi.jpeg	t
15	1	Bulan	Tere Liye	Gramedia	2015-01-01	/images/books/bulan.jpeg	t
16	1	Matahari	Tere Liye	Gramedia	2016-01-01	/images/books/matahari.jpeg	t
17	1	Hujan	Tere Liye	Gramedia	2016-01-01	/images/books/hujan.jpeg	t
18	1	Pulang	Tere Liye	Republika	2015-01-01	/images/books/pulang.jpeg	t
19	1	Rindu	Tere Liye	Republika	2014-01-01	/images/books/rindu.jpeg	t
20	1	Pergi	Tere Liye	Gramedia	2018-01-01	/images/books/pergi.jpeg	t
21	3	Filosofi Teras	Henry Manampiring	Kompas	2018-01-01	/images/books/filosofi_teras.jpeg	t
22	3	Berani Tidak Disukai	Ichiro Kishimi	Gramedia	2019-01-01	/images/books/berani_tidak_disukai.jpeg	t
23	3	Atomic Habits	James Clear	Gramedia	2019-01-01	/images/books/atomic_habits.jpeg	t
24	3	The Psychology of Money	Morgan Housel	Gramedia	2021-01-01	/images/books/psychology_of_money.jpeg	t
25	3	Sebuah Seni Bersikap Bodo Amat	Mark Manson	Gramedia	2018-01-01	/images/books/bodo_amat.jpeg	t
26	2	Algoritma dan Pemrograman	Sukamto	Informatika	2017-01-01	/images/books/algoritma.jpeg	t
27	2	Pemrograman Java	Abdul Kadir	Andi	2018-01-01	/images/books/java.jpeg	t
28	2	Basis Data	Rosa A.S.	Informatika	2019-01-01	/images/books/basis_data.jpeg	t
29	2	Rekayasa Perangkat Lunak	Pressman	Andi	2015-01-01	/images/books/rpl.jpeg	t
30	2	Sistem Informasi	Gordon B. Davis	Salemba Empat	2014-01-01	/images/books/sistem_informasi.jpeg	t
31	4	Bumi Manusia	Pramoedya Ananta Toer	Hasta Mitra	1980-01-01	/images/books/bumi_manusia.jpeg	t
32	4	Anak Semua Bangsa	Pramoedya Ananta Toer	Hasta Mitra	1981-01-01	/images/books/anak_semua_bangsa.jpeg	t
33	4	Jejak Langkah	Pramoedya Ananta Toer	Hasta Mitra	1985-01-01	/images/books/jejak_langkah.jpeg	t
34	4	Rumah Kaca	Pramoedya Ananta Toer	Hasta Mitra	1988-01-01	/images/books/rumah_kaca.jpeg	t
35	4	Habibie & Ainun	B.J. Habibie	THC Mandiri	2010-01-01	/images/books/habibie_ainun.jpeg	t
36	5	Cerita Rakyat Nusantara	James Danandjaja	Balai Pustaka	2007-01-01	/images/books/cerita_nusantara.jpeg	t
37	5	Dongeng Anak Indonesia	Tim Bobo	Gramedia	2012-01-01	/images/books/dongeng_anak.jpeg	t
38	5	Si Kancil	Anonim	Balai Pustaka	1995-01-01	/images/books/si_kancil.jpeg	t
39	5	Malin Kundang	Anonim	Balai Pustaka	1995-01-01	/images/books/malin_kundang.jpg	t
40	5	Timun Mas	Anonim	Balai Pustaka	1996-01-01	/images/books/timun_mas.jpg	t
41	1	Dilan 1990	Pidi Baiq	Pastel Books	2014-01-01	/images/books/dilan_1990.jpg	t
42	1	Dilan 1991	Pidi Baiq	Pastel Books	2015-01-01	/images/books/dilan_1991.jpg	t
43	1	Milea	Pidi Baiq	Pastel Books	2016-01-01	/images/books/milea.jpg	t
44	1	Garis Waktu	Fiersa Besari	Media Kita	2016-01-01	/images/books/garis_waktu.jpg	t
45	1	Catatan Juang	Fiersa Besari	Media Kita	2015-01-01	/images/books/catatan_juang.jpg	t
46	3	You Do You	Fellexandro Ruby	Gramedia	2020-01-01	/images/books/you_do_you.jpg	t
47	3	Ikigai	Hector Garcia	Gramedia	2018-01-01	/images/books/ikigai.jpg	t
48	2	Cloud Computing	Onno W. Purbo	Andi	2017-01-01	/images/books/cloud.jpeg	t
49	2	Manajemen Proyek TI	Indrajit	Gramedia	2016-01-01	/images/books/manajemen_proyek.jpeg	t
50	2	Data Mining	Kusrini	Andi	2015-01-01	/images/books/data_mining.jpeg	t
51	1	Rasa	Tere Liye	Gramedia	2022-04-22	/images/books/pergi.jpg	t
52	1	Komet	Tere Liye	Gramedia	2018-01-01	/images/books/komet.jpg	t
53	1	Komet Minor	Tere Liye	Gramedia	2019-01-01	/images/books/komet_minor.jpg	t
54	1	Selena	Tere Liye	Gramedia	2020-01-01	/images/books/selena.jpg	t
55	1	Nebula	Tere Liye	Gramedia	2020-01-01	/images/books/nebula.jpg	t
56	1	Rantau	Tere Liye	Republika	2017-01-01	/images/books/rantau.jpg	t
57	1	Tentang Kamu	Tere Liye	Republika	2016-01-01	/images/books/tentang_kamu.jpg	t
58	1	Sunset Bersama Rosie	Tere Liye	Republika	2011-01-01	/images/books/sunset_rosie.jpg	t
59	1	Bidadari-Bidadari Surga	Tere Liye	Republika	2009-01-01	/images/books/bidadari_surga.jpg	t
60	1	Hafalan Shalat Delisa	Tere Liye	Republika	2005-01-01	/images/books/delisa.jpg	t
61	1	Pulang Pergi	Tere Liye	Gramedia	2021-01-01	/images/books/pulang_pergi.jpg	t
62	1	Janji	Tere Liye	Gramedia	2021-01-01	/images/books/janji.jpg	t
63	1	Garis Waktu	Fiersa Besari	Media Kita	2016-01-01	/images/books/garis_waktu.jpg	t
64	1	11:11	Fiersa Besari	Media Kita	2018-01-01	/images/books/1111.jpg	t
65	1	Konspirasi Alam Semesta	Fiersa Besari	Media Kita	2017-01-01	/images/books/konspirasi_alam_semesta.jpg	t
66	1	Arah Langkah	Fiersa Besari	Media Kita	2019-01-01	/images/books/arah_langkah.jpg	t
67	1	Tapak Jejak	Fiersa Besari	Media Kita	2015-01-01	/images/books/tapak_jejak.jpg	t
68	1	Catatan Juang	Fiersa Besari	Media Kita	2015-01-01	/images/books/catatan_juang.jpg	t
69	1	Pulang	Leila S. Chudori	Kepustakaan Populer Gramedia	2012-01-01	/images/books/pulang_leila.jpg	t
70	1	Laut Bercerita	Leila S. Chudori	Kepustakaan Populer Gramedia	2017-01-01	/images/books/laut_bercerita.jpg	t
71	1	Namaku Alam	Leila S. Chudori	Kepustakaan Populer Gramedia	2023-01-01	/images/books/namaku_alam.jpg	t
72	4	Amba	Laksmi Pamuntjak	Gramedia	2012-01-01	/images/books/amba.jpg	t
73	4	Aruna dan Lidahnya	Laksmi Pamuntjak	Gramedia	2014-01-01	/images/books/aruna_lidahnya.jpg	t
74	4	Cantik Itu Luka	Eka Kurniawan	Gramedia	2002-01-01	/images/books/cantik_itu_luka.jpg	t
75	4	Lelaki Harimau	Eka Kurniawan	Gramedia	2004-01-01	/images/books/lelaki_harimau.jpg	t
76	4	Seperti Dendam, Rindu Harus Dibayar Tuntas	Eka Kurniawan	Gramedia	2014-01-01	/images/books/dendam.jpg	t
77	4	O	Eka Kurniawan	Gramedia	2016-01-01	/images/books/o.jpg	t
78	4	Orang-Orang Proyek	Ahmad Tohari	Gramedia	2007-01-01	/images/books/orang_proyek.jpg	t
79	4	Ronggeng Dukuh Paruk	Ahmad Tohari	Gramedia	1982-01-01	/images/books/ronggeng.jpg	t
80	4	Lintang Kemukus Dini Hari	Ahmad Tohari	Gramedia	1985-01-01	/images/books/lintang_kemukus.jpg	t
81	5	Kumpulan Cerita Rakyat Jawa	Tim Balai Pustaka	Balai Pustaka	2005-01-01	/images/books/cerita_jawa.jpg	t
82	5	Kumpulan Cerita Rakyat Sumatra	Tim Balai Pustaka	Balai Pustaka	2006-01-01	/images/books/cerita_sumatra.jpg	t
83	5	Kumpulan Cerita Rakyat Kalimantan	Tim Balai Pustaka	Balai Pustaka	2007-01-01	/images/books/cerita_kalimantan.jpg	t
84	5	Kumpulan Cerita Rakyat Sulawesi	Tim Balai Pustaka	Balai Pustaka	2008-01-01	/images/books/cerita_sulawesi.jpg	t
85	5	Kumpulan Cerita Rakyat Papua	Tim Balai Pustaka	Balai Pustaka	2009-01-01	/images/books/cerita_papua.jpg	t
86	2	Pengantar Teknologi Informasi	Jogiyanto	Andi	2016-01-01	/images/books/pti.jpg	t
87	2	Analisis dan Desain Sistem Informasi	Jogiyanto	Andi	2017-01-01	/images/books/adsi.jpg	t
88	2	Data Warehouse	Inmon	Andi	2015-01-01	/images/books/data_warehouse.jpg	t
89	2	Big Data Analytics	Eko Prasetyo	Informatika	2018-01-01	/images/books/big_data.jpg	t
90	2	Artificial Intelligence	Suyanto	Informatika	2020-01-01	/images/books/ai.jpg	t
91	3	Goodbye Things	Fumio Sasaki	Gramedia	2019-01-01	/images/books/goodbye_things.jpg	t
92	3	Mindset	Carol S. Dweck	Gramedia	2017-01-01	/images/books/mindset.jpg	t
93	3	Deep Work	Cal Newport	Gramedia	2018-01-01	/images/books/deep_work.jpg	t
94	3	Start With Why	Simon Sinek	Gramedia	2016-01-01	/images/books/start_with_why.jpg	t
95	3	Grit	Angela Duckworth	Gramedia	2017-01-01	/images/books/grit.jpg	t
96	5	Ensiklopedia Anak Pintar	Tim Edukasi	Gramedia	2015-01-01	/images/books/ensiklopedia_anak.jpg	t
97	5	Sains untuk Anak	Tim Edukasi	Gramedia	2016-01-01	/images/books/sains_anak.jpg	t
98	5	Matematika Dasar Anak	Tim Edukasi	Gramedia	2017-01-01	/images/books/matematika_anak.jpg	t
99	5	Bahasa Indonesia Anak	Tim Edukasi	Gramedia	2018-01-01	/images/books/bahasa_anak.jpg	t
100	5	Cerita Bergambar Nusantara	Tim Edukasi	Gramedia	2019-01-01	/images/books/cerita_bergambar.jpg	t
\.


--
-- Data for Name: bookcategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookcategory (category_id, category_name, explanation) FROM stdin;
1	Novel Fiksi Populer Indonesia	Buku fiksi berbentuk novel dengan tema kehidupan, percintaan, religiusitas, dan petualangan untuk pembaca umum
2	Buku Teknologi dan Sistem Informasi	Buku nonfiksi yang membahas teori dan penerapan teknologi informasi, pemrograman, dan sistem informasi
3	Pengembangan Diri dan Psikologi Populer	Buku nonfiksi tentang pengembangan kepribadian, motivasi, dan pola pikir praktis
4	Sastra Indonesia	Karya sastra fiksi bernilai budaya, sosial, dan historis yang ditulis oleh sastrawan Indonesia
5	Buku Anak dan Cerita Rakyat	Buku bacaan anak yang berisi dongeng, cerita rakyat, dan materi edukasi dasar
\.


--
-- Data for Name: booklending; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.booklending (loan_id, book_id, loan_date, due_date, return_date) FROM stdin;
\.


--
-- Data for Name: bookreturn; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookreturn (return_id, loan_id, return_date, penalty_id) FROM stdin;
\.


--
-- Data for Name: penalty; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.penalty (penalty_id, id, large_fines) FROM stdin;
\.


--
-- Data for Name: username; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.username (id, username, password, status, name, email, phone_number) FROM stdin;
1	admin	$2y$10$j26jMpvRnl5UjWbgfpoZnenGaVGBBWWgxgWTWuYRN2O0nBaj18CEe	admin	Administrator	admin@library.com	0811111111
2	member1	$2y$10$jZaN4ZwdhPLjt9Y4qnryHOAdqMhIlHdEiuq4vr/oLQGzeitcrB2BK	member	Andi Wijaya	andi@mail.com	0812222222
3	member2	$2y$10$jZaN4ZwdhPLjt9Y4qnryHOAdqMhIlHdEiuq4vr/oLQGzeitcrB2BK	member	Budi Santoso	budi@mail.com	0813333333
4	member3	$2y$10$jZaN4ZwdhPLjt9Y4qnryHOAdqMhIlHdEiuq4vr/oLQGzeitcrB2BK	member	Citra Lestari	citra@mail.com	0814444444
5	member4	$2y$10$jZaN4ZwdhPLjt9Y4qnryHOAdqMhIlHdEiuq4vr/oLQGzeitcrB2BK	member	Dewi Anggraini	dewi@mail.com	0815555555
6	member5	$2y$10$jZaN4ZwdhPLjt9Y4qnryHOAdqMhIlHdEiuq4vr/oLQGzeitcrB2BK	member	Eko Prasetyo	eko@mail.com	0816666666
7	member6	$2y$10$jZaN4ZwdhPLjt9Y4qnryHOAdqMhIlHdEiuq4vr/oLQGzeitcrB2BK	member	Fajar Hidayat	fajar@mail.com	0817777777
8	member7	$2y$10$jZaN4ZwdhPLjt9Y4qnryHOAdqMhIlHdEiuq4vr/oLQGzeitcrB2BK	member	Gita Permata	gita@mail.com	0818888888
9	member8	$2y$10$jZaN4ZwdhPLjt9Y4qnryHOAdqMhIlHdEiuq4vr/oLQGzeitcrB2BK	member	Hadi Kurniawan	hadi@mail.com	0819999999
10	member9	$2y$10$jZaN4ZwdhPLjt9Y4qnryHOAdqMhIlHdEiuq4vr/oLQGzeitcrB2BK	member	Indah Sari	indah@mail.com	0820000000
\.


--
-- Data for Name: waiting_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.waiting_list (waiting_id, book_id, id, request_date) FROM stdin;
\.


--
-- Name: penalty_penalty_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.penalty_penalty_id_seq', 1, false);


--
-- Name: waiting_list_waiting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.waiting_list_waiting_id_seq', 1, false);


--
-- Name: book book_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (book_id);


--
-- Name: bookcategory bookcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookcategory
    ADD CONSTRAINT bookcategory_pkey PRIMARY KEY (category_id);


--
-- Name: booklending booklending_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booklending
    ADD CONSTRAINT booklending_pkey PRIMARY KEY (loan_id);


--
-- Name: bookreturn bookreturn_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookreturn
    ADD CONSTRAINT bookreturn_pkey PRIMARY KEY (return_id);


--
-- Name: penalty penalty_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penalty
    ADD CONSTRAINT penalty_pkey PRIMARY KEY (penalty_id);


--
-- Name: username username_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.username
    ADD CONSTRAINT username_email_key UNIQUE (email);


--
-- Name: username username_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.username
    ADD CONSTRAINT username_pkey PRIMARY KEY (id);


--
-- Name: username username_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.username
    ADD CONSTRAINT username_username_key UNIQUE (username);


--
-- Name: waiting_list waiting_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waiting_list
    ADD CONSTRAINT waiting_list_pkey PRIMARY KEY (waiting_id);


--
-- Name: ux_one_active_loan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_one_active_loan ON public.booklending USING btree (book_id) WHERE (return_date IS NULL);


--
-- Name: booklending trigger_book_status; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_book_status AFTER INSERT OR UPDATE ON public.booklending FOR EACH ROW EXECUTE FUNCTION public.update_book_status();


--
-- Name: book fk_bookcategory; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT fk_bookcategory FOREIGN KEY (category_id) REFERENCES public.bookcategory(category_id);


--
-- Name: booklending fk_lendingbook; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booklending
    ADD CONSTRAINT fk_lendingbook FOREIGN KEY (book_id) REFERENCES public.book(book_id);


--
-- Name: penalty fk_penaltyuser; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penalty
    ADD CONSTRAINT fk_penaltyuser FOREIGN KEY (id) REFERENCES public.username(id);


--
-- Name: bookreturn fk_returnlending; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookreturn
    ADD CONSTRAINT fk_returnlending FOREIGN KEY (loan_id) REFERENCES public.booklending(loan_id);


--
-- Name: bookreturn fk_returnpenalty; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookreturn
    ADD CONSTRAINT fk_returnpenalty FOREIGN KEY (penalty_id) REFERENCES public.penalty(penalty_id);


--
-- Name: waiting_list fk_waiting_book; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waiting_list
    ADD CONSTRAINT fk_waiting_book FOREIGN KEY (book_id) REFERENCES public.book(book_id);


--
-- Name: waiting_list fk_waiting_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waiting_list
    ADD CONSTRAINT fk_waiting_user FOREIGN KEY (id) REFERENCES public.username(id);


--
-- PostgreSQL database dump complete
--

\unrestrict Pa8Je4MvaFx56sLD2E3v4vwpN8LykmimdEfbnOvywHjRX0tA09hlTeTekLwrSLT


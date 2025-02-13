/* We are not doing this - the databases are already created */
-- CREATE DATABASE AA
GO

/* We are not doing this either - after logging in, we are in the correct (our) database */
-- use AA

/* We delete all previously created tables in the reverse order
** of how they were created
** First, we create VOIVODESHIPS, then CITIES, then PEOPLE, then COMPANIES, and finally JOBS
** We delete in the reverse order
*/
IF OBJECT_ID('JOBS') IS NOT NULL /* We can delete starting from JOBS - we cannot, for example, start from VOIVODESHIPS */
	DROP TABLE JOBS

IF OBJECT_ID('COMPANIES') IS NOT NULL 
	DROP TABLE COMPANIES

IF OBJECT_ID('PEOPLE') IS NOT NULL 
	DROP TABLE PEOPLE

IF OBJECT_ID('CITIES') IS NOT NULL 
	DROP TABLE CITIES

IF OBJECT_ID('VOIVODESHIPS') IS NOT NULL /* If the table already exists, delete it */
	DROP TABLE VOIVODESHIPS

GO 

/* We create the tables in the correct order */
CREATE TABLE dbo.VOIVODESHIPS 
(	voivodeship_code	nchar(4)		NOT NULL CONSTRAINT PK_VOIVODESHIPS PRIMARY KEY
,	name	nvarchar(40)	NOT NULL
)
GO

CREATE TABLE dbo.CITIES 
(	voivodeship_code nchar(4) NOT NULL
		CONSTRAINT FK_VOIVODESHIPS FOREIGN KEY
		REFERENCES VOIVODESHIPS(VOIVODESHIP_CODE)
,	name	nvarchar(40) NOT NULL
/* Self-incrementing primary key */
,	city_id int NOT NULL IDENTITY CONSTRAINT PK_CITIES PRIMARY KEY
)
GO

CREATE TABLE dbo.PEOPLE 
(	city_id INT NOT NULL 
		CONSTRAINT FK_PEOPLE_CITIES FOREIGN KEY
		REFERENCES CITIES(CITY_ID)
,	first_name		nvarchar(40)	NOT NULL
,	last_name	nvarchar(40)	NOT NULL
,	address		nvarchar(100)	NOT NULL
,	person_id int NOT NULL IDENTITY 
		CONSTRAINT PK_PEOPLE PRIMARY KEY
)
GO

CREATE TABLE dbo.COMPANIES 
(	city_id INT NOT NULL 
		CONSTRAINT FK_COMPANIES_CITIES FOREIGN KEY
		REFERENCES CITIES(CITY_ID)
,	name		nvarchar(80)	NOT NULL
,	postal_code	nchar(6)	NOT NULL
,	street		nvarchar(50)	NOT NULL
,	short_name nchar(5) NOT NULL  CONSTRAINT PK_COMPANIES PRIMARY KEY
)
GO

CREATE TABLE dbo.JOBS 
(	company_id nchar(5) NOT NULL 
		CONSTRAINT FK_JOBS_COMPANIES FOREIGN KEY
		REFERENCES COMPANIES(SHORT_NAME)
,	person_id INT NOT NULL
		CONSTRAINT FK_JOBS_PEOPLE FOREIGN KEY
		REFERENCES PEOPLE(PERSON_ID)
,	position		nvarchar(40)	NOT NULL
,	salary	MONEY		NOT NULL
,	from_date		DATETIME	NOT NULL
,	to_date		DATETIME	NULL
,	job_id INT NOT NULL IDENTITY CONSTRAINT PK_JOBS PRIMARY KEY
)
GO

/* We still need to add commands for COMPANIES and JOBS */

INSERT INTO VOIVODESHIPS (voivodeship_code, name) VALUES ('MAZ', 'Mazowieckie')

INSERT INTO VOIVODESHIPS (voivodeship_code, name) VALUES ('WLK', 'Wielkopolskie')

INSERT INTO VOIVODESHIPS (voivodeship_code, name) VALUES ('ŁDZ', 'Łódzkie')

DECLARE @id_wes int	/* To store the ID assigned to Wesoła */
	,	@id_wwa int /* To store the ID assigned to Warszawa */
	,	@id_poz int /* To store the ID assigned to Poznań */
	,	@id_kon int /* To store the ID assigned to Konin */
	,	@id_les int /* To store the ID assigned to Leszno */
	,	@id_gnz int /* To store the ID assigned to Gniezno */
	,	@id_lub int /* To store the ID assigned to Luboń */
	,	@id_kos int /* To store the ID assigned to Kościan */
	,	@id_ms	int /* To store the ID assigned to Maciej Stodolski
					** so we can create jobs for him later */
	,	@id_jk	int /* To store the ID assigned to J K
					** so we can create jobs for him later */
	,	@id_ts  int /* To store the ID assigned to Taylor Swift */
	,	@id_hg  int /* To store the ID assigned to Hermiona Granger */
	,	@id_gr  int /* To store the ID assigned to Geralt Riv */
	,	@id_tm  int /* To store the ID assigned to Triss Merigold */
	,	@id_gh  int /* To store the ID assigned to Grace Hanson */
	,	@id_lc  int /* To store the ID assigned to Lara Croft */
	,	@id_nd  int /* To store the ID assigned to Nathan Drake */

INSERT INTO CITIES (voivodeship_code, name) VALUES ('MAZ', 'Wesoła')
SET @id_wes = SCOPE_IDENTITY()

INSERT INTO CITIES (voivodeship_code, name) VALUES ('MAZ', 'Warszawa')
SET @id_wwa = SCOPE_IDENTITY()

INSERT INTO CITIES (voivodeship_code, name) VALUES ('WLK', 'Poznań')
SET @id_poz = SCOPE_IDENTITY()

INSERT INTO CITIES (voivodeship_code, name) VALUES ('WLK', 'Konin')
SET @id_kon = SCOPE_IDENTITY()

INSERT INTO CITIES (voivodeship_code, name) VALUES ('WLK', 'Leszno')
SET @id_les = SCOPE_IDENTITY()

INSERT INTO CITIES (voivodeship_code, name) VALUES ('WLK', 'Gniezno')
SET @id_gnz = SCOPE_IDENTITY()

INSERT INTO CITIES (voivodeship_code, name) VALUES ('WLK', 'Luboń')
SET @id_lub = SCOPE_IDENTITY()

INSERT INTO CITIES (voivodeship_code, name) VALUES ('WLK', 'Kościan')
SET @id_kos = SCOPE_IDENTITY()

INSERT INTO COMPANIES(short_name, city_id, name, postal_code, street) VALUES ('CDPR', @id_wwa, 'CD PROJECT RED', '03-301', 'Jagiellońska 74')

INSERT INTO COMPANIES(short_name, city_id, name, postal_code, street) VALUES ('TECH', @id_wwa, 'Techland', '00-189', 'Inflancka 4c')

INSERT INTO COMPANIES(short_name, city_id, name, postal_code, street) VALUES ('GSK', @id_poz, 'GlaxoSmithKline', '60-322', 'Grunwaldzka 189')

INSERT INTO COMPANIES(short_name, city_id, name, postal_code, street) VALUES ('KMP', @id_poz, 'Komputronik', '60-003', 'Wołczyńska 37')

INSERT INTO COMPANIES(short_name, city_id, name, postal_code, street) VALUES ('AQU', @id_poz, 'Aquanet', '61-492', 'ul. Dolna Wilda 126')

-- Check that the keys work
INSERT INTO COMPANIES(short_name, city_id, name, postal_code, street) VALUES ('NIE', 666, 'Non-existent', '66-666', 'ul. Nowhere 666')
DELETE FROM CITIES where city_id = @id_wwa; -- This check will work when running the entire script due to the use of the variable @id_wwa
/*
Msg 547, Level 16, State 0, Line 65
The INSERT statement conflicted with the FOREIGN KEY constraint "FK_COMPANIES_CITIES". The conflict occurred in database "b3_325445", table "dbo.CITIES", column 'city_id'.
The statement has been terminated.
Msg 547, Level 16, State 0, Line 66
The DELETE statement conflicted with the REFERENCE constraint "FK_COMPANIES_CITIES". The conflict occurred in database "b3_325445", table "dbo.COMPANIES", column 'city_id'.
The statement has been terminated.
*/

INSERT INTO PEOPLE (first_name, last_name, city_id, address) VALUES ('Maciej', 'St', @id_wes, 'pod M')
SET @id_ms = SCOPE_IDENTITY()

INSERT INTO PEOPLE (first_name, last_name, city_id, address) VALUES ('J', 'K', @id_wwa, 'somewhere')
SET @id_jk = SCOPE_IDENTITY()

INSERT INTO PEOPLE (first_name, last_name, city_id, address) VALUES ('Taylor', 'Swift', @id_poz, 'my heart')
SET @id_ts = SCOPE_IDENTITY()

INSERT INTO PEOPLE (first_name, last_name, city_id, address) VALUES ('Dawid', 'Podsiadło', @id_poz, 'somewhere')

INSERT INTO PEOPLE (first_name, last_name, city_id, address) VALUES ('Hermiona', 'Granger', @id_poz, 'Hogwarts')
SET @id_hg = SCOPE_IDENTITY()

INSERT INTO PEOPLE (first_name, last_name, city_id, address) VALUES ('Geralt', 'Riv', @id_poz, 'Kaer Morhen')
SET @id_gr = SCOPE_IDENTITY()

INSERT INTO PEOPLE (first_name, last_name, city_id, address) VALUES ('Triss', 'Merigold', @id_poz, 'Aretuza')
SET @id_tm = SCOPE_IDENTITY()

INSERT INTO PEOPLE (first_name, last_name, city_id, address) VALUES ('Grace', 'Hanson', @id_poz, 'Beach House')
SET @id_gh = SCOPE_IDENTITY()

INSERT INTO PEOPLE (first_name, last_name, city_id, address) VALUES ('Frankie', 'Bergstein', @id_poz, 'Beach House')

INSERT INTO PEOPLE (first_name, last_name, city_id, address) VALUES ('Lara', 'Croft', @id_poz, 'Tomb')
SET @id_lc = SCOPE_IDENTITY()

INSERT INTO PEOPLE (first_name, last_name, city_id, address) VALUES ('Indiana', 'Jones', @id_kos, 'Lost Ark')

INSERT INTO PEOPLE (first_name, last_name, city_id, address) VALUES ('Nathan', 'Drake', @id_kos, 'Shambhala ')
SET @id_nd = SCOPE_IDENTITY()

INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (@id_ts, 'AQU', 'Queen', 13000000, CONVERT(datetime,'19891213',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date, to_date) VALUES (@id_lc, 'CDPR', 'Tester', 4000, CONVERT(datetime,'20040101',112),  CONVERT(datetime,'20050101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date, to_date) VALUES (@id_gh, 'CDPR', 'Programmer', 13000,  CONVERT(datetime,'20050101',112),  CONVERT(datetime,'20080101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date, to_date) VALUES (@id_gh, 'CDPR', 'Director', 50000,  CONVERT(datetime,'20080101',112),  CONVERT(datetime,'20200101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date, to_date) VALUES (@id_nd, 'TECH', 'Concept Artist', 6000,  CONVERT(datetime,'20070101',112),  CONVERT(datetime,'20090101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date, to_date) VALUES (@id_gr, 'CDPR', 'Director', 45000,  CONVERT(datetime,'20090101',112),  CONVERT(datetime,'20150101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (@id_ms, 'KMP', 'Director', 13000000,  CONVERT(datetime,'20110101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (@id_jk, 'KMP', 'Tester', 1300,  CONVERT(datetime,'19500101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (@id_hg, 'GSK', 'Financial Director', 40000,  CONVERT(datetime,'20140101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (@id_gr, 'GSK', 'President', 70000,  CONVERT(datetime,'20150101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (@id_tm, 'CDPR', 'Graphic Designer', 8500,  CONVERT(datetime,'20170101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (@id_lc, 'CDPR', 'Sound Engineer', 8000,  CONVERT(datetime,'20190101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (@id_ts, 'TECH', 'Animator', 9000,  CONVERT(datetime,'20220101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (@id_ts, 'TECH', 'Programmer', 15000,  CONVERT(datetime,'20120101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (@id_ts, 'AQU', 'Director', 90000,  CONVERT(datetime,'20130101',112)) 

INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (@id_ts, 'AQU', 'Programmer', 10000,  CONVERT(datetime,'20170101',112)) 


/* First, we add companies and then positions - in companies, we assign primary keys ourselves */

/* From the Query menu, select RESULTS TO TXT and run the following queries. 
** Copy and paste their results as a comment */
SELECT * FROM PROVINCES
/*region_code  name
------------  ----------------------------------------
ŁDZ           Łódzkie
MAZ           Mazowieckie
WLK           Wielkopolskie

(3 row(s) affected)
*/
SELECT * FROM CITIES
/*region_code  name                                    city_id
------------  ---------------------------------------- -----------
MAZ           Wesoła                                   1
MAZ           Warsaw                                   2
WLK           Poznań                                   3
WLK           Konin                                    4
WLK           Leszno                                   5
WLK           Gniezno                                  6
WLK           Luboń                                    7
WLK           Kościan                                  8

(8 row(s) affected)
*/
SELECT * FROM PEOPLE
/*
city_id   first_name                                last_name                                 address                                                                                                person_id
--------  ----------------------------------------  ----------------------------------------  ---------------------------------------------------------------------------------------------------- -----------
1         Maciej                                   St                                       pod M                                                                                                1
2         J                                        K                                        somewhere                                                                                            2
3         Taylor                                   Swift                                    my heart                                                                                             3
3         Dawid                                    Podsiadło                                somewhere                                                                                            4
3         Hermione                                 Granger                                  Hogwarts                                                                                            5
3         Geralt                                   Riv                                      Kaer Morhen                                                                                          6
3         Triss                                    Merigold                                 Aretuza                                                                                              7
3         Grace                                    Hanson                                   Beach house                                                                                          8
3         Frankie                                  Bergstein                                Beach house                                                                                          9
3         Lara                                     Croft                                    Tomb                                                                                                 10
8         Indiana                                  Jones                                    Lost Ark                                                                                            11
8         Nathan                                   Drake                                    Shambhala                                                                                           12

(12 row(s) affected)
*/

SELECT * FROM COMPANIES
/*
city_id   name                                                                               postal_code  street                                          short_name
--------  --------------------------------------------------------------------------------  ------------  --------------------------------------------  ---------
3         Aquanet                                                                           61-492        ul. Dolna Wilda 126                           AQU  
2         CD PROJECT RED                                                                    03-301        Jagiellońska 74                               CDPR 
3         GlaxoSmithKline                                                                   60-322        Grunwaldzka 189                               GSK  
3         Komputronik                                                                       60-003        Wołczyńska 37                                 KMP  
2         Techland                                                                          00-189        Inflancka 4c                                  TECH 

(5 row(s) affected)
*/

SELECT * FROM JOBS
/*
company_id  person_id  position                              salary               from_date               to_date                 job_id
----------  ---------  ------------------------------------  -------------------  ----------------------  ----------------------  -----------
AQU        3          Queen                                 13000000.00           1989-12-13 00:00:00.000 NULL                     1
CDPR       10         Tester                                4000.00               2004-01-01 00:00:00.000 2005-01-01 00:00:00.000  2
CDPR       8          Programmer                            13000.00              2005-01-01 00:00:00.000 2008-01-01 00:00:00.000  3
CDPR       8          Director                              50000.00              2008-01-01 00:00:00.000 2020-01-01 00:00:00.000  4
TECH       12         Concept Artist                        6000.00               2007-01-01 00:00:00.000 2009-01-01 00:00:00.000  5
CDPR       6          Director                              45000.00              2009-01-01 00:00:00.000 2015-01-01 00:00:00.000  6
KMP        1          Director                              13000000.00           2011-01-01 00:00:00.000 NULL                     7
KMP        2          Tester                                1300.00               1950-01-01 00:00:00.000 NULL                     8
GSK        5          CFO                                   40000.00              2014-01-01 00:00:00.000 NULL                     9
GSK        6          President                             70000.00              2015-01-01 00:00:00.000 NULL                     10
CDPR       7          Graphic Designer                      8500.00               2017-01-01 00:00:00.000 NULL                     11
CDPR       10         Sound Engineer                        8000.00               2019-01-01 00:00:00.000 NULL                     12
TECH       3          Animator                              9000.00               2022-01-01 00:00:00.000 NULL                     13
TECH       3          Programmer                            15000.00              2012-01-01 00:00:00.000 NULL                     14
AQU        3          Director                              90000.00              2013-01-01 00:00:00.000 NULL                     15
AQU        3          Programmer                            10000.00              2017-01-01 00:00:00.000 NULL                     16

(16 row(s) affected)
*/
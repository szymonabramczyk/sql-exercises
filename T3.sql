-- Z3.1

/*select e.person_id, count(*) as job_count
from jobs e
group by e.person_id
order by 2 DESC*/  

--INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (10, 'AQU', 'Novice', 7, CONVERT(datetime,'20230321',112)) 
--INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (6, 'TECH', 'Novice', 13, CONVERT(datetime,'20230321',112)) 

IF OBJECT_ID(N'tempdb..#ot') IS NOT NULL 
	DROP TABLE #ot

SELECT o.person_id, 
	LEFT(o.first_name, 10) as first_name, 
	LEFT(o.last_name, 15) as last_name,
	e.salary, f.short_name, 
	LEFT(f.name, 20) as [company name] INTO #ot
	FROM JOBS e
	JOIN PEOPLE o ON ( o.person_id = e.person_id )
	JOIN COMPANIES f ON ( f.short_name = e.company_id )
	WHERE e.salary = (SELECT MIN(eW.salary) AS min_salary
						FROM JOBS eW
						WHERE eW.person_id = e.person_id )
/*
person_id  first_name last_name      salary                short_name company name
---------- ---------- --------------- --------------------- ---------- --------------------
1          Maciej     St              13000000.00           KMP        Komputronik
2          J          K               1300.00               KMP        Komputronik
3          Taylor     Swift           9000.00               TECH       Techland
5          Hermiona   Granger         40000.00              GSK        GlaxoSmithKline
6          Geralt     Riv             13.00                 TECH       Techland
7          Triss      Merigold        8500.00               CDPR       CD PROJECT RED
8          Grace      Hanson          13000.00              CDPR       CD PROJECT RED
10         Lara       Croft           7.00                  AQU        Aquanet
12         Nathan     Drake           6000.00               TECH       Techland

(9 row(s) affected)
*/

-- Z3.2

SELECT * FROM #ot
	WHERE salary = (SELECT MIN(oW.salary)
						FROM #ot oW)

/*
person_id  first_name last_name      salary                short_name company name
---------- ---------- --------------- --------------------- ---------- --------------------
10         Lara       Croft           7.00                  AQU        Aquanet

(1 row(s) affected)
*/

-- Z3.3

SELECT  f.short_name, 
	LEFT(f.name, 30) as [company name]
	FROM COMPANIES f
	WHERE NOT EXISTS ( SELECT DISTINCT fW.short_name
						FROM COMPANIES fW
						JOIN JOBS eW ON ( eW.company_id = fW.short_name )
						JOIN PEOPLE oW ON ( oW.person_id = eW.person_id )
						WHERE oW.last_name = 'Croft'
						AND fW.short_name = f.short_name)
/*
short_name company name
---------- ------------------------------
GSK        GlaxoSmithKline
KMP        Komputronik
TECH       Techland

(3 row(s) affected)
*/

-- Z3.4
SELECT  f.short_name, 
	LEFT(f.name, 30) as [company name],
	LEFT(m.name, 15) as [city],
	LEFT(w.name, 15) as [voivodeship]
	FROM COMPANIES f
	JOIN CITIES m ON (m.city_id = f.city_id)
	JOIN VOIVODESHIPS w ON (w.voivodeship_code = m.voivodeship_code )
	WHERE NOT EXISTS ( SELECT DISTINCT fW.short_name
						FROM COMPANIES fW
						JOIN JOBS eW ON ( eW.company_id = fW.short_name )
						JOIN PEOPLE oW ON ( oW.person_id = eW.person_id )
						JOIN CITIES mW ON ( mW.city_id = oW.city_id )
						WHERE mW.name = 'Warsaw'
						AND fW.short_name = f.short_name )


/*
short_name company name                    city            voivodeship
---------- ------------------------------ --------------- ---------------
AQU        Aquanet                        Pozna?          Wielkopolskie
CDPR       CD PROJECT RED                 Warszawa        Mazowieckie
GSK        GlaxoSmithKline                Pozna?          Wielkopolskie
TECH       Techland                       Warszawa        Mazowieckie

(4 row(s) affected)
*/
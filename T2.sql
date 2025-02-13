-- 2.1

--INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (1, 'AQU', 'Aquaman', 13000013, CONVERT(datetime, '20001010', 112))
--INSERT INTO JOBS (person_id, company_id, position, salary, from_date) VALUES (8, 'CDPR', 'Witcher', 13000013, CONVERT(datetime, '20191212', 112))

DECLARE @p money

SELECT @p = MAX(e.SALARY)
	FROM JOBS e, COMPANIES f
	WHERE e.company_id = f.short_name
	AND f.short_name = 'CDPR'

SELECT e.company_id, 
	LEFT(f.name, 20) AS [company name], 
	e.salary, 
	LEFT(o.first_name, 12) AS first_name, 
	LEFT(o.last_name, 20) AS last_name
	FROM JOBS e, COMPANIES f, PEOPLE o
	WHERE e.company_id = f.short_name
	AND o.person_id = e.person_id
	AND e.salary = @p
	AND e.company_id = 'CDPR'

/*
company_id company name         salary                first_name    last_name
---------- -------------------- --------------------- ------------ --------------------
CDPR       CD PROJECT RED       13000013.00           Grace         Hanson

(1 row(s) affected)
*/

-- 2.2
SELECT e.salary, 
	LEFT(e.position, 15) AS position, 
	LEFT(o.first_name, 12) AS first_name, 
	LEFT(o.last_name, 20) AS last_name, 
	LEFT(f.name, 20) AS [company name],
	LEFT(mo.name, 20) AS [person's city], 
	LEFT(mo.voivodeship_code, 4) AS [person's voivodeship],
	LEFT(mf.name, 20) AS [company's city], 
	LEFT(mf.voivodeship_code, 4) AS [company's voivodeship]
	FROM JOBS e, PEOPLE o, COMPANIES f, CITIES mf, CITIES mo
	WHERE e.company_id = f.short_name
	AND e.person_id = o.person_id
	AND f.city_id = mf.city_id
	AND o.city_id = mo.city_id
	AND mo.voivodeship_code LIKE 'm%'
	AND mf.voivodeship_code LIKE 'w%'

/*
salary                position         first_name    last_name              company name          person's city         person's voivodeship company's city         company's voivodeship
--------------------- --------------- ------------ -------------------- -------------------- -------------------- --------- -------------------- ---------
13000000.00           Director        Maciej       St                   Komputronik          Weso?a                MAZ       Pozna?                WLK 
1300.00               Tester          J            K                    Komputronik          Warszawa              MAZ       Pozna?                WLK 
13000013.00           Aquaman         Maciej       St                   Aquanet              Weso?a                MAZ       Pozna?                WLK 

(3 row(s) affected)
*/
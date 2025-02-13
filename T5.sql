-- 5.1

--INSERT INTO jobs (person_id, company_id, position, salary, from_date) VALUES (1, 'KMP', 'Deputy Director', 1, CONVERT(datetime,'20160101',112))
--INSERT INTO jobs (person_id, company_id, position, salary, from_date) VALUES (1, 'CDPR', 'Guest', 1, CONVERT(datetime,'20230101',112))
--INSERT INTO jobs (person_id, company_id, position, salary, from_date) VALUES (1, 'CDPR', 'Guest', 1, CONVERT(datetime,'20230102',112))

CREATE TABLE #n (company_name nvarchar(100) not null constraint PK_n_f PRIMARY KEY)
INSERT INTO #n(company_name) VALUES ('Komputronik') 
INSERT INTO #n(company_name) VALUES ('CD PROJECT RED')
INSERT INTO #n(company_name) VALUES ('Aquanet')

SELECT o.person_id, o.first_name, o.last_name FROM people o 
    JOIN jobs e ON ( e.person_id = o.person_id )
    JOIN companies f ON ( f.short_name = e.company_id )
    JOIN #n ON ( #n.company_name = f.name )
    GROUP BY o.person_id, o.first_name, o.last_name
    HAVING COUNT(DISTINCT f.short_name) = (SELECT COUNT(*) FROM #n) 

/*
person_id   first_name                              last_name
----------- ---------------------------------------- ----------------------------------------
1           Maciej                                   St

(1 row affected)
*/

-- 5.2

-- ALTER TABLE people ADD active_jobs_count int NOT NULL DEFAULT 0

UPDATE PEOPLE
    SET active_jobs_count = X.active_jobs_count
    FROM people
    JOIN ( SELECT eW.person_id, COUNT(*) as active_jobs_count FROM jobs eW
            WHERE eW.to_date IS NULL 
            GROUP BY eW.person_id 
        ) X ON (X.person_id = people.person_id)

--SELECT o.person_id, e.company_id, e.to_date FROM people o 
--		JOIN jobs e ON (e.person_id = o.person_id)
--		ORDER BY 1

SELECT o.person_id, o.active_jobs_count FROM people o 

/*
person_id   active_jobs_count
----------- -----------
1           5
2           1
3           5
4           0
5           1
6           2
7           1
8           1
9           0
10          2
11          0
12          0

(12 rows affected)
*/
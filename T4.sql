
CREATE PROCEDURE dbo.search_companies
( @short_name nvarchar(40) = NULL
, @full_name nvarchar(40) = NULL
, @city_name nvarchar(40) = NULL
)
AS
	DECLARE @query nvarchar(4000), @where nvarchar(1000)
	SET @query = 'SELECT f.*, m.name AS [city], w.name AS [voivodeship] FROM companies f JOIN cities m ON (m.city_id = f.city_id) JOIN voivodeships w ON (w.voivodeship_code = m.voivodeship_code)'
	EXEC dbo.add_cond @where = @where OUTPUT, @col = N'f.short_name', @val = @short_name
	EXEC dbo.add_cond @where = @where OUTPUT, @col = N'f.name', @val = @full_name
	EXEC dbo.add_cond @where = @where OUTPUT, @col = N'm.name', @val = @city_name
	SET @query = @query + @where
	SELECT @query
	EXEC sp_sqlexec @query

GO

--SELECT f.*, m.name AS [city], w.name AS [voivodeship] FROM companies f JOIN cities m ON (m.city_id = f.city_id) JOIN voivodeships w ON (w.voivodeship_code = m.voivodeship_code)

EXEC search_companies @short_name = N'AQU'
/*
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT f.*, m.name AS [city], w.name AS [voivodeship] FROM companies f JOIN cities m ON (m.city_id = f.city_id) JOIN voivodeships w ON (w.voivodeship_code = m.voivodeship_code) WHERE (f.short_name = 'AQU') 

(1 row(s) affected)

city_id     name                                                                             postal_code street                                              short_name city                                     voivodeship
----------- -------------------------------------------------------------------------------- ----------- -------------------------------------------------- ---------- ---------------------------------------- ----------------------------------------
3           Aquanet                                                                          61-492      ul. Dolna Wilda 126                                AQU        Pozna?                                   Wielkopolskie

(1 row(s) affected)
*/

EXEC search_companies @short_name = N'CDPR', @city_name = N'Warsaw'
/*
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT f.*, m.name AS [city], w.name AS [voivodeship] FROM companies f JOIN cities m ON (m.city_id = f.city_id) JOIN voivodeships w ON (w.voivodeship_code = m.voivodeship_code) WHERE (f.short_name = 'CDPR')  AND (m.name = 'Warsaw') 

(1 row(s) affected)

city_id     name                                                                             postal_code street                                              short_name city                                     voivodeship
----------- -------------------------------------------------------------------------------- ----------- -------------------------------------------------- ---------- ---------------------------------------- ----------------------------------------
2           CD PROJECT RED                                                                   03-301      Jagiello?ska 74                                    CDPR       Warsaw                                   Mazowieckie

(1 row(s) affected)
*/

EXEC search_companies @full_name = N'Aquanet'
/*
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT f.*, m.name AS [city], w.name AS [voivodeship] FROM companies f JOIN cities m ON (m.city_id = f.city_id) JOIN voivodeships w ON (w.voivodeship_code = m.voivodeship_code) WHERE (f.name = 'Aquanet') 

(1 row(s) affected)

city_id     name                                                                             postal_code street                                              short_name city                                     voivodeship
----------- -------------------------------------------------------------------------------- ----------- -------------------------------------------------- ---------- ---------------------------------------- ----------------------------------------
3           Aquanet                                                                          61-492      ul. Dolna Wilda 126                                AQU        Pozna?                                   Wielkopolskie

(1 row(s) affected)
*/

EXEC search_companies @full_name = N'Aquanet', @city_name = N'Warsaw'
/*
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT f.*, m.name AS [city], w.name AS [voivodeship] FROM companies f JOIN cities m ON (m.city_id = f.city_id) JOIN voivodeships w ON (w.voivodeship_code = m.voivodeship_code) WHERE (f.name = 'Aquanet')  AND (m.name = 'Warsaw') 

(1 row(s) affected)

city_id     name                                                                             postal_code street                                              short_name city                                     voivodeship
----------- -------------------------------------------------------------------------------- ----------- -------------------------------------------------- ---------- ---------------------------------------- ----------------------------------------

(0 row(s) affected)
*/
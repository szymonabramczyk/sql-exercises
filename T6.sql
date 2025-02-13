
IF OBJECT_ID('RETURN') IS NOT NULL 
	DROP TABLE RETURN

IF OBJECT_ID('RENTAL') IS NOT NULL 
	DROP TABLE RENTAL

IF OBJECT_ID('CLIENT') IS NOT NULL 
	DROP TABLE CLIENT

IF OBJECT_ID('CARS') IS NOT NULL
	DROP TABLE CARS

CREATE TABLE dbo.CARS 
(	car_id int not null identity 
        CONSTRAINT PK_CARS PRIMARY KEY
    , model nvarchar(60)
    , available_count int not null DEFAULT 0
    , purchased_count int not null 
)
GO

CREATE TABLE dbo.CLIENT 
(	name nvarchar(100) not null
    , address nvarchar(100) not null
    , client_id int not null identity 
        CONSTRAINT PK_CLIENT PRIMARY KEY
)
GO

CREATE TABLE dbo.RENTAL 
(	rental_id int not null identity 
        CONSTRAINT PK_RENTAL PRIMARY KEY
    , client_id int not null 
        CONSTRAINT FK_CLIENT_RENTAL FOREIGN KEY
        REFERENCES CLIENT( client_id )
    , car_id int not NULL
        CONSTRAINT FK_CARS_RENTAL FOREIGN KEY
        REFERENCES CARS( car_id ) 
    , quantity int not null
)
GO

CREATE TABLE dbo.RETURN 
(	return_id int not null identity 
        CONSTRAINT PK_RETURN PRIMARY KEY
    , client_id int not null 
        CONSTRAINT FK_CLIENT_RETURN FOREIGN KEY
        REFERENCES CLIENT( client_id )
    , car_id int not NULL
        CONSTRAINT FK_CARS_RETURN FOREIGN KEY
        REFERENCES CARS( car_id )
    , quantity int not null 
)

GO
CREATE TRIGGER dbo.CARS_INS ON CARS FOR INSERT
AS 
    UPDATE cars SET available_count = i.purchased_count
        FROM cars c
        JOIN inserted i ON (c.car_id = i.car_id)
GO

CREATE TRIGGER dbo.CARS_UPD ON CARS FOR UPDATE
AS 
    UPDATE cars SET available_count = d.available_count + i.purchased_count - d.purchased_count
        FROM cars c
        JOIN inserted i ON (c.car_id = i.car_id)
        JOIN deleted d ON (i.car_id = d.car_id)
        WHERE NOT (i.purchased_count = d.purchased_count)
    IF UPDATE (available_count)
        IF EXISTS (
                SELECT 1 FROM CARS c
                WHERE c.available_count < 0
                OR c.available_count > c.purchased_count
        )
        BEGIN
            RAISERROR (N'ERROR: New available car count is less than 0 or greater than purchased!', 16, 3);
            ROLLBACK TRAN
        END
GO

GO
CREATE TRIGGER dbo.RENTAL_ALL ON RENTAL FOR INSERT, UPDATE, DELETE
AS
    UPDATE cars SET available_count = available_count - X.total
        FROM cars c
        JOIN ( SELECT i.car_id, SUM( i.quantity ) as [total] FROM inserted i
            GROUP BY i.car_id ) X on (X.car_id = c.car_id)

    UPDATE cars SET available_count = available_count + X.total
        FROM cars c
        JOIN ( SELECT d.car_id, SUM( d.quantity ) as [total] FROM deleted d
            GROUP BY d.car_id ) X on (X.car_id = c.car_id)
GO

CREATE TRIGGER dbo.RETURN_ALL ON RETURN FOR INSERT, UPDATE, DELETE
AS
    UPDATE cars SET available_count = available_count + X.total
        FROM cars c
        JOIN ( SELECT i.car_id, SUM( i.quantity ) as [total] FROM inserted i
            GROUP BY i.car_id ) X on (X.car_id = c.car_id)

    UPDATE cars SET available_count = available_count - X.total
        FROM cars c
        JOIN ( SELECT d.car_id, SUM( d.quantity ) as [total] FROM deleted d
            GROUP BY d.car_id ) X on (X.car_id = c.car_id)
GO

/*
Inserting multiple records into cars,
Inserting multiple rentals in one INSERT,
Inserting multiple returns in one INSERT,
Updating purchased_count in the cars table for cars that have returns and rentals.
*/

INSERT INTO cars ( model, purchased_count  ) VALUES ( N'Nissan Qashqai', 13 )

INSERT INTO cars ( model, purchased_count )
    VALUES ( N'Opel Vectra', 1 ),
    ( N'Skoda Octavia', 25 ),
    ( N'Mazda 6', 17 )

SELECT * FROM cars

/*
car_id  model           available_count   purchased_count
------  --------------- ------------------  ------------------
1	    Nissan Qashqai	13	                13
2	    Opel Vectra	    1	                1
3	    Skoda Octavia	25	                25
4	    Mazda 6	        17	                17
*/

INSERT INTO CLIENT ( name, address ) VALUES ( N'Taylor Swift', N'Nashville, Cornelia Street')
INSERT INTO CLIENT ( name, address ) VALUES ( N'Bishop Briggs', N'USA')

SELECT * FROM CLIENT
/*
name           address                           client_id
--------------  ------------------------------- ------------
Taylor Swift	Nashville, Cornelia Street	    1
Bishop Briggs	USA	                            2
*/

INSERT INTO rental ( client_id, car_id, quantity ) VALUES ( 1, 1, 18 )
/*
(0 rows affected)
Msg 50000, Level 16, State 3, Procedure CARS_UPD, Line 16
ERROR: New available car count is less than 0 or greater than purchased!
Msg 3609, Level 16, State 1, Procedure RENTAL_ALL, Line 3
The transaction ended in the trigger. The batch has been aborted.
Total execution time: 00:00:00.037
*/

INSERT INTO rental ( client_id, car_id, quantity ) 
    VALUES ( 1, 1, 12 ),
    (1, 4, 3),
    (2, 1, 1),
    (2, 2, 1)

SELECT * FROM rental
/*
rental_id  client_id  car_id    quantity
------  ----------- ------  ------
2	    1	        1	    12
3   	1	        4	    3
4	    2	        1	    1
5	    2	        2	    1
*/

SELECT * FROM cars
/*
car_id  model           available_count   purchased_count
------  --------------- ------------------  ------------------
1	    Nissan Qashqai	0	                13
2	    Opel Vectra	    0	                1
3	    Skoda Octavia	25	                25
4	    Mazda 6	        14	                17
*/

INSERT INTO RETURN ( client_id, car_id, quantity ) VALUES (1, 1, 14 )
/*
(0 rows affected)
Msg 50000, Level 16, State 3, Procedure CARS_UPD, Line 16
ERROR: New available car count is less than 0 or greater than purchased!
Msg 3609, Level 16, State 1, Procedure RETURN_ALL, Line 4
The transaction ended in the trigger. The batch has been aborted.
Total execution time: 00:00:00.039
*/

INSERT INTO RETURN ( client_id, car_id, quantity ) 
    VALUES (1, 1, 6 ),
    (1, 1, 3 ),
    (1, 4, 2 ),
    (2, 2, 2 )
/*
(0 rows affected)
Msg 50000, Level 16, State 3, Procedure CARS_UPD, Line 16
ERROR: New available car count is less than 0 or greater than purchased!
Msg 3609, Level 16, State 1, Procedure RETURN_ALL, Line 4
The transaction ended in the trigger. The batch has been aborted.
Total execution time: 00:00:00.040
*/

INSERT INTO RETURN ( client_id, car_id, quantity ) 
    VALUES (1, 1, 6 ),
    (1, 1, 3 ),
    (1, 4, 2 ),
    (2, 2, 1 )

SELECT * FROM RETURN
/*
return_id  client_id  car_id    quantity
------  ----------- ------  ------
6	    1	        1	    6
7	    1	        1	    3
8	    1	        4	    2
9	    2	        2	    1
*/

SELECT * FROM cars
/*
car_id  model           available_count   purchased_count
------  --------------- ------------------  ------------------
1	    Nissan Qashqai	9	                13
2	    Opel Vectra	    1	                1
3	    Skoda Octavia	25	                25
4	    Mazda 6	        16	                17
*/

DELETE FROM RETURN WHERE return_id IN (7, 9)

SELECT * FROM RETURN
/*
return_id  client_id  car_id    quantity
------  ----------- ------  ------
6	    1	        1	    6
8	    1	        4	    2
*/

SELECT * FROM cars
/*
car_id  model           available_count   purchased_count
------  --------------- ------------------  ------------------
1	    Nissan Qashqai	6	                13
2	    Opel Vectra	    0	                1
3	    Skoda Octavia	25	                25
4	    Mazda 6	        16	                17
*/

UPDATE cars SET purchased_count = 29 WHERE car_id = 3

SELECT * FROM cars
/*
car_id  model           available_count   purchased_count
------  --------------- ------------------  ------------------
1	    Nissan Qashqai	6	                13
2	    Opel Vectra	    0	                1
3	    Skoda Octavia	29	                29
4	    Mazda 6	        16	                17
*/

UPDATE cars SET purchased_count = 22 WHERE car_id = 1

SELECT * FROM cars
/*
car_id  model           available_count   purchased_count
------  --------------- ------------------  ------------------
1	    Nissan Qashqai	15	                22
2	    Opel Vectra	    0	                1
3	    Skoda Octavia	29	                29
4	    Mazda 6	        16	                17
*/

UPDATE cars SET purchased_count = 27

SELECT * FROM cars
/*
car_id  model           available_count   purchased_count
------  --------------- ------------------  ------------------
1	    Nissan Qashqai	20	                27
2	    Opel Vectra	    26	                27
3	    Skoda Octavia	27	                27
4	    Mazda 6	        26	                27
*/
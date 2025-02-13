# sql-exercises
A series of solutions to SQL exercises, completed as part of a university course.

---

### **T1: Database Setup and Data Population**
1. **Task**: Create a database with:
   - 3 voivodeships, 8 cities (one voivodeship with no cities).
   - 5 companies (3 in one city, 2 in another).
   - 12 people (living in 2 cities not where companies are located).
   - 16 jobs (5 outdated, 3 people with no jobs, 2 with only outdated jobs).
2. **Solution**:
   - Create tables: `VOIVODESHIPS`, `CITIES`, `PEOPLE`, `COMPANIES`, `JOBS`.
   - Insert data into tables.
   - Test foreign keys by attempting to delete a city with people or insert a company in a non-existent city.

---

### **T2: Jobs and Salary Analysis**
1. **Task**:
   - Assign 2 jobs to 2 people with the highest salary (e.g., 100,000 PLN).
   - Find the maximum salary in a company and show who earns it.
   - Show job details (salary, position) and person details (name, company, city, voivodeship) where:
     - The person lives in a voivodeship starting with a specific letter.
     - The company is in a voivodeship starting with a different letter.
2. **Solution**:
   - Insert jobs with the highest salary.
   - Write queries to find the maximum salary and display details.
   - Use joins and filters to show job and person details based on voivodeship codes.

---

### **T3: Job Count and Company Analysis**
1. **Task**:
   - Find people with more than 2 jobs and add jobs if fewer than 4 such people exist.
   - Show the smallest salary for each person and save results in a temporary table.
   - Find the smallest salary in the database using the temporary table.
   - Show companies where a person with a specific last name has never worked.
   - Show companies where no one from a specific city (e.g., Warsaw) has ever worked.
2. **Solution**:
   - Use `GROUP BY` and `HAVING` to find people with multiple jobs.
   - Use `MIN()` to find the smallest salary and save results in a temporary table.
   - Use `NOT EXISTS` to filter companies based on employee last names or city.

---

### **T4: Search Companies Procedure**
1. **Task**:
   - Create a procedure to search companies based on:
     - Short name (`@short_name`).
     - Full name (`@full_name`).
     - City name (`@city_name`).
   - Return company details, city, and voivodeship.
   - Handle NULL parameters dynamically.
2. **Solution**:
   - Build a dynamic SQL query based on non-NULL parameters.
   - Use `EXEC sp_sqlexec` to execute the query.

---

### **T5: Job Assignment and Active Job Count**
1. **Task**:
   - Assign jobs to 3 people (X, Y, Z) in 3 companies (A, B, C):
     - X: 2 jobs in A, 2 in B, 1 in C.
     - Y: 3 jobs in B.
     - Z: 2 jobs in B, 1 in C.
   - Find people working in all companies from a temporary table.
   - Add a column `ACTIVE_JOBS_COUNT` to the `PEOPLE` table and update it with the number of active jobs.
2. **Solution**:
   - Insert jobs for X, Y, Z.
   - Use `GROUP BY` and `HAVING` to find people working in all companies.
   - Use `ALTER TABLE` to add the column and `UPDATE` to populate it.

---

### **T6: Car Rental System with Triggers**
1. **Task**:
   - Create tables: `CARS`, `CLIENT`, `RENTAL`, `RETURN`.
   - Implement triggers to:
     - Update `available_count` in `CARS` when inserting, updating, or deleting records in `RENTAL` or `RETURN`.
     - Ensure `available_count` is never less than 0 or greater than `purchased_count`.
2. **Solution**:
   - Create triggers for `INSERT`, `UPDATE`, and `DELETE` on `RENTAL` and `RETURN`.
   - Use `JOIN` and `SUM` to calculate changes in `available_count`.
   - Add validation to prevent invalid updates.

---

### **Summary of Key SQL Concepts Used**:
1. **Table Creation**: `CREATE TABLE`, `PRIMARY KEY`, `FOREIGN KEY`.
2. **Data Manipulation**: `INSERT`, `UPDATE`, `DELETE`.
3. **Queries**: `SELECT`, `JOIN`, `GROUP BY`, `HAVING`, `MIN`, `MAX`.
4. **Temporary Tables**: `CREATE TABLE #temp`, `INSERT INTO #temp`.
5. **Procedures**: `CREATE PROCEDURE`, dynamic SQL with `EXEC sp_sqlexec`.
6. **Triggers**: `CREATE TRIGGER`, handling `INSERTED` and `DELETED` tables.
7. **Constraints**: `NOT NULL`, `DEFAULT`, `CHECK` (via triggers).

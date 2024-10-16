-- Check if the 'InsertFacultyByDept' procedure exists, and drop it if it does
IF OBJECT_ID('InsertFacultyByDept', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertFacultyByDept; -- Drop the procedure
END;
GO

-- Check if the 'InsertFacultyWhereNotDept' procedure exists, and drop it if it does
IF OBJECT_ID('InsertFacultyWhereNotDept', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertFacultyWhereNotDept; -- Drop the procedure
END;
GO

-- Check if the 'SelectAllFaculty' procedure exists, and drop it if it does
IF OBJECT_ID('SelectAllFaculty', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE SelectAllFaculty; -- Drop the procedure
END;
GO

-- Procedure 1: Insert a faculty member based on the department
CREATE PROCEDURE InsertFacultyByDept
    @fid INT,               -- Faculty ID
    @fname VARCHAR(250),     -- Faculty name
    @deptid INT              -- Department ID
AS
BEGIN
    DECLARE @max_salary DECIMAL(10, 2);  -- Variable to hold the average salary
    DECLARE @new_salary DECIMAL(10, 2);  -- Variable to hold the new calculated salary

    -- Calculate the average salary for the department
    SELECT @max_salary = MAX(salary)
    FROM Faculty
    WHERE deptid = @deptid;  -- Only consider faculty from the given department

    -- Calculate the new salary based on the average salary for the department
    SET @new_salary = CASE
        WHEN @max_salary > 50000 THEN @max_salary * 0.9  -- 10% reduction if avg salary is above 50,000
        WHEN @max_salary < 30000 THEN @max_salary        -- Keep the same salary if it's below 30,000
        ELSE @max_salary * 0.8  -- Apply 20% reduction if avg salary is between 30,000 and 50,000
    END;

    -- Insert the new faculty member into the Faculty table
    INSERT INTO Faculty (fid, fname, deptid, salary)
    VALUES (@fid, @fname, @deptid, @new_salary); -- Use calculated salary for insertion
END;
GO

-- Procedure 2: Insert a faculty member based on the department, excluding a specific department
CREATE PROCEDURE InsertFacultyWhereNotDept
@fid INTEGER,             -- Faculty ID
@fname VARCHAR(250),       -- Faculty name
@deptid INTEGER,           -- Department ID
@notdept INTEGER           -- Department to exclude from salary calculation
AS
BEGIN
    DECLARE @avg_salary DECIMAL(10, 2); -- Variable to hold the average salary

    -- Calculate the average salary excluding the specified department
    SELECT @avg_salary = AVG(salary)
    FROM Faculty
    WHERE deptid <> @notdept;  -- Exclude the department identified by @notdept

    -- Insert the new faculty member into the Faculty table with the calculated salary
    INSERT INTO Faculty (fid, fname, deptid, salary)
    VALUES (@fid, @fname, @deptid, @avg_salary); -- Use calculated salary for insertion
END;
GO

-- Procedure 3: Select and return all faculty members
CREATE PROCEDURE SelectAllFaculty
AS
BEGIN
    -- Select and display all records from the Faculty table
    SELECT *
    FROM Faculty;
END;
GO


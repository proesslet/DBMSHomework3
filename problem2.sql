DROP PROCEDURE IF EXISTS InsertFacultyByDept;
GO

DROP PROCEDURE IF EXISTS InsertFacultyWhereNotDept;
GO

DROP PROCEDURE IF EXISTS SelectAllFaculty;
GO

-- Procedure 1
CREATE PROCEDURE InsertFacultyByDept
    @fid INT,
    @fname VARCHAR(250),
    @deptid INT
AS
BEGIN
    DECLARE @avg_salary DECIMAL(10, 2);
    DECLARE @new_salary DECIMAL(10, 2);

    -- Calculate the average salary for the department
    SELECT @avg_salary = AVG(salary)
      FROM Faculty
     WHERE deptid = @deptid;

    -- Calculate the new salary according to the logic
    SET @new_salary = CASE
        WHEN @avg_salary > 50000 THEN @avg_salary * 0.9
        WHEN @avg_salary < 30000 THEN @avg_salary
        ELSE @avg_salary * 0.8  -- Adjusted to 80% for averages between 30,000 and 50,000
    END;

    -- Insert the new faculty member
    INSERT INTO Faculty (fid, fname, deptid, salary)
         VALUES (@fid, @fname, @deptid, @new_salary);
END;
GO

-- Procedure 2
CREATE PROCEDURE InsertFacultyWhereNotDept
    @fid INTEGER,
    @fname VARCHAR(250),
    @deptid INTEGER,
    @notdept INTEGER
AS
BEGIN
    DECLARE @avg_salary DECIMAL(10, 2);

    SELECT @avg_salary = AVG(salary)
      FROM Faculty
     WHERE deptid <> @notdept;

    -- Insert the new faculty member
    INSERT INTO Faculty (fid, fname, deptid, salary)
         VALUES (@fid, @fname, @deptid, @avg_salary);
END;
GO

CREATE PROCEDURE SelectAllFaculty
AS
BEGIN
    SELECT *
      FROM Faculty;
END;
GO

EXEC SelectAllFaculty
GO
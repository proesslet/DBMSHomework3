/* insert the fid, fname, deptid, and salary of a new faculty member into table Faculty. The salary is
computed based on the average faculty salary of his/her department (if the average faculty salary
is greater than $50,000 then the salary of the new faculty member will be equal to 90% of the
average faculty salary; if the average faculty salary is less than $30,000, then the salary of the new
faculty member will be equal to the average faculty salary; otherwise, the salary of the new faculty
member will be equal to 80% of the average faculty salary).*/

INSERT INTO Faculty (fid, fname, deptid, salary)
SELECT 11, 'Jeff', 4,
CASE
    WHEN avg_salary > 50000 THEN avg_salary * 0.9
    WHEN avg_salary < 30000 THEN avg_salary
    ELSE avg_salary * 0.8
END

FROM
(
    SELECT AVG(salary) AS avg_salary
    FROM Faculty
    WHERE deptid = 1
) AS avg_salary_table;

/* delete the faculty members whose fids are 101, 35000, and 112
from table Faculty.*/
DELETE FROM Faculty
WHERE fid = 100 OR fid = 35000 OR fid = 112 OR fid = 115;


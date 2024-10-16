-- PROBLEM 1
-- GQ1 --------------------------------------------

-- a) Insertion violation uniqueness of primary key
INSERT INTO Student VALUES (1, 'Adams', 'History', 'FR', 18)

-- b) Insertion violation not-null value of primary key
INSERT INTO Student VALUES (null, 'Adams', 'History', 'FR', 18)

-- c) Insertion, deletion, and update query violating foreign key constraint
INSERT INTO Class VALUES ('New Class', 'W 13:30', 'R128', 105)
DELETE FROM Faculty WHERE fid = 104
UPDATE Class SET fid = 105

-- d) Retrieval query violates domain constraint
SELECT snum FROM Student WHERE sname = 16

-- GQ2 --------------------------------------------

-- CREATE INDEX idx_enrolled_snum_cname ON Enrolled (snum, cname);

-- After reviewing the SQL queries, we decided the Enroll table would be a good candidate for indexing. 
-- Specifically, it is used frequently in JOIN operations and accessed in queries 2, 3, 4, 5, 7, and 9.

-- Because cname and snum are frequently used, we can create a composite index on the combination of the 
-- two to optimize performance. This index is a secondary index because neither snum or cname are primary keys, 
-- but foreign keys that reference another table’s primary keys.


-- Query 2
SELECT student.sname
FROM Student student
JOIN Enrolled enrolled ON student.snum = enrolled.snum
JOIN Class class ON enrolled.cname = class.cname
JOIN Faculty faculty ON class.fid = faculty.fid
WHERE student.slevel = 'JR' AND faculty.fname = 'Johnson'
GROUP BY student.sname, student.snum;

-- Query 3
SELECT MAX(student.age) AS oldest_age
FROM Student student
LEFT JOIN Enrolled enrolled ON student.snum = enrolled.snum
LEFT JOIN Class class ON enrolled.cname = class.cname
LEFT JOIN Faculty faculty ON class.fid = faculty.fid
WHERE student.major = 'History' OR faculty.fname = 'Johnson';

-- Query 4
SELECT class.cname FROM Class class
LEFT JOIN Enrolled enrolled ON class.cname = enrolled.cname
GROUP BY class.cname, class.room
HAVING class.room = 'R128' OR COUNT(enrolled.snum) >= 5;

-- Query 5
  SELECT student.sname FROM Student student
    JOIN Enrolled e1 ON student.snum = e1.snum
    JOIN Class c1 ON e1.cname = c1.cname
    JOIN Enrolled e2 ON student.snum = e2.snum
    JOIN Class c2 ON e2.cname = c2.cname
    WHERE c1.meets_at = c2.meets_at AND e1.cname <> e2.cname
    GROUP BY student.sname;

-- Query 7
SELECT f.fname FROM Faculty f
    JOIN Class c ON f.fid = c.fid
    LEFT JOIN Enrolled e ON c.cname = e.cname
    GROUP BY f.fname, f.fid HAVING COUNT(e.snum) < 5;

-- Query 9
DELETE FROM Enrolled
WHERE snum IN (SELECT snum FROM Student WHERE slevel = 'SR');
DELETE FROM Student
WHERE slevel = 'SR';
SELECT * FROM Student;
/* ==========================================================================
   students_db_backup.sql
   CIS 4720 Database Management and SQL

   WHAT THIS FILE IS
   A starter database for in_class_lab7b. It builds a schema called
   students_db holding one table of students, plus a view. The lab PCs are
   wiped every night, so a script like this one is how you get a working
   database back in a few seconds instead of typing it all again. The file
   is the database. The server is disposable.

   WHAT IT BUILDS
     1. A schema called students_db
     2. One table, STUDENT, with six columns and a primary key
     3. Five rows of data
     4. One view, STUDENT_GPA, showing just the names and the grade averages

   BEFORE YOU RUN IT
   The schema has to exist before VS Code can connect to it, and VS Code
   will not create one for you. Step 4 of the lab has you create it at the
   command prompt first. Do that step before you open VS Code.

   HOW TO RUN THIS COMPLETED VERSION
   On a new MySQL database, first build the starter STUDENT table and
   STUDENT_GPA view: remove the leading -- from Sections 2, 3 and 4,
   run those sections once, then comment those sections back out.
   That keeps the one-time statements in the file without rerun errors,
   which is what lab Step 10 asks you to demonstrate. Then run the rest.

   The Chapter 5 practice resets only STUDENT_COPY so you can rerun it.
   The two statements that are EXPECTED TO FAIL in the assignment remain
   commented out. Run each test separately, then comment it back out.
   ========================================================================== */


-- ======================================================================
-- SECTION 1. The schema
-- A schema is the container that holds your tables. CREATE DATABASE makes
-- one, and USE tells the server which one the statements below apply to.
-- ======================================================================

-- Create the schema. IF NOT EXISTS means this line is safe to run twice,
-- and safe to run even though you already made it at the command prompt.
CREATE DATABASE IF NOT EXISTS students_db;

-- Switch into it. Everything below lands inside this schema.
USE students_db;


-- ======================================================================
-- SECTION 2. The table
-- Each column gets a data type that fits what it holds:
--   INT           whole numbers, used here for the id
--   VARCHAR(30)   text up to 30 characters
--   DECIMAL(3,2)  a number with 1 digit before the point and 2 after,
--                 which is exactly the shape of a grade average
--   DATE          a real date, stored as YYYY-MM-DD
-- NOT NULL means the column may never be left empty.
-- PRIMARY KEY means student_id must be unique and may never be empty.
-- ======================================================================

-- CREATE TABLE STUDENT (
--     student_id  INT          NOT NULL,
--     first_name  VARCHAR(30)  NOT NULL,
--     last_name   VARCHAR(30)  NOT NULL,
--     major       VARCHAR(40),
--     gpa         DECIMAL(3,2),
--     enrolled_on DATE,
--     PRIMARY KEY (student_id)
-- );


-- ======================================================================
-- SECTION 3. The data
-- Five students. Two enrolled in the same term, which is useful later when
-- you start filtering on a date.
-- ======================================================================

-- INSERT INTO STUDENT VALUES (1,'Ana',   'Reyes', 'CIS',              3.75,'2025-08-25');
-- INSERT INTO STUDENT VALUES (2,'Marcus','Bell',  'Computer Science', 3.20,'2025-08-25');
-- INSERT INTO STUDENT VALUES (3,'Priya', 'Nair',  'Mathematics',      3.90,'2026-01-12');
-- INSERT INTO STUDENT VALUES (4,'Devon', 'Rao',   'CIS',              2.85,'2026-01-12');
-- INSERT INTO STUDENT VALUES (5,'Elena', 'Vargas','Business',         3.45,'2026-08-24');


-- ======================================================================
-- SECTION 4. The view
-- A view is a stored SELECT statement you can query as if it were a table.
-- This one shows only the names and the grade average, so anyone using it
-- cannot reach the id, the major or the enrollment date.
-- ======================================================================

-- CREATE VIEW STUDENT_GPA AS
-- SELECT first_name, last_name, gpa
-- FROM STUDENT;


-- ======================================================================
-- SECTION 5. Checks
-- These only read. They are safe to run as many times as you like, so
-- leave them switched on even after the first run.
-- ======================================================================

-- All five rows, straight from the table.
SELECT * FROM STUDENT;

-- The view highest grade average first. Three columns not six.
SELECT * FROM STUDENT_GPA ORDER BY gpa DESC;

-- Should come back as 5 students and an average of 3.43.
SELECT COUNT(*) AS students, ROUND(AVG(gpa), 2) AS average_gpa FROM STUDENT;

-- STUDENT is a BASE TABLE and STUDENT_GPA is a VIEW. SHOW TABLES on its
-- own does not tell them apart, which is why this one says FULL.
SHOW FULL TABLES;


-- ######################################################################
-- YOUR LAB7B WORK STARTS BELOW THIS LINE
--
-- Add your Chapter 5 statements under the headings below, in order. Put a
-- comment above every statement saying what it does, in your own words.
-- The comments are graded.
-- ######################################################################


-- STEP 11. Section 5.1, look at your schema

-- This tells me which database the SQL connection is using right now.
SELECT DATABASE() AS my_schema;

-- This list the tables and view, with a column showing which kind each one is.
SHOW FULL TABLES;


-- STEP 12. Section 5.2, look at the data types

-- This shows every STUDENT column, its data type, and any key or NULL rules.
DESCRIBE STUDENT;


-- STEP 13. Section 5.3, create a table by copying with a subquery

-- Remove only my practice copy if it exists, so I can repeat this lab safely.
-- The original STUDENT table and its five rows are never deleted here.
-- DROP TABLE IF EXISTS STUDENT_COPY;

-- This copies four columns and all five students into a separate practice table.
-- CREATE TABLE STUDENT_COPY AS
-- SELECT student_id, first_name, last_name, gpa
-- FROM STUDENT;

-- This checks that the copy has five rows and the four requested columns.
-- SELECT * FROM STUDENT_COPY;

-- This displays the copy's original definition to show it has no primary key yet.
-- SHOW CREATE TABLE STUDENT_COPY;


-- STEP 14. Section 5.4, change the structure of the copy

-- This adds a one character honors field to the end of the copied table.
-- ALTER TABLE STUDENT_COPY ADD COLUMN honors CHAR(1);

-- This lets last names have up to 50 characters while keeping them required.
-- ALTER TABLE STUDENT_COPY MODIFY COLUMN last_name VARCHAR(50) NOT NULL;

-- This makes student_id unique and required again, like in the original table.
-- ALTER TABLE STUDENT_COPY ADD PRIMARY KEY (student_id);

-- This checks the column types and confirms student_id now has the pri key.
DESCRIBE STUDENT_COPY;

-- EXPECTED ERROR TEST: This repeats student_id 1 and should give error 1062.
-- Run ONLY the next line by itself before dropping honors, then comment it again.
-- INSERT INTO STUDENT_COPY VALUES (1,'Duplicate','Row',0.00,NULL);

-- This removes the temporary honors column after testing the new table structure.
-- ALTER TABLE STUDENT_COPY DROP COLUMN honors;


-- STEP 15. Section 5.5, insert, update and delete a row

-- This adds Omar to the copy with a starting GPA of 3.10.
-- INSERT INTO STUDENT_COPY VALUES (6,'Omar','Faruqi',3.10);

-- This shows Omar's new record right after the insert.
SELECT * FROM STUDENT_COPY WHERE student_id = 6;

-- This changes only Omar's GPA from 3.10 to 3.35.
-- UPDATE STUDENT_COPY SET gpa = 3.35 WHERE student_id = 6;

-- This checks that Omars new gpa was saved.
SELECT * FROM STUDENT_COPY WHERE student_id = 6;

-- This removes only Omar's practice record by its student ID.
-- DELETE FROM STUDENT_COPY WHERE student_id = 6;

-- This confirms the copy contains the original five students again.
SELECT COUNT(*) AS rows_left FROM STUDENT_COPY;


-- STEP 16. Section 5.6, create a view and update through it

-- This clears an older copy of the high-GPA view so the lab can be rerun.
-- DROP VIEW IF EXISTS HIGH_GPA;

-- This view only shows students in the copy whose GPA is 3.50 or higher.
-- CREATE VIEW HIGH_GPA AS
-- SELECT student_id, first_name, last_name, gpa
-- FROM STUDENT_COPY
-- WHERE gpa >= 3.50;

-- This displays the qualifying students, highest GPA first.
SELECT * FROM HIGH_GPA ORDER BY gpa DESC;

-- This checks Ana's GPA in the actual copied table before changing it.
SELECT student_id, gpa FROM STUDENT_COPY WHERE student_id = 1;

-- This updates Ana through the view, which also changes the copy.
-- UPDATE HIGH_GPA SET gpa = 3.95 WHERE student_id = 1;

-- This proves Anas GpA in STUDENT_COPY is now 3.95.
SELECT student_id, gpa FROM STUDENT_COPY WHERE student_id = 1;

-- This clears an older summary view to avoid a duplicate error on reruns.
-- DROP VIEW IF EXISTS GPA_SUMMARY;

-- This calculates the number of students and average GPA across the copy.
-- CREATE VIEW GPA_SUMMARY AS
-- SELECT COUNT(*) AS n, ROUND(AVG(gpa), 2) AS avg_gpa
-- FROM STUDENT_COPY;

-- This reads the summary so I can see the student count and average GPA.
SELECT * FROM GPA_SUMMARY;

--Project 7 Portion

CREATE TABLE COURSE (
    course_id INT NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_title VARCHAR(50) NOT NULL,
    credits INT,
    dept VARCHAR(30),
    PRIMARY KEY (course_id)
);


DESCRIBE COURSE;

--Add Rows to COURSE

-- Add the Database Management class to the course list.
INSERT INTO COURSE VALUES
(101, 'CIS4720', 'Database Management and SQL', 3, 'CIS');

-- Add the introductory programming class.
INSERT INTO COURSE VALUES
(102, 'CIS2000', 'Intro to Programming', 3, 'CIS');

-- Include the four credit calculus course.
INSERT INTO COURSE VALUES
(103, 'MATH1600', 'Calculus I', 4, 'Mathematics');

-- Add class from the Business department.
INSERT INTO COURSE VALUES
(104, 'BUS2100', 'Principles of Management', 3, 'Business');

-- Include an adv programming course for later testing.
INSERT INTO COURSE VALUES
(105, 'CIS4850', 'Advanced Python', 3, 'CIS');

-- Display the course records to confirm that all five were saved.
SELECT * FROM COURSE;

--Create Enrollment Table

CREATE TABLE ENROLLMENT (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    term VARCHAR(15),
    grade CHAR(1),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT (student_id),
    FOREIGN KEY (course_id) REFERENCES COURSE (course_id)
);

-- Check the enrollment table's columns and key config.
DESCRIBE ENROLLMENT;


-- Add rows to ENROLLMENT


-- Register student 1 in the database class.
INSERT INTO ENROLLMENT VALUES (1,101,'Fall 2026','A');

-- Register student 1 in introductory programming.
INSERT INTO ENROLLMENT VALUES (1,102,'Fall 2026','B');

-- Record student 1's calculus enrollment.
INSERT INTO ENROLLMENT VALUES (1,103,'Spring 2026','A');

-- Register student 2 in database management.
INSERT INTO ENROLLMENT VALUES (2,101,'Fall 2026','B');

-- Add student 2 to the management class.
INSERT INTO ENROLLMENT VALUES (2,104,'Fall 2026','C');

-- Register student 3 in database management.
INSERT INTO ENROLLMENT VALUES (3,101,'Fall 2026','A');

-- Record student 3's calculus enrollment.
INSERT INTO ENROLLMENT VALUES (3,103,'Spring 2026','A');

-- Register student 4 in introductory programming.
INSERT INTO ENROLLMENT VALUES (4,102,'Fall 2026','C');

-- Count the enrollments to verify that all eight registrations worked.
SELECT COUNT(*) AS enrollment_rows FROM ENROLLMENT;


-- Check that an unknown student cannot be registered in a course.
-- INSERT INTO ENROLLMENT VALUES (99,101,'Fall 2026','A');

-- Check that a student cannot register for a nonexistent class.
-- INSERT INTO ENROLLMENT VALUES (1,999,'Fall 2026','A');

-- Check that the same student cannot register for the same class twice.
-- INSERT INTO ENROLLMENT VALUES (1,101,'Spring 2027','B');




-- Join one, the three table join

-- Combine the student, registration, and class information
-- so the report shows names instead of only ID numbers.
SELECT s.first_name, s.last_name, c.course_code, c.course_title,
       e.term, e.grade
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN COURSE c ON e.course_id = c.course_id
ORDER BY s.last_name, c.course_code;


-- Join two, the outer join


-- Count each student's classes while still showing students
-- who have no registrations.
SELECT s.first_name, s.last_name,
       COUNT(e.course_id) AS courses_taken
FROM STUDENT s
LEFT JOIN ENROLLMENT e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY courses_taken DESC, s.last_name;

-- Find courses that have not received any student registrations.
SELECT c.course_code, c.course_title
FROM COURSE c
LEFT JOIN ENROLLMENT e ON c.course_id = e.course_id
WHERE e.student_id IS NULL;



-- View one, STUDENT_SCHEDULE


-- Save the complete enrollment report so it can be reused
-- without rebuilding the three-table join each time.
CREATE VIEW STUDENT_SCHEDULE AS
SELECT s.first_name, s.last_name, c.course_code, c.course_title,
       e.term, e.grade
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN COURSE c ON e.course_id = c.course_id;

-- Display every enrollment through the saved schedule view.
SELECT * FROM STUDENT_SCHEDULE;

-- Show only the classes taken by the student with the last name Reyes.
SELECT * FROM STUDENT_SCHEDULE
WHERE last_name = 'Reyes';

-- Show the students registered for the database management course.
SELECT * FROM STUDENT_SCHEDULE
WHERE course_code = 'CIS4720';


-- View two, COURSE_HEADCOUNT

-- Store a class enrollment summary that includes courses
-- even when nobody has signed up for them.
CREATE VIEW COURSE_HEADCOUNT AS
SELECT c.course_code, c.course_title,
       COUNT(e.student_id) AS students_enrolled
FROM COURSE c
LEFT JOIN ENROLLMENT e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_title;

-- Display the class enrollment totals with the busiest classes first.
SELECT * FROM COURSE_HEADCOUNT
ORDER BY students_enrolled DESC;

-- Check the database objects to make sure the new tables
-- and views have all been created successfully.
SHOW FULL TABLES;

-- Error Test
-- UPDATE COURSE_HEADCOUNT
-- SET students_enrolled = 99
-- WHERE course_code = 'CIS4720';
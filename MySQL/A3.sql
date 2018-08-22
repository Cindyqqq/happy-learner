-- grades schema

-- Compute what would be a “perfect score” in the course, by adding up the perfect score values for all assignments, quizzes and exams.
SELECT SUM(perfectscore) AS perfect_total FROM assignment

-- Write a query that lists every section’s name, and how many students are in that section.
SELECT sec_name, COUNT(*) AS num_students
FROM section NATURAL JOIN student GROUP BY sec_name


-- Create a view named totalscores, which computes each student’s total score over all assignments in the course. The view’s result should contain each student’s username, and the total score for that student. 
CREATE VIEW totalscores AS
SELECT username, SUM(score) AS total_score 
FROM submission GROUP BY username

--  This course happens to be pass/fail, and a passing grade is a total score of 40 or higher. Using the totalscores view, create a view called passing which lists the usernames and scores of all students that are passing.
CREATE VIEW passing AS
SELECT * FROM totalscores WHERE total_score >= 40


-- Similarly, create a view called failing, which lists the usernames and scores of all students that are failing.
CREATE VIEW failing AS
SELECT * FROM totalscores WHERE total_score < 40

-- Write a SQL query that lists the usernames of all students that failed to submit work for at least one lab assignment, but still managed to pass the course. 

SELECT DISTINCT username 
FROM assignment
NATURAL JOIN submission NATURAL LEFT JOIN fileset NATURAL JOIN passing
WHERE shortname LIKE 'lab%' AND fset_id IS NULL

-- Finally, for kicks, update and rerun this query to show all students that failed to submit either the midterm or the final, yet still managed to pass the course.

SELECT DISTINCT username 
FROM assignment
NATURAL JOIN submission NATURAL LEFT JOIN fileset
WHERE shortname IN ('midterm', 'final') AND fset_id IS NULL AND
username IN (SELECT username FROM passing)



-- Date and times

-- reports the usernames of all students that submitted work for the midterm after the due date.

SELECT DISTINCT username
FROM assignment NATURAL JOIN submission NATURAL JOIN fileset 
WHERE shortname='midterm' AND sub_date > due


-- reports, for each hour in the day, how many lab assignments (assignments whose short-­‐‑names start with 'lab') are submitted in that hour.
SELECT EXTRACT(HOUR FROM sub_date) AS submit_hour, COUNT(*) AS num_submits
FROM assignment NATURAL JOIN submission NATURAL JOIN fileset 
WHERE assignment.shortname LIKE 'lab%'
GROUP BY submit_hour 
ORDER BY submit_hour


-- reports the total number of final exams that were submitted in the 30 minutes before the final exam due date. 
SELECT COUNT(*) AS jit_final
FROM assignment NATURAL JOIN submission NATURAL JOIN fileset 
WHERE shortname='final' AND
sub_date BETWEEN due - INTERVAL 30 MINUTE AND due



-- Schema and Data Migration

-- Add a column named “email” to the student table, which is a VARCHAR(200). When you create the new column, allow NULL values. Populate the new email column by concatenating the student’s username to “@school.edu”.
ALTER TABLE student ADD COLUMN email VARCHAR(200);
UPDATE student SET email = CONCAT(username, '@school.edu');

SELECT * FROM student;
ALTER TABLE student CHANGE COLUMN email email VARCHAR(200) NOT NULL

-- Add a column named “submit_files” to the assignment table, which is a BOOLEAN column. Make the default value true.
ALTER TABLE assignment ADD COLUMN allow_submits BOOLEAN DEFAULT TRUE
-- set all “daily quiz” assignments (assignments whose shortname value starts with “dq”) to have submit_files = FALSE
UPDATE assignment SET allow_submits = FALSE WHERE shortname LIKE 'dq%'


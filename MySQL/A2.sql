-- university

SELECT * FROM course, student, takes, section

-- Find the names of all students who have taken at least one Comp. Sci. course; make sure there are no duplicate names in the result.
SELECT DISTINCT name
FROM student JOIN takes USING (ID)
JOIN course USING (course_id) WHERE course.dept_name = 'Comp. Sci.'

-- For each department, find the maximum salary of instructors in that department. You may assume that every department has at least one instructor.
SELECT* FROM department, instructor

SELECT dept_name, MAX(salary) AS max_salary
FROM instructor 
GROUP BY dept_name

-- For the lowest, across all departments, of the per-department maximum salary computed by the preceding query. You should actually include the query from part c; you can't just pretend it has a name (or use a view, etc.).
SELECT MIN(max_salary) AS lowest_max_salary
FROM (SELECT MAX(salary) AS max_salary
FROM instructor 
GROUP BY dept_name) AS dept_salaries


-- Create a new course “CS-001”, titled “Weekly Seminar”, with 0 credits. The course ID is “CS-001”, which is stored as a string.
INSERT INTO course
VALUES ('CS-001', 'Weekly Seminar', 'Comp. Sci.', ' 0 ')

-- Create a section of this course in Autumn 2009, with sec_id of 1.
INSERT INTO section (course_id, sec_id, semester, year) 
VALUES ('CS-001', 1, 'Autumn', 2009)

-- Enroll every student in the Comp. Sci. department in the above section. Don't forget the INSERT ... SELECT statement.
INSERT INTO takes (ID, course_id, sec_id, semester, year) 
SELECT ID, 'CS-001', 1, 'Autumn', 2009
FROM student WHERE dept_name = 'Comp. Sci.'

-- Delete enrollments in the above section where the student's name is Chavez. You would normally also want to update the student's tot_cred "total credits" value, but since CS-001 is worth 0 credits, just concentrate on removing the appropriate rows from the takes table, and ignore the other part.
DELETE FROM takes
WHERE course_id = 'CS-001' AND sec_id = 1 AND
ID IN (SELECT ID FROM student WHERE name = 'Chavez')

-- Delete the course CS-001. What will happen if you run this delete statement without first deleting offerings (sections) of this course?
DELETE FROM course WHERE course_id = 'CS-001'

-- Delete all takes tuples corresponding to any section of any course with the word "database" as a part of the title; ignore case when matching the word with the title. You might find the LOWER()function helpful.
DELETE FROM takes
WHERE course_id IN (SELECT course_id FROM course WHERE title LIKE '%Database%')







-- library



-- Retrieve the names of members who have borrowed any book published by "McGraw-Hill".
SELECT DISTINCT name
FROM member NATURAL JOIN borrowed NATURAL JOIN book WHERE publisher = 'McGraw-Hill'

-- Retrieve the names of members who have borrowed all books published by "McGraw-Hill".

-- The query to find how many McGraw-­‐‑Hill books there are is:
SELECT COUNT(*) AS num_books FROM book 
WHERE publisher = 'McGraw-Hill'
-- The number of McGraw-­‐‑Hill books each member has borrowed is:
SELECT name, COUNT(*) AS num_books
FROM member NATURAL JOIN borrowed NATURAL JOIN book WHERE publisher = 'McGraw-Hill'
GROUP BY name

-- We can combine these two queries in a couple of ways. For example, a scalar subquery:
SELECT name, COUNT(*) AS num_books
FROM member NATURAL JOIN borrowed NATURAL JOIN book WHERE publisher = 'McGraw-Hill'
GROUP BY name HAVING num_books =
(SELECT COUNT(*) AS num_books FROM book WHERE publisher = 'McGraw-Hill')

-- For each publisher, retrieve the names of members who have borrowed more than five books of that publisher.
SELECT publisher, name, COUNT(*) AS num_borrowed
FROM book NATURAL JOIN borrowed NATURAL JOIN member
GROUP BY publisher, name HAVING COUNT(*)> 5

-- Compute the average number of books borrowed per member. Take into account that if a member does not borrow any books, then that member does not appear in the borrowed relation at all. To be more specific, members who borrow no books should bring down the average, as you would expect, since the number of books they have borrowed is 0.
-- This query computes the number of books each member has borrowed:
SELECT COUNT(isbn)
FROM member NATURAL LEFT JOIN borrowed 
GROUP BY memb_no
-- This query computes the average number of books. Note that we must give the inner query’s result a name, since it is a computed value.
SELECT AVG(num_books) AS avg_num_books FROM (SELECT COUNT(isbn) AS num_books
FROM member NATURAL LEFT JOIN borrowed GROUP BY memb_no) AS memb_counts





-- banking

-- Retrieve the loan-numbers and amounts of loans with amounts of at least $1000, and at most $2000.
SELECT loan_number, amount
FROM loan 
WHERE amount BETWEEN 1000 AND 2000

-- Retrieve the loan-number and amount of all loans owned by Smith. Order the results by increasing loan number.
SELECT loan_number, amount 
FROM loan NATURAL JOIN borrower 
WHERE customer_name ='Smith'
ORDER BY loan_number


-- Retrieve the city of the branch where account A-446 is open
SELECT branch_city
FROM branch NATURAL JOIN account
WHERE account_number = 'A-446'

-- Retrieve the customer name, account number, branch name, and balance, of accounts owned by customers whose names start with “J”. Order the results by increasing customer name.
SELECT customer_name, account_number, branch_name, balance 
FROM depositor NATURAL JOIN account
WHERE customer_name LIKE 'J%'
ORDER BY customer_name

-- Retrieve the names of all customers with more than five bank accounts.
SELECT customer_name FROM depositor
GROUP BY customer_name HAVING COUNT(*) > 5



-- A view called pownal_customers containing the account numbers and customer names (but not the balances) for all accounts at the Pownal branch.
CREATE VIEW pownal_customers AS
SELECT account_number, customer_name FROM depositor NATURAL JOIN account WHERE branch_name='Pownal'

-- OR  this one is updateable!
CREATE VIEW pownal_customers AS
SELECT account_number, customer_name FROM depositor
WHERE account_number IN (SELECT account_number FROM account WHERE branch_name='Pownal')



-- A view called onlyacct_customers containing the name, street, and city of all customers who have an account with the bank, but do not have a loan. This view can be defined such that it is updatable; for full points you must make sure that it is.
CREATE VIEW onlyacct_customers AS
SELECT customer_name, customer_street, customer_city FROM customer 
WHERE customer_name IN (SELECT customer_name FROM depositor) AND customer_name NOT IN (SELECT customer_name FROM borrower)


-- A view called branch_deposits that lists all branches in the bank, along with the total account balance of each branch, and the average account balance of each branch. Make sure all computed values are given reasonable names in the view.
CREATE VIEW branch_deposits AS 
SELECT branch_name, IFNULL(SUM(balance), 0) AS total_balance, AVG(balance) AS avg_balance 
FROM branch NATURAL LEFT JOIN account 
GROUP BY branch_name


-- Generate a list of all cities that customers live in, where there is no bank branch in that city. Make sure that the results are distinct; no city should appear twice. Also, sort the cities in increasing alphabetical order.
SELECT DISTINCT customer_city
FROM customer
WHERE customer_city NOT IN (SELECT branch_city FROM branch) 
ORDER BY customer_city

-- Are there any customers who have neither an account nor a loan? Write a SQL query that reports the name of any customers that have neither an account nor a loan. 

SELECT customer_name FROM customer
WHERE customer_name NOT IN (SELECT customer_name FROM depositor) AND
customer_name NOT IN (SELECT customer_name FROM borrower)


-- The bank decides to promote its branches located in the city of Horseneck, so it wants to make a $50 gift-deposit into all accounts held at branches in the city of Horseneck. Write the SQL UPDATE command for performing this operation.
UPDATE account SET balance = balance + 50
WHERE branch_name IN (SELECT branch_name FROM branch WHERE branch_city='Horseneck')

-- OR
UPDATE account NATURAL JOIN branch SET balance = balance + 50
WHERE branch_city = 'Horseneck'

-- Retrieve all details (account_number, branch_name, balance) for the largest account at each branch. Implement this query as a join against a derived relation in the FROM clause.
SELECT account.*
FROM account NATURAL JOIN
(SELECT branch_name, MAX(balance) AS balance FROM account GROUP BY branch_name) AS maxes

-- OR
SELECT * FROM account
WHERE (branch_name, balance) IN (SELECT branch_name, MAX(balance) FROM account GROUP BY branch_name)


-- RANK PROBLEM 
-- Compute the rank of all bank branches, based on the amount of assets that each branch holds. The result schema should be (branch_name, assets, rank), where the rank value is the rank of the branch. Order the results by decreasing rank, and secondarily by branch name (ascending), in case there are ties.

SELECT b1.branch_name, b1.assets,1 + COUNT(b2.branch_name) AS ranks
FROM branch AS b1 LEFT JOIN branch AS b2 ON (b1.assets < b2.assets)
GROUP BY b1.branch_name, b1.assets 
ORDER BY ranks

-- OR
SELECT branch_name, assets, (SELECT 1 + COUNT(*) FROM branch AS b2 WHERE b2.assets > b1.assets) AS ranks
FROM branch AS b1
ORDER BY ranks
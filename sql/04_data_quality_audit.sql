-- 04 - Data Quality Audit

-- Find for duplicate records
SELECT 
COUNT(*) AS total_records,
COUNT(DISTINCT name, author, narrator, time, released_date, language, stars, price) AS dup_reccords,
COUNT(*) - COUNT(DISTINCT name, author, narrator, time, released_date, language, stars, price) AS count 
FROM raw_audible_books; -- There are no duplicate records

-- Find the datatype of each column data
DESCRIBE raw_audible_books;

-- Check if all the are in proper formats
SELECT COUNT(released_date)
FROM raw_audible_books
WHERE released_date LIKE '%-%';

-- Checking if the dates are in proper format dd-mm-yy
SELECT COUNT(released_date)
FROM raw_audible_books
WHERE released_date LIKE '__-__-__';

-- Checking the data in stars
SELECT stars
FROM raw_audible_books
LIMIT 100;

-- Checking the count of book which have not been rated 'Not Rated Yet'
SELECT COUNT(*)
FROM raw_audible_books
WHERE stars = 'Not rated yet'; -- We can use <>, NOT IN, != 

-- Check whether the rating format is same for all
SELECT COUNT(*)
FROM raw_audible_books
WHERE stars LIKE '%out%';

SELECT price
FROM raw_audible_books
LIMIT 100;

-- Finding if there are some other data rather than amount
SELECT price
FROM raw_audible_books
WHERE price NOT LIKE '%.00%';

-- finding values which contain (,)
SELECT COUNT(*)
FROM raw_audible_books
WHERE price LIKE '%,%';

-- finding total free books
SELECT COUNT(*)
FROM raw_audible_books
WHERE price = 'Free';
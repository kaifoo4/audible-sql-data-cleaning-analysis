# 07 - Validation

-- Checking whether the clean table has 87489 rows
SELECT COUNT(*)
FROM audible_books_clean;

-- Checking the count of columns in clean table
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'audible_books_clean';

-- Checking random data, from the clean table
SELECT *
FROM audible_books_clean
LIMIT 100;

-- Verify that stars_rating contains NULL for unrated books.
SELECT SUM(stars_rating IS NULL) AS total_nulls, 
COUNT(stars_rating) AS total_non_nulls
FROM audible_books_clean;

-- verify that price contains NULL for Free books. 
SELECT SUM(price IS NULL) AS total_free_books
FROM audible_books_clean;
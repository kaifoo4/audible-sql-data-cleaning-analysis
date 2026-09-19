# 06 - Creating clean table

-- Creating clean table
CREATE TABLE audible_books_clean AS
SELECT 
name, 
author, 
narrator, 
(COALESCE(CAST(REGEXP_SUBSTR(time, '[0-9]+(?= hr)') AS UNSIGNED), 0)) * 60
+
COALESCE(CAST(REGEXP_SUBSTR(time, '[0-9]+(?= min)') AS UNSIGNED), 0) AS time_in_minutes,
STR_TO_DATE(released_date, '%d-%m-%y') AS book_released_date,
language,
CASE
	WHEN stars = 'Not rated yet' THEN NULL ELSE CAST(SUBSTRING_INDEX(stars, ' ', 1)AS DECIMAL(2,1))
END AS stars_rating,
CAST(REGEXP_SUBSTR(stars, '[0-9]+(?= rating)') AS UNSIGNED) AS total_ratings_per_book,
CAST(CASE
	WHEN price != 'Free' THEN REPLACE(price, ',', '') ELSE NULL 
END AS DECIMAL(10,2)) AS price
FROM raw_audible_books;

-- Checking if the table creation is perfect or not
SELECT *
FROM audible_books_clean
LIMIT 100;

DESCRIBE audible_books_clean;
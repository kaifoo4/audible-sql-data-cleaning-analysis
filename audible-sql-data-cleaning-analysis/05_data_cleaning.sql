# 05 - Data Cleaning

-- viewing top 100 records 
SELECT time 
FROM raw_audible_books
LIMIT 100;

-- My query to convert the time into proper minutes.
WITH CTE1 AS (
	SELECT 
	CASE
		WHEN time LIKE '%hr%' THEN SUBSTRING(time, 1,2) ELSE 0 
	END AS hours,
	CASE
		WHEN time LIKE '%min%' THEN SUBSTRING(time, -7) ELSE 0
	END AS mins
    FROM raw_audible_books
),
CTE2 AS (
	SELECT TRIM(hours*60) AS total_hours,
    TRIM(REPLACE(REPLACE(REPLACE(REPLACE(mins, 'd', ''), 'mins', ''), 'min', ''), '', 0)) AS total_mins
    FROM CTE1
)
SELECT total_hours + total_mins AS total_minuts
FROM CTE2;

-- Proper Method to convert it to minutes. (By chatgpt)
SELECT
    time,
    (
        COALESCE(
            CAST(REGEXP_SUBSTR(time, '[0-9]+(?= hr)') AS UNSIGNED),
            0
        ) * 60
    )
    +
    COALESCE(
        CAST(REGEXP_SUBSTR(time, '[0-9]+(?= min)') AS UNSIGNED),
        0
    ) AS total_minutes
FROM raw_audible_books; 

-- Same as above
SELECT  
(COALESCE(CAST(REGEXP_SUBSTR(time, '[0-9]+(?= hr)') AS UNSIGNED), 0) * 60)
+
COALESCE(CAST(REGEXP_SUBSTR(time, '[0-9]+(?= min)') AS UNSIGNED), 0) AS total_minutes
FROM raw_audible_books;

-- Viewing the release dates
SELECT released_date
FROM raw_audible_books
LIMIT 100;

-- retriving the dates in proper DATE format yyyy-mm-dd (Method 1)
SELECT DATE(released_date) AS released_date_in_proper_format
FROM raw_audible_books;

              -- Method 2
      
SELECT STR_TO_DATE(released_Date, '%d-%m-%Y')
FROM raw_audible_books;

-- viewing start (ratings)
SELECT stars
FROM raw_audible_books
LIMIT 100;

-- Extracting star rating and total ratings received into 2 different columns
SELECT 
REGEXP_SUBSTR(stars, '[0.0-5.0]+(?= out)') AS stars_out_of_5,
REGEXP_SUBSTR(stars, '[0-9]+(?= rating)') AS totla_ratings
FROM raw_audible_books;
             
             -- More better way

SELECT 
REGEXP_SUBSTR(stars, '[0-9]+(\.[0-9]+)?(?= out)') AS stars_out_of_5,
REGEXP_SUBSTR(stars, '[0-9]+(?= rating)') AS totla_ratings
FROM raw_audible_books;

-- Viewing price
SELECT price
FROM raw_audible_books
LIMIT 100;

-- making the prices proper for analysis by removing , and converting the string to decimal and also replcing Free with NULL
SELECT CASE
	WHEN price != 'Free' THEN CAST(REPLACE(price, ',', '') AS DECIMAL(10, 2)) ELSE NULL
    END AS price
FROM raw_audible_books;

-- checking if there is any whitespace in name
WITH CTE1 AS (
	SELECT LENGTH(name) AS actual_length,
	LENGTH(TRIM(name)) AS length_after_trim
	FROM raw_audible_books
)
SELECT actual_length, length_after_trim
FROM CTE1
WHERE actual_length != length_after_trim; -- No whitespace

-- Check if there's any whitespace in author, narrator and language
SELECT 
LENGTH(author) AS actual_length,
LENGTH(TRIM(author)) AS length_after_trim
FROM raw_audible_books
WHERE LENGTH(author) != LENGTH(TRIM(author)); -- No whitespace

SELECT
LENGTH(narrator) AS actual_length,
LENGTH(TRIM(narrator)) AS length_after_trim
FROM raw_audible_books
WHERE LENGTH(narrator) != LENGTH(TRIM(narrator)); -- No whitespace

SELECT
LENGTH(language) AS actual_length,
LENGTH(TRIM(language)) AS length_after_trim
FROM raw_audible_books
WHERE LENGTH(language) != LENGTH(TRIM(language)); -- No whitespace

-- number of languages and their count
WITH CTE1 AS (
	SELECT DISTINCT LOWER(language) AS uniq_lang
	FROM raw_audible_books
	ORDER BY LOWER(language)
)
SELECT uniq_lang, COUNT(uniq_lang) OVER() AS count
FROM CTE1;

-- find if there is case sensitive name
WITH CTE1 AS (
	SELECT DISTINCT name AS uniq_name, LOWER(name) AS uniq_name_with_lower
	FROM raw_audible_books
)
SELECT uniq_name, COUNT(uniq_name) OVER(), uniq_name_with_lower, COUNT(uniq_name_with_lower) OVER()
FROM CTE1;

             -- other way
             
SELECT COUNT(DISTINCT name), COUNT(DISTINCT LOWER(name))
FROM raw_audible_books;

-- find if there is case sensitive name for author and narrator
SELECT COUNT(DISTINCT author), COUNT(DISTINCT LOWER(author))
FROM raw_audible_books;

SELECT COUNT(DISTINCT narrator), COUNT(DISTINCT LOWER(narrator))
FROM raw_audible_books;

-- Checking if there is any nagative ratings
WITH CTE1 AS (
SELECT 
	REGEXP_SUBSTR(stars, '[0-9]+(\.[0-9]+)?(?= out)') AS stars_out_of_5,
	REGEXP_SUBSTR(stars, '[0-9]+(?= rating)') AS totla_ratings
	FROM raw_audible_books
)
SELECT stars_out_of_5, totla_ratings
FROM CTE1 
WHERE stars_out_of_5 <= 0 
OR stars_out_of_5 > 5 
OR totla_ratings <= 0;

-- Checking if there is any negative value in the price
WITH CTE1 AS (
SELECT 
CASE
	WHEN price != 'Free' THEN CAST(REPLACE(price, ',', '') AS DECIMAL(10, 2)) ELSE NULL
END AS price
FROM raw_audible_books
)
SELECT price
FROM CTE1
WHERE price <= 0;

WITH CTE1 AS (
	SELECT
		time,
		(
			COALESCE(
				CAST(REGEXP_SUBSTR(time, '[0-9]+(?= hr)') AS UNSIGNED),
				0
			) * 60
		)
		+
		COALESCE(
			CAST(REGEXP_SUBSTR(time, '[0-9]+(?= min)') AS UNSIGNED),
			0
		) AS total_minutes
	FROM raw_audible_books
)
SELECT total_minutes
FROM CTE1
WHERE total_minutes <= 0;

-- Fianl tranformed dataset
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

-- ---------------------
-- Fianl Data Validation
-- ----------------------

-- checking if there are still 87489 rows
WITH final_table AS (
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
	FROM raw_audible_books
)
SELECT COUNT(*)
FROM final_table; 

-- Checking if there are unexpected nulls
WITH final_table AS (
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
	FROM raw_audible_books
)
SELECT 
SUM(name IS NULL) AS name_null_check, -- This method is supported in mysql ans bigsql "Does not supported in PostgreSQL, SQL Server, ORacle"
COUNT(CASE WHEN author IS NULL THEN 1 END) AS author_null_check, -- This mentod is used in SQL Server / Standard SQL
SUM(CASE WHEN author IS NULL THEN 1 ELSE 0 END) AS narrator_null_check, -- Same as above metod, hust using sum(case)
SUM(time_in_minutes IS NULL) AS time_in_min_null_check,
SUM(book_released_date IS NULL) AS release_date_null_check,
SUM(language IS NULL) AS language_null_check,
SUM(stars_rating IS NULL) AS star_rat_null_check,
SUM(total_ratings_per_book IS NULL) AS total_ratings_null_check,
SUM(price IS NULL) AS price_null_check
FROM final_table; 

-- checking if the time_in_minutes does not contain any unexpected value 
WITH final_table AS (
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
	FROM raw_audible_books
)
SELECT COUNT(time_in_minutes), SUM(time_in_minutes <= 0), MAX(time_in_minutes)
FROM final_table;

-- checking if the released dates contain any unexpected value 
WITH final_table AS (
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
	FROM raw_audible_books
)
SELECT COUNT(book_released_date), SUM(book_released_date IS NULL), MIN(book_released_date), MAX(book_released_date)
FROM final_table;

-- checking if the released dates contain any unexpected value 
WITH final_table AS (
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
	FROM raw_audible_books
)
SELECT 
COUNT(*) AS total_rows,
COUNT(stars_rating) AS total_rated_books,
SUM(stars_rating IS NULL) AS total_nulls_in_stars,
MIN(stars_rating),
MAX(stars_rating),
COUNT(total_ratings_per_book) AS total_ratings,
SUM(total_ratings_per_book IS NULL) AS totla_null_ratings,
MIN(total_ratings_per_book),
MAX(total_ratings_per_book)
FROM final_table;

-- checking if the price contain any unexpected value 
WITH final_table AS (
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
	FROM raw_audible_books
)
SELECT 
COUNT(price) AS total_non_nulls,
SUM(price IS NULL) AS total_nulls_free, 
MIN(price),
MAX(price),
SUM(price <= 0)
FROM final_table;
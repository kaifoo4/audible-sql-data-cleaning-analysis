-- 04 - Data Quality Audit

-- Checking if there are any NULL's 
SELECT
SUM(name IS NULL) AS total_nulls_in_name,
SUM(author IS NULL) AS total_nulls_in_author,
SUM(narrator IS NULL) AS total_nulls_in_narratoe,
SUM(time IS NULL) AS total_nulls_in_time,
SUM(released_Date IS NULL) AS total_nulls_in_released_date,
SUM(language IS NULL) AS total_nulls_in_language,
SUM(stars IS NULL) AS total_nulls_in_stars,
SUM(price IS NULL) AS total_nulls_in_price
FROM raw_audible_books; -- There are no null values

-- Check if the data is empty 
SELECT
SUM(TRIM(name) = '') AS empty_name,
SUM(TRIM(author) = '') AS empty_author,
SUM(TRIM(narrator) = '') AS empty_narrator,
SUM(TRIM(time) = '') AS empty_time,
SUM(TRIM(released_date) = '') AS empty_released_date,
SUM(TRIM(language) = '') AS empty_values,
SUM(TRIM(stars) = '') AS empty_stars,
SUM(TRIM(price) = '') AS empty_price
FROM raw_audible_books;  -- No empry or blank data

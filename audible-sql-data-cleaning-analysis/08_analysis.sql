# 08 - Analysis

-- 1. Dataset overview
-- What is the overall size and basic composition of the Audible dataset?

SELECT 
COUNT(*) AS total_books,
COUNT(DISTINCT name) AS total_distinct_titles,
COUNT(DISTINCT author) AS total_unique_authors,
COUNT(DISTINCT narrator) AS total_unique_narrators,
COUNT(price) AS total_paid_books,
SUM(price IS NULL) AS total_free_books,
COUNT(stars_rating) AS total_rated_books,
AVG(time_in_minutes) AS average_book_duration_in_minutes,
AVG(price) AS average_price_of_paid_books
FROM audible_books_clean;

-- 2. Language Analysis
-- How is the Audible catalog distributed across languages?

-- 2.1. Language-level overview
-- How is the entire catalog distributed across languages?
SELECT 
language,
COUNT(*) AS total_books_in_each_language,
ROUND(AVG(stars_rating), 1) AS average_rating,
SUM(total_ratings_per_book) AS total_ratings_received,
ROUND(AVG(price), 2) AS average_pricing,
ROUND(AVG(time_in_minutes), 2) AS average_time_duration_in_minutes,
ROUND(COUNT(*) / (SELECT COUNT(*) FROM audible_books_clean) * 100, 2) AS percentage_of_total_books
FROM audible_books_clean
GROUP BY language
ORDER BY percentage_of_total_books DESC;

-- 2.2. Language Engagement & Performance
-- Among languages with more than 1,000 books, which show the highest audience engagement
-- and how do their ratings, pricing, and book duration compare?
-- Include languages with either a substantial catalog size
-- or more than 1,000 total ratings received.
SELECT 
language,
COUNT(*) AS total_books_in_each_language,
ROUND(COUNT(*) / (SELECT COUNT(*) FROM audible_books_clean) * 100, 2) AS percentage_of_total_books,
ROUND(AVG(stars_rating), 1) AS average_rating,
SUM(total_ratings_per_book) AS total_ratings_received,
ROUND(SUM(total_ratings_per_book) / COUNT(*), 4) AS average_ratings_received_per_book,
ROUND(AVG(price), 2) AS average_pricing,
ROUND(AVG(time_in_minutes), 2) AS average_time_duration_in_minutes
FROM audible_books_clean
GROUP BY language
HAVING COUNT(*) > 1000 OR SUM(total_ratings_per_book) > 1000;

-- 2.3. Audience Engagement
-- Which languages receive the most audience ratings per book?
-- Include languages with either more than 500 books
-- or more than 500 total ratings.
SELECT 
language,
COUNT(*) AS total_books_in_each_language,
ROUND(COUNT(*) / (SELECT COUNT(*) FROM audible_books_clean) * 100, 2) AS percentage_of_total_books,
ROUND(AVG(stars_rating), 1) AS average_rating,
SUM(total_ratings_per_book) AS total_ratings_received,
ROUND(SUM(total_ratings_per_book) / COUNT(*), 4) AS average_ratings_received_per_book
FROM audible_books_clean
GROUP BY language
HAVING COUNT(*) > 500 OR SUM(total_ratings_per_book) > 500
ORDER BY average_ratings_received_per_book DESC;

-- 3. Author Analysis

-- 3.1. Author Catalog Contribution
-- Which authors have the largest number of books in the Audible catalog?
SELECT 
author,
COUNT(*) AS total_books_written,
COUNT(*) / (SELECT COUNT(*) FROM audible_books_clean) * 100 AS percentage_of_total_catalog
FROM audible_books_clean
GROUP BY author
ORDER BY total_books_written DESC
LIMIT 10;

-- 3.2. Author Performance
-- Which authors have the largest audience engagement in the Audible catalog?
SELECT 
author,
COUNT(*) AS total_books_written,
ROUND(SUM(total_ratings_per_book), 2) AS total_ratings_recived,
ROUND(AVG(stars_rating), 1) AS avg_stars,
ROUND(SUM(total_ratings_per_book) / COUNT(*), 2) AS avg_ratings_recived_per_book
FROM audible_books_clean
GROUP BY author
HAVING COUNT(*) >= 5
ORDER BY avg_rating_recived_per_book DESC
LIMIT 5;

-- 3.3. uthor Rating vs Audience Engagement
-- Do authors with higher audience engagement also tend to have higher average ratings?
SELECT 
author,
COUNT(*) AS total_books_written,
SUM(total_ratings_per_book) AS total_ratings_received,
ROUND(AVG(stars_rating), 1) AS avg_stars,
ROUND(SUM(total_ratings_per_book) / COUNT(*), 2) AS avg_ratings_received_per_book
FROM audible_books_clean
GROUP BY author
HAVING COUNT(*) >= 5
ORDER BY avg_stars DESC
LIMIT 10;

-- 4. Narrator Analysis

-- 4.1. Narrator Catalog Contribution
-- Which narrators have the largest number of books in the Audible catalog?
SELECT 
narrator,
COUNT(*) total_books_narrated,
COUNT(*) / (SELECT COUNT(*) FROM audible_books_clean) * 100 AS share
FROM audible_books_clean
GROUP BY narrator
ORDER BY total_books_narrated DESC
LIMIT 10;

-- 4.2. Narrator Audience Engagement
-- Which narrators have the highest audience engagement per book?
SELECT 
narrator,
COUNT(*) AS total_books_narrated,
SUM(total_ratings_per_book) / COUNT(*) AS avg_ratings_recived,
AVG(stars_rating) AS avg_stars
FROM audible_books_clean
GROUP BY narrator
HAVING COUNT(*) >= 5
ORDER BY avg_ratings_recived DESC
LIMIT 10; 

-- 4.3. Narrator Rating vs Audience Engagement
-- Do narrators with higher audience engagement also have higher average star ratings?
SELECT 
narrator,
COUNT(*) AS total_books_narrated,
SUM(total_ratings_per_book) AS total_rating_received,
SUM(total_ratings_per_book) / COUNT(*) AS avg_ratings_received,
ROUND(AVG(stars_rating), 2) AS avg_stars
FROM audible_books_clean
GROUP BY narrator
HAVING COUNT(*) >= 5
ORDER BY avg_stars DESC
LIMIT 10;

-- 5. Rating Analysis

-- 5.1. Rating Distribution
-- How are Audible books distributed across different star-rating levels?
SELECT 
stars_rating,
COUNT(*) AS total_books,
COUNT(*) / (SELECT COUNT(*) FROM audible_books_clean WHERE stars_rating IS NOT NULL) * 100 AS total_percentage_hold
FROM audible_books_clean
WHERE stars_rating IS NOT NULL
GROUP BY stars_rating
ORDER BY stars_rating DESC;

-- 5.2. Rating vs Audience Engagement
-- Do books with higher star ratings also tend to receive more audience ratings?
SELECT 
stars_rating,
COUNT(*) AS total_books,
SUM(total_ratings_per_book) / COUNT(*) AS average_ratings_received_per_book,
COUNT(*) / (SELECT COUNT(*) FROM audible_books_clean WHERE stars_rating IS NOT NULL) * 100 AS total_percentage_hold
FROM audible_books_clean
WHERE stars_rating IS NOT NULL
GROUP BY stars_rating
ORDER BY stars_rating DESC;

-- 6. Pricing Analysis

-- 6.1. Pricing Analysis
-- How are Audible books distributed across different price ranges?
SELECT 
COUNT(CASE WHEN price <= 100 THEN 1 END) AS under_100,
COUNT(CASE WHEN price > 100 AND price <= 300 THEN 1 END) AS price_rane_100_to_300,
COUNT(CASE WHEN price > 300 AND price <= 500 THEN 1 END) AS price_rane_300_to_500,
COUNT(CASE WHEN price > 500 AND price <= 1000 THEN 1 END) AS price_rane_500_to_1000,
COUNT(CASE WHEN price > 1000 AND price <= 2000 THEN 1 END) AS price_rane_1000_to_2000,
COUNT(CASE WHEN price > 2000 THEN 1 END) AS price_rane_more_than_2000,
SUM(price IS NULL) AS total_free_books
FROM audible_books_clean;

        -- Method 2

WITH CTE1 AS (
	SELECT 
	price,
	total_ratings_per_book,
	stars_rating,
	CASE
		WHEN price <= 99 THEN '<= 99'
		WHEN price >= 100 AND price <= 299 THEN '100-299'
		WHEN price >= 300 AND price <= 499 THEN '300-499'
		WHEN price >= 500 AND price <= 999 THEN '500-999'
		WHEN price >= 1000 AND price <= 1999 THEN '1000-1999'
		WHEN price >= 2000 THEN 'More than 2000'
        WHEN price IS NULL THEN 'Free book'
	END AS price_range
	FROM audible_books_clean
)
SELECT price_range,
COUNT(*) AS total_books,
COUNT(*) / (SELECT COUNT(*) FROM audible_books_clean) * 100 AS percentage_share
FROM CTE1
GROUP BY price_range
ORDER BY percentage_share DESC;

-- 6.2. Price vs Audience Engagement
-- Do books in different price ranges receive different levels of audience engagement?
WITH CTE1 AS (
	SELECT 
	price,
	total_ratings_per_book,
	stars_rating,
	CASE
		WHEN price <= 99 THEN '<= 99'
		WHEN price >= 100 AND price <= 299 THEN '100-299'
		WHEN price >= 300 AND price <= 499 THEN '300-499'
		WHEN price >= 500 AND price <= 999 THEN '500-999'
		WHEN price >= 1000 AND price <= 1999 THEN '1000-1999'
		WHEN price >= 2000 THEN 'More than 2000'
	END AS price_range
	FROM audible_books_clean
    WHERE price IS NOT NULL
)
SELECT price_range,
COUNT(*) AS total_books,
ROUND(AVG(stars_rating), 1) AS avg_stars,
ROUND(SUM(total_ratings_per_book) / COUNT(*), 2) AS avg_rating_per_book
FROM CTE1
GROUP BY price_range
ORDER BY price_range;

-- 7. Book Duration Analysis

-- 7.1. Book Duration Analysis
-- How does book duration relate to audience engagement and ratings?
WITH CTE1 AS (
	SELECT
	time_in_minutes,
	stars_rating,
    language,
	total_ratings_per_book,
	CASE
		WHEN time_in_minutes <= 120 THEN 'less than 120 min (Under 2 hours)'
		WHEN time_in_minutes > 120 AND time_in_minutes <= 300 THEN '120-300 min (2-5 hours)'
		WHEN time_in_minutes > 300 AND time_in_minutes <= 600 THEN '300-600 min (5-10 hours)'
		WHEN time_in_minutes > 600 AND time_in_minutes <= 1200 THEN '600-1200 min (10-20 hours)'
		WHEN time_in_minutes >1200 THEN '> 1200 min (20+ hours)'
	END AS time_range
	FROM audible_books_clean
)
SELECT time_range,
COUNT(*) AS total_books,

ROUND(AVG(stars_rating), 2) AS avg_stars,
SUM(total_ratings_per_book) / COUNT(*) AS average_ratings_received_per_book
FROM CTE1
GROUP BY time_range
ORDER BY average_ratings_received_per_book DESC;

-- 8. Release Date Analysis

-- 8.1. Release Date Analysis: Catalog Growth Over Time
-- How has the Audible catalog grown over the years, 
-- and how do books released in different years compare in ratings and pricing?
SELECT 
YEAR(book_released_date) AS released_year,
COUNT(*) AS total_books_Released,
ROUND(AVG(stars_rating), 1) AS avg_stars,
ROUND(AVG(price), 2) AS avg_price
FROM audible_books_clean
GROUP BY YEAR(book_released_date)
ORDER BY released_year;
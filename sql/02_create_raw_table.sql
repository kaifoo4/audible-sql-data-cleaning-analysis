# 02 - Creating a table in the database and loading row data

CREATE TABLE raw_audible_books (
name VARCHAR(500),
author VARCHAR(255),
narrator VARCHAR(255),
time VARCHAR(100),
released_date VARCHAR(100),
language VARCHAR(100),
stars VARCHAR(100),
price VARCHAR(50)
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/Desktop/audible_uncleaned.csv' -- file path
INTO TABLE raw_audible_books
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT COUNT(*) FROM raw_audible_books;

SELECT * 
FROM raw_audible_books 
LIMIT 100;

DESCRIBE raw_audible_books;
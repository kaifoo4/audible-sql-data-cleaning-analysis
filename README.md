# Audible Books — SQL Data Cleaning & Analysis

## Project Overview

This project focuses on cleaning, validating, and analyzing an Audible audiobook dataset using SQL and MySQL.

The original dataset contains **87,489 audiobook records** with information such as book name, author, narrator, duration, release date, language, ratings, and price.

The project follows a complete data analysis workflow, starting with raw data profiling and data quality checks, followed by data cleaning, validation, and SQL-based analysis to identify useful patterns and insights.

---

## Objectives

The main objectives of this project are:

* Understand the structure and quality of the raw dataset.
* Identify missing, duplicate, and inconsistent data.
* Clean and transform raw text-based columns into analysis-ready formats.
* Create a validated clean dataset.
* Analyze books by language, author, narrator, rating, price, duration, and release year.
* Extract meaningful business insights from the cleaned data.
* Practice SQL concepts in a real-world data cleaning and analysis workflow.

---

## Tools & Technologies

* **MySQL**
* **MySQL Workbench**
* **SQL**
* **Git & GitHub**

---

## Dataset

The dataset used in this project was obtained from Kaggle.

**Source:** [Audible Dataset — Kaggle](https://www.kaggle.com/datasets/snehangsude/audible-dataset)

The dataset contains Audible audiobook information including:

| Column          | Description                      |
| --------------- | -------------------------------- |
| `name`          | Name of the audiobook            |
| `author`        | Author of the book               |
| `narrator`      | Narrator of the audiobook        |
| `time`          | Original audiobook duration      |
| `released_date` | Original release date            |
| `language`      | Language of the audiobook        |
| `stars`         | Original rating and rating count |
| `price`         | Original audiobook price         |

The original dataset is **not included in this repository**. The SQL scripts in this project were developed and executed using the complete dataset.

---

## Project Workflow

The project follows this workflow:

```text
Raw Data
    ↓
Data Profiling
    ↓
Data Quality Audit
    ↓
Data Cleaning
    ↓
Clean Dataset
    ↓
Validation
    ↓
SQL Analysis
    ↓
Business Insights
```

---

## Data Cleaning

The raw dataset was initially imported into MySQL with the columns stored as text values.

The following cleaning and transformation tasks were performed:

### 1. Data Quality Checks

Checked for:

* NULL values
* Empty and whitespace-only values
* Duplicate records
* Inconsistent formatting
* Invalid numeric values
* Invalid dates
* Unrated books
* Free books

### 2. Audiobook Duration

The original `time` column contained values such as:

```text
2 hrs and 20 mins
13 hrs and 8 mins
10 hrs
```

These values were converted into a numeric `time_in_minutes` column to make duration analysis easier.

### 3. Release Date

The original `released_date` values were stored as text in `DD-MM-YY` format.

They were converted into a proper SQL `DATE` column named:

```text
book_released_date
```

### 4. Ratings

The original `stars` column contained both the star rating and number of ratings in the same field.

For example:

```text
5 out of 5 stars34 ratings
```

This was separated into:

* `stars_rating`
* `total_ratings_per_book`

Books marked as `Not rated yet` were represented as `NULL` in the rating column rather than treating them as zero-star books.

### 5. Price

The original `price` column contained numeric values as text as well as:

```text
Free
```

The values were converted into a numeric `DECIMAL` column.

Free books were represented as `NULL` so that they would not incorrectly affect paid-book price calculations.

---

## Clean Dataset Structure

After cleaning, the dataset contains the following columns:

| Column                   | Description                   |
| ------------------------ | ----------------------------- |
| `name`                   | Audiobook name                |
| `author`                 | Author                        |
| `narrator`               | Narrator                      |
| `time_in_minutes`        | Audiobook duration in minutes |
| `book_released_date`     | Release date as a proper DATE |
| `language`               | Audiobook language            |
| `stars_rating`           | Numeric star rating           |
| `total_ratings_per_book` | Number of ratings received    |
| `price`                  | Numeric audiobook price       |

The cleaned dataset is stored in the MySQL table:

```text
audible_books_clean
```

---

## Data Validation

After creating the cleaned table, validation checks were performed to make sure the transformation did not introduce incorrect or missing data.

The validation included:

* Comparing row counts with the original dataset.
* Checking the cleaned table structure.
* Checking NULL values in expected columns.
* Checking rating ranges.
* Checking price values.
* Checking audiobook duration values.
* Reviewing sample records.
* Confirming that the cleaned table contained all **87,489 records**.

---

## SQL Analysis

After completing the cleaning and validation process, the cleaned dataset was analyzed across several areas.

### 1. Dataset Overview

Analyzed:

* Total number of books
* Distinct book titles
* Unique authors
* Unique narrators
* Paid books
* Free books
* Rated books
* Average book duration
* Average paid-book price

### 2. Language Analysis

Analyzed:

* Number of books by language
* Percentage of the total catalog
* Average rating
* Total ratings received
* Average ratings received per book
* Average price
* Average duration

### 3. Author Analysis

Analyzed:

* Authors with the highest number of books
* Author catalog contribution
* Audience engagement by author
* Average rating by author
* Author pricing patterns

### 4. Narrator Analysis

Analyzed:

* Narrators with the highest number of books
* Audience engagement by narrator
* Average ratings by narrator
* Rating activity compared with the number of books narrated

### 5. Rating Analysis

Analyzed:

* Distribution of star ratings
* Percentage of books at each rating level
* Average ratings received per book for different star ratings

### 6. Pricing Analysis

Analyzed:

* Distribution of paid books across price ranges
* Average rating by price range
* Average ratings received per book by price range

### 7. Book Duration Analysis

Analyzed:

* Distribution of books by duration
* Average rating by duration range
* Average ratings received per book by duration range

### 8. Release Date Analysis

Analyzed:

* Number of books released by year
* Average rating by release year
* Average price by release year

---

## Key Findings

Some of the main findings from the analysis were:

* The dataset contains **87,489 audiobook records**.
* English-language books make up around **71% of the catalog**, followed by German at around **9.5%**.
* Hindi books showed the highest average audience engagement at around **21 ratings per book**, followed by Tamil at around **15 ratings per book**. However, these languages have much smaller catalogs than English, so the results should be interpreted carefully.
* Among books with ratings, around **72% had a rating of 4.5 stars or higher**, while around **90% had a rating of 4.0 stars or higher**.
* Around **48% of paid books** were priced between 500 and 999.
* Books priced at 2,000 or more had the highest average ratings received per book at approximately **11**, but this category contained only 117 books.
* Longer audiobooks generally received more ratings per book than shorter audiobooks.
* **2021 had the highest number of book releases**, with 23,541 records in the dataset.

These findings describe patterns observed in this dataset and should not automatically be interpreted as causal relationships.

---

## Project Structure

```text
audible-sql-data-cleaning-analysis/
│
├── README.md
│
├── data/
│   └── README.md
│
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_raw_table.sql
│   ├── 03_data_profiling.sql
│   ├── 04_data_quality_audit.sql
│   ├── 05_data_cleaning.sql
│   ├── 06_create_clean_table.sql
│   ├── 07_validation.sql
│   └── 08_analysis.sql
│
└── screenshots/
    ├── data_profiling.png
    ├── data_cleaning.png
    ├── validation.png
    └── analysis_results.png
```

---

## SQL Workflow

The SQL files are organized in the order in which the project was completed:

| File                        | Purpose                                      |
| --------------------------- | -------------------------------------------- |
| `01_create_database.sql`    | Creates the project database                 |
| `02_create_raw_table.sql`   | Creates the raw data table                   |
| `03_data_profiling.sql`     | Profiles the raw dataset                     |
| `04_data_quality_audit.sql` | Checks data quality issues                   |
| `05_data_cleaning.sql`      | Performs data cleaning and transformation    |
| `06_create_clean_table.sql` | Creates the final cleaned table              |
| `07_validation.sql`         | Validates the cleaned dataset                |
| `08_analysis.sql`           | Performs SQL analysis and generates insights |

---

## SQL Concepts Used

This project helped me apply several SQL concepts in a practical project, including:

* `SELECT` and filtering
* `GROUP BY` and `HAVING`
* Aggregate functions
* Conditional aggregation
* `CASE`
* String functions
* Date functions
* Regular expressions
* Type conversion using `CAST`
* `COALESCE`
* Subqueries
* Common Table Expressions (CTEs)
* Data validation
* Data cleaning and transformation
* Analytical SQL

---

## What I Learned

Through this project, I practiced how to work with a real-world dataset rather than only working with small practice tables.

Some of the main things I learned were:

* How to profile a dataset before cleaning it.
* How to identify different types of data quality issues.
* How to convert messy text values into useful analytical columns.
* How to validate cleaned data before using it for analysis.
* How to choose meaningful metrics for analysis.
* How to use SQL to find patterns in a dataset.
* How to distinguish between a pattern shown by the data and a possible explanation for that pattern.

---

## Conclusion

This project represents a complete SQL data cleaning and analysis workflow, from importing raw data to producing validated data and extracting insights.

It was created as part of my Data Analyst learning journey to gain practical experience working with real-world datasets and applying SQL beyond basic querying.

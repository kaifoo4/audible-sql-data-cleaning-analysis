# Audible Books — SQL Data Cleaning & Analysis

A complete SQL data cleaning and analysis project using an Audible audiobook dataset containing **87,489 records**.

The project focuses on taking raw, inconsistent data, cleaning and transforming it using MySQL, validating the results, and finally performing business-oriented analysis to find useful patterns and insights.

## 📌 Project Overview

Raw datasets often contain inconsistent formats, text-based numbers, missing values, and other data quality issues that need to be handled before analysis.

In this project, I used **MySQL** to:

* Profile the raw dataset
* Audit data quality
* Identify missing and duplicate records
* Clean and transform inconsistent columns
* Convert text-based values into appropriate data types
* Create a separate cleaned dataset
* Validate the cleaned data
* Perform SQL-based business analysis
* Extract meaningful insights from the data

The goal was not only to practice SQL syntax, but to follow a complete **data analyst workflow from raw data to insights**.

---

## 🛠️ Tools & Technologies

* **MySQL**
* **MySQL Workbench**
* **SQL**
* Git & GitHub

### SQL concepts used

* SELECT, WHERE, ORDER BY
* GROUP BY & HAVING
* Aggregate functions
* CASE expressions
* JOINs
* Subqueries
* CTEs
* String functions
* Date functions
* Regular expressions
* Conditional aggregation
* Data type conversion
* Data validation
* Business-oriented analysis

---

## 📂 Project Structure

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
   
```

---

## Dataset

The dataset used in this project was obtained from Kaggle.

**Source:** [Audible Dataset — Kaggle](https://www.kaggle.com/datasets/snehangsude/audible-dataset)

The dataset contains Audible audiobook information such as book name, author, narrator, duration, release date, language, ratings, and price.

The original dataset is **not included in this repository**. The SQL scripts were developed and executed using the complete dataset.

---

# 🔍 Data Cleaning

The raw data contained several columns that required transformation before analysis.

### Duration

The original `time` column contained values such as:

```text
2 hrs and 20 mins
13 hrs and 8 mins
10 hrs
```

These values were converted into a numerical `time_in_minutes` column.

### Release Date

The original release dates were stored as text in `DD-MM-YY` format.

They were converted into a proper SQL `DATE` column:

```text
book_released_date
```

### Ratings

The original `stars` column contained values such as:

```text
5 out of 5 stars34 ratings
4.5 out of 5 stars41 ratings
Not rated yet
```

The information was separated into:

* `stars_rating`
* `total_ratings_per_book`

Books marked as `Not rated yet` were represented as `NULL` for the star rating.

### Price

The original `price` column contained values such as:

```text
103.00
1,007.95
Free
```

The values were converted into a numeric `DECIMAL` column.

Books marked as `Free` were represented as `NULL` in the cleaned price column.

---

# 🧹 Data Quality Checks

The following checks were performed before creating the final cleaned table:

* NULL value check
* Empty string / whitespace check
* Duplicate record check
* Date validation
* Duration validation
* Rating validation
* Rating-count validation
* Price validation
* Data type validation
* Text formatting checks
* Row-count validation

The raw table was kept unchanged, while all transformations were applied when creating the cleaned dataset.

---

# 📈 Analysis

After cleaning and validating the data, I performed analysis across several areas.

### 1. Dataset Overview

Examined:

* Total books
* Distinct titles
* Unique authors and narrators
* Paid and free books
* Rated and unrated books
* Average book duration
* Average paid-book price

### 2. Language Analysis

Analyzed:

* Number of books by language
* Share of the total catalog
* Average rating
* Total ratings received
* Average ratings received per book
* Average price
* Average duration

### 3. Author Analysis

Analyzed:

* Authors with the largest catalog contribution
* Audience engagement per book
* Average star ratings
* Author pricing patterns

### 4. Narrator Analysis

Analyzed:

* Narrators with the largest number of books
* Audience engagement per book
* Relationship between audience engagement and star ratings

### 5. Rating Analysis

Analyzed:

* Distribution of star ratings
* Percentage of books at each rating level
* Average audience engagement at different rating levels

### 6. Pricing Analysis

Analyzed:

* Distribution of books across price ranges
* Average star ratings by price range
* Average ratings received per book by price range

### 7. Book Duration Analysis

Analyzed:

* Book duration categories
* Average star ratings
* Average ratings received per book

### 8. Release Date Analysis

Analyzed:

* Number of books released each year
* Average ratings by release year
* Average prices by release year
* Changes in catalog size over time

---

# 💡 Key Findings

Some of the major findings from the analysis were:

* The dataset contains **87,489 books**.
* English books dominate the catalog, accounting for approximately **71%** of all books.
* Hindi books had the highest average audience engagement among the languages included in the language-engagement analysis, with approximately **21 ratings per book**.
* Among rated books, approximately **72% had a rating of 4.5 stars or higher**.
* The **500–999** price range contained the largest number of paid books.
* Books priced at **2,000+** had the highest average ratings received per book, at approximately **11 ratings per book**, although this category contained relatively few books.
* Longer books generally received more ratings per book than shorter books.
* **2021** had the highest number of recorded book releases, with **23,541 books**.

These findings describe patterns observed in the dataset and do not necessarily represent causal relationships.

---

# 📁 SQL Workflow

The project follows a step-by-step SQL workflow:

### `01_create_database.sql`

Creates the project database.

### `02_create_raw_table.sql`

Creates the raw table used to store the original dataset.

### `03_data_profiling.sql`

Performs an initial exploration of the raw data, including:

* Row counts
* Column structure
* Distinct values
* Basic data inspection

### `04_data_quality_audit.sql`

Checks the raw dataset for:

* NULL values
* Empty values
* Duplicates
* Formatting issues
* Invalid values

### `05_data_cleaning.sql`

Contains the transformations used to clean and standardize the raw data.

### `06_create_clean_table.sql`

Creates the final cleaned table:

```text
audible_books_clean
```

### `07_validation.sql`

Validates the cleaned dataset to make sure the transformations did not introduce data quality problems.

### `08_analysis.sql`

Contains the final business-oriented analysis and SQL queries used to generate the project insights.

---

# 🎯 Project Objective

The main objective of this project was to practice and demonstrate a complete SQL-based data analyst workflow:

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

This project helped me move beyond writing individual SQL queries and practice working with data as a complete analysis workflow.

---

## 👤 About

This project was created as part of my **Data Analyst learning and portfolio development**, with a focus on building practical SQL and data analysis skills.

**Skills demonstrated:**
SQL • MySQL • Data Cleaning • Data Validation • Data Analysis • Business Insights

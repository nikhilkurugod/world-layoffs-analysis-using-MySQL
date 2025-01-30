# World-layoffs-analysis-using-MySQL

# 1. Project Overview
Objective: Cleaning, standardizing, and analyzing layoff data to extract meaningful insights.
Dataset: Layoff data containing company, location, industry, layoffs count, percentages, and funding details.
Tools Used: MySQL

# 2. Steps Followed1. Data Cleaning & Preprocessing
Removing Duplicates.

Created a staging table (layoffs_staging2) and used ROW_NUMBER() to remove duplicates.

Standardizing Data

Trimmed extra spaces in company names.

Standardized industry names (e.g., "Crypto" variations).

Fixed country naming inconsistencies (e.g., "United States." → "United States").

Converted date column from text to proper DATE format.

Handling NULL Values

Replaced empty values with NULL.

Filled missing industry values using data from the same company.

Removed rows where both total_laid_off and percentage_laid_off were NULL.

Removing Unnecessary Columns

Dropped the row_num column after deduplication.

2. Exploratory Data Analysis (EDA)
Layoff Trends

Companies with the highest layoffs.

Industries most affected.

Layoffs by country and date range.

Time-Based Analysis

Yearly, monthly layoffs trends.

Rolling totals to track cumulative layoffs over time.

Company & Industry-Specific Insights

Top 5 companies with highest layoffs per year.

Layoffs at different startup stages.

6. SQL Queries Used
   
Data Cleaning (DELETE, UPDATE, ALTER TABLE)

CTEs for deduplication and ranking (WITH CTE AS (...))

Aggregations (SUM(), MAX(), MIN(), AVG())

Window Functions (ROW_NUMBER(), DENSE_RANK(), SUM() OVER())

8. Insights & Key Findings
   
Identify which industries and companies were most affected.
Observe layoffs trends over different time periods.
Understand the impact of funding and company stages on layoffs.

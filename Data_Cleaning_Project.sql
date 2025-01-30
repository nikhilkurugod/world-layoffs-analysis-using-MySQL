SELECT * FROM layoffs;

-- 1) Remove Duplicates
-- 2) Standardise the Data
-- 3) Null values
-- 4) Remove any columns

-- step 1 make a dummy copy of layoffs;
DROP TABLE IF EXISTS layoffs_stagging;
CREATE TABLE layoffs_staging
LIKE layoffs;

-- viewing the layoffs_stagging
SELECT * FROM layoffs_staging;

-- Inserting values in layoffs_staging
INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- Viewing now with inserted values
SELECT * FROM layoffs_staging;

-- creating CTE
WITH duplicate_cte AS(
SELECT * ,
ROW_NUMBER() OVER (PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
-- problem is we cannot delete from cte's
DELETE FROM duplicate_cte 
WHERE row_num > 1;

-- So creating another table
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT * ,
ROW_NUMBER() OVER (PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Seeing row_num > 1
SELECT * FROM layoffs_staging2
WHERE row_num>1;

-- Deleting row_num > 1
DELETE FROM layoffs_staging2
WHERE row_num>1;

-- Step 1 is done REmoving Duplicates.

-- Step 2

-- Company we should trim them
SELECT company,TRIM(company)
FROM layoffs_staging2;

-- Update them
UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT(industry)
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- To update Crypto as they have different name in industry column
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Checking country column
SELECT DISTINCT(country)
FROM layoffs_staging2
ORDER BY country DESC;

-- UPDATING United states
UPDATE layoffs_staging2
SET country = "United States"
WHERE country = "United States.";

-- Update date to date format as it is in text
SELECT `date` , str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

-- To verify the date column
SELECT `date` FROM layoffs_staging2;

-- Converting date column text to date datatype
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- STEP 3 REMOVING NULLS OR FILLING THEM
SELECT * FROM layoffs_staging2
WHERE company LIKE 'Airbnb';

-- Replacing all blank with null values
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT * FROM layoffs_staging2
WHERE company LIKE 'Airbnb';

SELECT * FROM layoffs_staging2 AS t1
INNER JOIN layoffs_staging2 AS t2
ON t1.company=t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 AS t1
INNER JOIN layoffs_staging2 AS t2
ON t1.company=t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Above query solved null places for industry with companies having not null's in other row

-- BELOW QUERY TO REMOVE ROWS WITH total_laid_off and percentage_laid_off = NULL
SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off is NULL;

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off is NULL;

SELECT * FROM layoffs_staging2;

-- Dropping row_num
ALTER TABLE layoffs_staging2
DROP COLUMN row_num




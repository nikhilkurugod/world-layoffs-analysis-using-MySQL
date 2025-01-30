-- EXPLORATORY DATA ANALYSIS

SELECT * FROM layoffs_staging2;

-- layoffs
SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Company layoffs
SELECT company, SUM(total_laid_off) as tot_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;

-- Industry layoffs
SELECT industry, SUM(total_laid_off) as tot_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

-- Date ranges
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- COUNTRY LAYOFFS
SELECT country, SUM(total_laid_off) as tot_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

-- layoffs by date
SELECT `date`, SUM(total_laid_off) as tot_laid_off
FROM layoffs_staging2
GROUP BY `date`
ORDER BY SUM(total_laid_off) DESC;

-- layoffs in the year
SELECT YEAR(`date`), SUM(total_laid_off) as tot_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;

-- STAGE LAYOFFS
SELECT stage, SUM(total_laid_off) as tot_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY SUM(total_laid_off) DESC;

-- Rolling total

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) as laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_cte AS(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, laid_off, SUM(laid_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_cte;

-- Rolling total for company over the years
SELECT company, YEAR(`date`),SUM(total_laid_off) as tot_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;

WITH Company_year (company,years, total_laid_off) AS(
SELECT company, YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC
),
-- ANOTHER CTE TO GET OVERALL RANKING in THE YEAR
Company_year_rank AS(
SELECT *, 
DENSE_RANK() OVER(partition by years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL
)

SELECT * FROM Company_year_rank
WHERE Ranking <=5;



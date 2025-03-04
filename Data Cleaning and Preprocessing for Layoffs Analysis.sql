-- Data Cleaning Process

-- Step 1: Create a backup table to work with
SELECT * FROM layoffs;
CREATE TABLE layoffs_staging1 LIKE layoffs;
INSERT layoffs_staging1 SELECT * FROM layoffs;

-- Step 2: View the copied data
SELECT * FROM layoffs_staging1;

-- Step 3: Identify duplicate records based on company, industry, total_laid_off, and date
SELECT company, industry, total_laid_off, `date`,
    ROW_NUMBER() OVER (
        PARTITION BY company, industry, total_laid_off, `date`
    ) AS row_num
FROM layoffs_staging1;

-- Step 4: Fetch duplicates with row numbers greater than 1
SELECT *
FROM (
    SELECT company, industry, total_laid_off, `date`,
        ROW_NUMBER() OVER (
            PARTITION BY company, industry, total_laid_off, `date`
        ) AS row_num
    FROM layoffs_staging1
) duplicates
WHERE row_num > 1;

-- Step 5: Identify duplicates based on all relevant columns
SELECT *
FROM (
    SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
        ) AS row_num
    FROM layoffs_staging1
) duplicates
WHERE row_num > 1;

-- Step 6: Delete duplicate records
WITH DELETE_CTE AS 
(
    SELECT *
    FROM (
        SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
            ROW_NUMBER() OVER (
                PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
            ) AS row_num
        FROM layoffs_staging1
    ) duplicates
    WHERE row_num > 1
)
DELETE FROM DELETE_CTE;

-- Step 7: Create a refined table for further cleaning
CREATE TABLE `layoffs_staging2` (
    `company` VARCHAR(255),
    `location` VARCHAR(255),
    `industry` VARCHAR(255),
    `total_laid_off` INT DEFAULT NULL,
    `percentage_laid_off` VARCHAR(50),
    `date` VARCHAR(50),  -- Consider changing to DATE or DATETIME if applicable
    `stage` VARCHAR(255),
    `country` VARCHAR(255),
    `funds_raised_millions` INT DEFAULT NULL,
    `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Step 8: Insert data into the new staging table with row numbers for deduplication
INSERT INTO layoffs_staging2 (
    company, location, industry, total_laid_off, percentage_laid_off, `date`, 
    stage, country, funds_raised_millions, row_num
)
SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, 
       stage, country, funds_raised_millions,
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, 
           percentage_laid_off, `date`, stage, country, funds_raised_millions
       ) AS row_num
FROM layoffs_staging1;

-- Step 9: Remove duplicates by deleting rows with row_num > 1
SET SQL_SAFE_UPDATES = 0;
DELETE FROM layoffs_staging2 WHERE row_num > 1;
SET SQL_SAFE_UPDATES = 1;

-- Step 10: Standardizing company names by trimming whitespace
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging2 SET company = TRIM(company);
SET SQL_SAFE_UPDATES = 1;

-- Step 11: Standardizing industry names (e.g., merging similar names like "Crypto" and "Crypto currency")
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging2 SET industry = 'Crypto' WHERE industry LIKE 'Crypto%';
SET SQL_SAFE_UPDATES = 1;

-- Step 12: Cleaning country names by removing trailing dots
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging2 
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';
SET SQL_SAFE_UPDATES = 1;

-- Step 13: Converting `date` column from text format to DATE format
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y') FROM layoffs_staging2;

SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging2 SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE layoffs_staging2 MODIFY COLUMN `date` DATE;

-- Step 14: Removing records where both `total_laid_off` and `percentage_laid_off` are NULL
SET SQL_SAFE_UPDATES = 0;
DELETE FROM layoffs_staging2 
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
SET SQL_SAFE_UPDATES = 1;

-- Step 15: Standardizing missing industry values by filling them from duplicate company records
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;
SET SQL_SAFE_UPDATES = 1;

-- Step 16: Final cleanup - removing the row_num column as it's no longer needed
ALTER TABLE layoffs_staging2 DROP COLUMN row_num;

-- Step 17: Final check of cleaned data
SELECT * FROM layoffs_staging2;

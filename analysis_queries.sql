-- Data Cleaning

SELECT *
FROM layoffs;

-- Remove Duplicates

WITH duplicate_cte AS 
(
	SELECT * , ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
    FROM layoffs
)
SELECT * 
FROM duplicate_cte
WHERE row_num >1;

CREATE TABLE `staging_layoffs` (
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

SELECT *
FROM staging_layoffs;

INSERT INTO staging_layoffs
SELECT * , ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs ;

SELECT *
FROM staging_layoffs
WHERE row_num>1;

DELETE
FROM staging_layoffs
WHERE row_num>1;

SELECT *
FROM staging_layoffs;

-- Standardizing Data

SELECT *
FROM staging_layoffs;

SELECT company
FROM staging_layoffs;

UPDATE staging_layoffs
SET company= TRIM(company);

SELECT DISTINCT industry
FROM staging_layoffs
ORDER BY 1;

UPDATE staging_layoffs
SET industry='Crypto Currency'
WHERE industry LIKE 'Crypto%';

SELECT `date`, str_to_date(`date`,'%m/%d/%Y')
FROM staging_layoffs;

UPDATE staging_layoffs
SET `date`=str_to_date(`date`,'%m/%d/%Y');

SELECT DISTINCT country
FROM staging_layoffs
ORDER BY 1;

UPDATE staging_layoffs
SET country='United States'
WHERE country='United States.';

ALTER TABLE staging_layoffs
MODIFY COLUMN `date` DATE;

-- Remove The Nulls & Blank values

SELECT *
FROM staging_layoffs
WHERE industry IS NULL;

SELECT *
FROM staging_layoffs
WHERE company='Juul';

UPDATE staging_layoffs
SET industry =NULL 
WHERE industry='';

SELECT s1.industry,s2.industry
FROM staging_layoffs AS s1
JOIN staging_layoffs AS s2
	ON s1.company=s2.company
WHERE s1.industry IS NULL AND s2.industry IS NOT NULL;

UPDATE staging_layoffs AS s1
JOIN staging_layoffs AS s2
	ON s1.company=s2.company
    AND s1.location=s2.location
SET s1.industry=s2.industry
WHERE s1.industry IS NULL AND s2.industry IS NOT NULL;


SELECT *
FROM staging_layoffs
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;


DELETE
FROM staging_layoffs
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT *
FROM staging_layoffs;

ALTER TABLE staging_layoffs
DROP COLUMN row_num;

SELECT *
FROM staging_layoffs;

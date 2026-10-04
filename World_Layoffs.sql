-- Data Cleaning



Select*
from layoffs;

-- PROJECT 1

-- 1. Remove duplicates
-- 2. standarize data
-- 3. Null values or blank values
-- 4. Remove any columns



Create Table Layoffs_staging
like layoffs;


Select*
from Layoffs_staging;

insert layoffs_staging

Select*
from Layoffs;


select *,
row_number() over(
partition by company, industry,total_laid_off, percentage_laid_off, `date`) As row_num
From layoffs_staging;


with duplicate_cte as
(
select *,
row_number() over(
partition by company,location, industry,total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) As row_num
From layoffs_staging
)
select *
from duplicate_cte
where row_num>1;

Select*
from Layoffs_staging
where company = 'Casper';


with duplicate_cte as
(
select *,
row_number() over(
partition by company,location, industry,total_laid_off, percentage_laid_off, `date`,
 stage, country, funds_raised_millions) As row_num
From layoffs_staging
)
Delete
from duplicate_cte
where row_num>1;

select *
from layoffs;


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



Select *
from layoffs_staging2
where row_num > 1;

Insert into layoffs_staging2
select *,
row_number() over(
partition by company,location, industry,total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) As row_num
From layoffs_staging;


Delete
from layoffs_staging2
where row_num>1;

select *
From layoffs_staging2;

select *
from layoffs_staging2
where company;


-- Standardizing Data

Select company, trim(company)
From layoffs_staging2
where length(company) <> length(Trim(company));

Select company, trim(company)
from layoffs_staging2;



Update layoffs_staging2
Set company = Trim(company);


Select Distinct industry
From layoffs_staging2;


Update layoffs_staging2
Set industry = 'Crypto'
where industry like 'Crypto%';


Select distinct country, TRIM(Trailing '.' from country)
From layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

Select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

Select `date`
from layoffs_staging2;

Update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

Alter table layoffs_staging2
modify column `date` date;

Select *
from layoffs_staging2
where total_laid_off is Null
and percentage_laid_off is null;

update layoffs_staging2
set industry = null
where industry = '';

Select *
from layoffs_staging2
where industry is null
or industry = '' ;

Select *
from layoffs_staging2
where company = 'Ballys%';

select  t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
  on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
  on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;


Select *
From layoffs_staging2;

Select *
from layoffs_staging2
where total_laid_off is Null
and percentage_laid_off is null;

Delete
from layoffs_staging2
where total_laid_off is Null
and percentage_laid_off is null;


Select *
From layoffs_staging2;

alter table layoffs_staging2
drop column row_num;



-- Exploratory data analysis

Select *
From layoffs_staging2;


Select max(total_laid_off), max(percentage_laid_off)
From layoffs_staging2;


Select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;


Select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;


select min(`date`),max(`date`)
from layoffs_staging2;


Select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;


Select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

Select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;


Select company, avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select substring(`date`,1,7) As `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7)is not null
group by `month`
order by 1 asc;

with rolling_total as
(
select substring(`date`,1,7) As `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7)is not null
group by `month`
order by 1 asc
)
select `month`, total_off  
,sum(total_off) over (order by `month`) as rolling_total
from rolling_total;


Select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

Select company,year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;


with company_Year (company, years, total_laid_off) as
(
Select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), company_year_rank as
(
select *, Dense_rank() over 
(partition by years order by total_laid_off desc) as Ranking
from company_year
where years is not null
)
select *
from company_year_rank
where Ranking <= 5
;

Select *
from layoffs_staging2;

select count(*)
from layoffs_staging2;
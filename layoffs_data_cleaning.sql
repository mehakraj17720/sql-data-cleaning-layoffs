#- - -DATA CLEANING - - -

RENAME TABLE `layoffs (1)` TO layoffs;
select *
from layoffs;
# 1 - - REMOVE DUPLICATES
# 2 - - STANDARDIZE THE DATA
# 3 - - NULL VALUES OR BLANK COLUMN
# 4 - - REMOVE ANY COLUMNS

#CREATING A DUPLIACATE TABLE TO DO ALL CHANGES THERE

create table layoffs_staging
like layoffs;
insert layoffs_staging
select* from layoffs;
select * from 
layoffs_staging;


# -- REMOVING DUPLICATES

WITH CTE_TABLE AS (
select  *,
row_number() OVER (partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging)
delete
 from CTE_TABLE
where row_num > 1;

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
select* from layoffs_staging2 
;
insert into layoffs_staging2
select  *,
row_number() OVER (partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging
;
delete
from layoffs_staging2
where row_num > 1
;
select *
from layoffs_staging2
where row_num > 1
;
select *
from layoffs_staging2;

# --STANADARDIZING DATA-fixing issues in your data
select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select  distinct industry
from layoffs_staging2
order by industry;

select industry 
from layoffs_staging2 
where industry like 'crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'crypto%';

select  distinct country from layoffs_staging2
order by country;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

select `date` from layoffs_staging2;
select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;


#REMOVING NULLS AND BLANKS
select * from layoffs_staging2
where industry is NULL or industry ='';

select * from layoffs_staging2
where company = 'Airbnb';

update  layoffs_staging2
set industry = null
where industry='' ;

select t1.industry,t2.industry
from layoffs_staging2  t1
join layoffs_staging2  t2
  on t1.company=t2.company  
where (t1.industry is null or t1.industry = '')
and t2.industry is not null ;

update layoffs_staging2 t1
join layoffs_staging2  t2
  on t1.company=t2.company  
set t1.industry =t2.industry
where t1.industry is null 
and t2.industry is not null ;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;
 
alter table layoffs_staging2
drop column row_num;

select * from layoffs_staging2









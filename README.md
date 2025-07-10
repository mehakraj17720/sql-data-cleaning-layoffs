# 🧹 SQL Data Cleaning Project – Layoffs Dataset

This project showcases how I cleaned a messy real-world dataset using **MySQL**.

---

## 📊 About the Dataset
The dataset contains information about tech layoffs (company name, industry, location, dates, funds raised, etc.).  
The raw data had many issues like:
- Duplicates
- Inconsistent formatting
- NULLs and blank values
- Incorrect date formats

---

## 🔧 Key SQL Skills Used
- CTEs (`ROW_NUMBER()`) for duplicate removal
- `TRIM()` and `LIKE` for standardizing text
- `STR_TO_DATE()` for fixing date format
- `UPDATE ... JOIN` for filling NULLs based on other rows
- Dropping unnecessary columns

---

## 📁 Project Files
- `layoffs_data_cleaning.sql`: Full SQL script
- Sample queries:
```sql
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;


-- Vytvoření primární tabulky pro projekt SQL.
-- Spojení průměrných mezd a cen základní potravin - mléko, chleba.
CREATE TABLE t_tereza_zdrahalova_project_sql_primary_final AS 
WITH wages AS (									
	SELECT													                -- Příprava mzdových tabulek.
		payroll_year,
		industry_branch_code,
		AVG(value) AS avg_wage
	FROM czechia_payroll 
	WHERE value_type_code = 5958							      			-- Průměrná hrubá mzda na zaměstnance.
		AND calculation_code = 200							     			-- Přepočet.
		AND payroll_year BETWEEN 2006 AND 2018								-- Filtr roků, kde mají mzdy i ceny společná data.
	GROUP BY payroll_year, industry_branch_code
),
prices AS (
	SELECT													                -- Příprava cenových dat. 
		EXTRACT (YEAR FROM date_from) AS price_year,
		avg (CASE WHEN category_code = 114201 THEN value END) AS milk_price,
		avg (CASE WHEN category_code = 111301 THEN value END) AS bread_price
	FROM czechia_price 
	WHERE category_code IN (114201, 111301)
		AND region_code IS NULL 							       		 	-- Celorepublikový průměr.
		AND EXTRACT (YEAR FROM date_from) BETWEEN 2006 AND 2018
	GROUP BY price_year
)
	SELECT 													                -- Spojení mezd a cen do jedné tabulky.
		wages.payroll_year,
		wages.industry_branch_code,
		ibranch.name AS industry_name,
		wages.avg_wage,
		prices.milk_price,
		prices.bread_price
	FROM wages 
	JOIN prices ON wages.payroll_year = prices.price_year
	JOIN czechia_payroll_industry_branch AS ibranch ON wages.industry_branch_code = ibranch.code
	WHERE wages.industry_branch_code IS NOT NULL;							-- Vyřazení prázdného záznamu.
	

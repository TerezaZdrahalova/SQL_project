-- Vytvoření primární tabulky pro projekt SQL.
-- Spojení průměrných mezd podle odvětví a celkové průměrné ceny potravin.

CREATE TABLE t_tereza_zdrahalova_project_sql_primary_final AS 
WITH wages AS (									
	SELECT													-- příprava mzdových tabulek
		payroll_year,
		industry_branch_code,
		AVG(value) AS avg_wage
	FROM czechia_payroll 
	WHERE value_type_code = 5958							-- průměrná hrubá mzda na zaměstnance
		AND calculation_code = 200							-- přepočet
		AND payroll_year BETWEEN 2006 AND 2018				-- filtr roků, kde mají mzdy i ceny společná data
	GROUP BY payroll_year, industry_branch_code
),
prices AS (
	SELECT													 
		EXTRACT (YEAR FROM date_from) AS price_year,
		AVG(value) AS avg_food_price						-- průměrná cena na všechny kategorie potravin
	FROM czechia_price 
	WHERE region_code IS NULL 							-- celorepublikový průměr
		AND EXTRACT (YEAR FROM date_from) BETWEEN 2006 AND 2018
	GROUP BY price_year
)
	SELECT 													-- spojení mezd a cen do jedné tabulky
		wages.payroll_year,
		wages.industry_branch_code,
		ibranch.name AS industry_name,
		wages.avg_wage,
		prices.avg_food_price
	FROM wages 
	JOIN prices ON wages.payroll_year = prices.price_year
	JOIN czechia_payroll_industry_branch AS ibranch ON wages.industry_branch_code = ibranch.code
	WHERE wages.industry_branch_code IS NOT NULL;			-- vyřazení prázdého záznamu
	

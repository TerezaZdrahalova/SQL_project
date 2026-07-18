-- Q4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10%)?

WITH total_wage AS (
	SELECT
		payroll_year,
		AVG(avg_wage) AS total_avg_wage,													                                    -- Celková průměrný mzda ra rok.
		AVG(avg_food_price) AS total_avg_food_price										                              	-- Celková průměrná cena potravin za rok.
	FROM t_tereza_zdrahalova_project_sql_primary_final
	GROUP BY payroll_year
),
yearly_changes AS (
	SELECT 
		payroll_year,
		total_avg_wage,
		total_avg_food_price,
		round(((total_avg_wage - LAG(total_avg_wage) OVER (ORDER BY payroll_year)) 			             -- Meziroční procentuální změna mezd.
		/ LAG(total_avg_wage) OVER (ORDER BY payroll_year) * 100
		) ::NUMERIC, 2) AS wage_percent_changes,
		round(((total_avg_food_price - LAG(total_avg_food_price) OVER (ORDER BY payroll_year))       -- Meziroční procentuální změna cen potravin.
		/ LAG(total_avg_food_price) OVER (ORDER BY payroll_year) * 100
		)::NUMERIC, 2) AS food_percent_changes
	FROM total_wage
)
	SELECT 
		payroll_year,
		wage_percent_changes,
		food_percent_changes,
		round(food_percent_changes - wage_percent_changes, 2) AS rozdil_procent				              -- O kolik rostly ceny rychleji než mzdy.
	FROM yearly_changes
	WHERE wage_percent_changes IS NOT NULL
		AND food_percent_changes IS NOT NULL												                                -- Vynecháme prvník rok s nulou.
		AND food_percent_changes > 10														                                    -- Vyhledání let s 10% nárůstem.
	ORDER BY payroll_year;

-- A: V žádném ve sledovaném období (2006 - 2018) nebyl meziroční nárůst cen potravin o více než 10% vyšší než růst mezd.
-- Nejblíže byl rok 2013 - mzdy klesly o 1,56% a potraviny vzrostly o 5,55% = rozdíl 7,11%.

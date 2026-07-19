-- Q5: Má výška HDP vliv na změny ve mzdách a cenách potravin? 
-- Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či
-- mzdách ve stejném nebo následujícím roce výraznějším růstem?

WITH gdp_changes AS (										                                          -- Porovnání HDP se změnami ve stejném roce
	SELECT
		year,
		gdp,
		round(((gdp - LAG(gdp) OVER (ORDER BY year))
		/ LAG(gdp) OVER (ORDER BY year) * 100
		)::NUMERIC, 2) AS gdp_percent_changes				                                  -- Meziroční procentní změna HDP.
	FROM economies
	WHERE country = 'Czech Republic'
),
total_wage AS (
	SELECT 
		payroll_year,
		AVG(avg_wage) AS total_avg_wage,					                                    -- Celková průměrná mzda za rok.
		AVG(avg_food_price) AS total_avg_food_price			                              -- Celková průměrná cena potravin za rok.
	FROM t_tereza_zdrahalova_project_sql_primary_final
	GROUP BY payroll_year
),
yearly_changes AS (
	SELECT 
		payroll_year,
		round(((total_avg_wage - LAG(total_avg_wage) OVER (ORDER BY payroll_year))
		/ LAG(total_avg_wage) OVER (ORDER BY payroll_year) * 100
		)::NUMERIC, 2) AS wage_percent_change,				                              -- Meziroční procentuální změna mezd.
		round(((total_avg_food_price - LAG(total_avg_food_price) OVER (ORDER BY payroll_year))
		/ LAG(total_avg_food_price) OVER (ORDER BY payroll_year) * 100
		)::NUMERIC, 2) AS food_percent_change				                                -- Meziroční procentuální změna cen potravin.
	FROM total_wage
)
	SELECT 
		yearly_changes.payroll_year,
		gdp_changes.gdp_percent_changes,
		yearly_changes.wage_percent_change,
		yearly_changes.food_percent_change
	FROM yearly_changes
	JOIN gdp_changes ON yearly_changes.payroll_year = gdp_changes.YEAR 	          -- Stejný rok.	
	ORDER BY yearly_changes.payroll_year;

-- A: Ve stejném roce nelze vidět jasná souvislost mezi výškou HDP a růstem cen/mezd.
-- např. Rok 2009 - HDP kleslo (-4,66%), mzdy rostly (3,07%) a ceny potravin klesly (-6,81%).
	
WITH gdp_changes AS (										                                        -- Porovnání HDP se změnami ve stejném roce
	SELECT
		year,
		gdp,
		round(((gdp - LAG(gdp) OVER (ORDER BY year))
		/ LAG(gdp) OVER (ORDER BY year) * 100
		)::NUMERIC, 2) AS gdp_percent_changes				                                -- Meziroční procentní změna HDP.
	FROM economies
	WHERE country = 'Czech Republic'
),
total_wage AS (
	SELECT 
		payroll_year,
		AVG(avg_wage) AS total_avg_wage,					                                  -- Celková průměrná mzda za rok.
		AVG(avg_food_price) AS total_avg_food_price			                            -- Celková průměrná cena potravin za rok.
	FROM t_tereza_zdrahalova_project_sql_primary_final
	GROUP BY payroll_year
),
yearly_changes AS (
	SELECT 
		payroll_year,
		round(((total_avg_wage - LAG(total_avg_wage) OVER (ORDER BY payroll_year))
		/ LAG(total_avg_wage) OVER (ORDER BY payroll_year) * 100
		)::NUMERIC, 2) AS wage_percent_change,				                              -- Meziroční procentuální změna mezd.
		round(((total_avg_food_price - LAG(total_avg_food_price) OVER (ORDER BY payroll_year))
		/ LAG(total_avg_food_price) OVER (ORDER BY payroll_year) * 100
		)::NUMERIC, 2) AS food_percent_change				                                -- Meziroční procentuální změna cen potravin.
	FROM total_wage
)
	SELECT 
		yearly_changes.payroll_year AS nasledujici_rok,
		gdp_changes.YEAR AS rok_hdp,
		gdp_changes.gdp_percent_changes,
		yearly_changes.wage_percent_change,
		yearly_changes.food_percent_change
	FROM yearly_changes
	JOIN gdp_changes ON gdp_changes.YEAR + 1 = yearly_changes.payroll_year	       -- HDP z roku vs. mzdy/ceny z roku +1.	
	ORDER BY yearly_changes.payroll_year;

-- A: Ani s ročním zpoždení není zaznamenaná žádná konzistence.
-- např. Rok 2009 - HDP kleslo (-4,66%), mzdy rostly (1,91%) a ceny potravin vzrostly (1,77%).

-- Datová sada neukazuje jednoznačný ani konzistentní vztah mezi cenany potravin/mzdy/HDP. To ani při porovnání ve stjeném roce a roce +1.
-- Nelze tedy jednoznačně potvrdit, že by výraznější růst HDP vedl k výraznějšímu růstu mezd a cen potravin.

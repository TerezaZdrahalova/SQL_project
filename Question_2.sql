-- Q2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT 
	payroll_year,
	AVG(avg_wage) / AVG(milk_price) AS avg_liters_of_milk,				-- Průměry mezd a litrů mléka 
	avg(avg_wage) / AVG(bread_price) AS avg_kg_of_bread			  		-- Průměry mezd a kilogramů chleba.
FROM t_tereza_zdrahalova_project_sql_primary_final
WHERE payroll_year IN (2006, 2018)								        -- Omezení na první a poslední srovnatelné období.
GROUP BY payroll_year 
ORDER BY payroll_year;

-- A: Dostupnost základních potravin, jako je chleba a mléko v čase vzrostla. Lidé si mohli za průměrnou mzdu koupit více základních potravin.
-- Mléko: Zatímco v roce 2006 si za průměrnou mzdu lidé mohli koupit 1 466 litrů mléka (zaokrouhleno).
-- V roce 2018 to bylo 1 670 litrů mléka (zaokrouhleno).
-- Chleba: Zatímco v roce 2006 si za průměrnou mzdu lidí mohli koupit 1 313 kilogramů chleba (zaokrouhleno).
-- V roce 2018 to bylo 1 365 kilogramů chleba (zaokrouhleno).
-- Zajímavostí je, že dostupnost mléka měla větší nárůst než dostupnost chleba.

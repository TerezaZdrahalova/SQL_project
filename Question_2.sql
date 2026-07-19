-- Q2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

WITH food_prices AS (
	SELECT 
		EXTRACT(YEAR FROM date_from) AS price_year,
		AVG(CASE WHEN category_code = 114201 THEN value END) AS milk_price, 		-- Cena mléka.
		AVG(CASE WHEN category_code = 111301 THEN value END) AS bread_price			-- Cena chleba.
	FROM czechia_price 
	WHERE category_code IN (114201, 111301)
		AND region_code IS NULL														-- Ceny za celou ČR.
		AND EXTRACT(YEAR FROM date_from) IN (2006, 2018)							-- První a poslední srovnatelné období.
	GROUP BY price_year 
)
	SELECT 
		wages.payroll_year,
		AVG(wages.avg_wage) / AVG(food_prices.milk_price) AS avg_liters_of_milk,	-- Kolik l mléka lze koupit za prům. mzdu.
		AVG(wages.avg_wage) / AVG(food_prices.bread_price) AS avg_kg_of_bread		-- Kolik kg chleba lze koupit za prům. mzdu.
	FROM t_tereza_zdrahalova_project_sql_primary_final AS wages 
	JOIN food_prices ON wages.payroll_year = food_prices.price_year 
	WHERE wages.payroll_year IN (2006, 2018)								
	GROUP BY wages.payroll_year 
	ORDER BY wages.payroll_year;

-- A: Dostupnost základních potravin, jako je chleba a mléko v čase vzrostla. Lidé si mohli za průměrnou mzdu koupit více základních potravin.
-- Mléko: Zatímco v roce 2006 si za průměrnou mzdu lidé mohli koupit 1 466 litrů mléka (zaokrouhleno).
-- V roce 2018 to bylo 1 670 litrů mléka (zaokrouhleno).
-- Chleba: Zatímco v roce 2006 si za průměrnou mzdu lidí mohli koupit 1 313 kilogramů chleba (zaokrouhleno).
-- V roce 2018 to bylo 1 365 kilogramů chleba (zaokrouhleno).
-- Zajímavostí je, že dostupnost mléka měla větší nárůst než dostupnost chleba.
-- pozn. Ceny konkrétních položek (mléko, chleba) se čerpají ze zdrojové tabulky czechia_price, jelikož primární tabulka obsahuje data za všchny odvětví.

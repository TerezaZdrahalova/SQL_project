-- Q3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
WITH new_prices as(											                                                      -- Roční průměrná cena pro každou kategorii.
	SELECT 
		category_code,
		EXTRACT (YEAR FROM date_from) AS price_year,
		avg(value) AS avg_price
	FROM czechia_price 
	WHERE region_code IS NULL 								                                                  -- Ceny pro celou republiku.
	GROUP BY category_code, price_year
),
avg_prices AS (												                                                        -- Procentuální změny cen pro každou kategorii (meziroční).
	SELECT 
		category_code,
		price_year,
		avg_price,
		LAG(avg_price) OVER (PARTITION BY category_code ORDER BY price_year) AS previous_year,		-- Cena stejné kategorie z předchozího roku.
		round(((avg_price - LAG(avg_price) OVER (PARTITION BY category_code ORDER BY price_year)) 
		/ LAG(avg_price) OVER (PARTITION BY category_code ORDER BY price_year) * 100
		)::NUMERIC
		, 2) AS percent_changes
	FROM new_prices
		)
	SELECT																							                                        -- Průměrná meziroční změna za všechny roky, řazeno od nejpomaleji zdražující.
		cpc.name AS food_name,
		round (avg(avg_prices.percent_changes), 2) AS avg_changes_percent
	FROM avg_prices 
	JOIN czechia_price_category AS cpc ON avg_prices.category_code = cpc.code
	WHERE avg_prices.percent_changes IS NOT NULL 													                      -- Vynecháme první rok s NULL.
	GROUP BY cpc.name
	ORDER BY avg_changes_percent ASC;

-- A: Nejpomaleji zdražující položkou je cukr krystalový, jehož cena v průměru dokonce i mírně klesá. 
-- Následují rajská jablka a banány.

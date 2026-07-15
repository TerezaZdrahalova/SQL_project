-- Vytvoření sekundární tabulky pro projekt SQL.
-- Tabulka obsahuje údaje o zemích Evropy mimo Českou republiku.
CREATE TABLE t_Tereza_Zdrahalova_project_SQL_secondary_final AS 
SELECT 
	e.year,
	e.country,
	e.population,
	e.gini,
	e.gdp 
FROM economies AS e
JOIN countries c 
	ON e.country = c.country 					    -- Spojení tabulek pomocí sloupce country.
WHERE c.continent = 'Europe'					  	-- Filtry pouze na státy Evropy.
	AND e.country <> 'Czechia'					  	-- Vyřazení České republiky.
	AND e.YEAR BETWEEN 2006 AND 2018				-- Filtr 2006 až 2018, aby byly data konzistentní s primární tabulkou.
ORDER BY e.country, e.year;

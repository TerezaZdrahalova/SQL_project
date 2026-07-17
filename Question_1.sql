-- Q1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
 
WITH wage_changes AS (
	SELECT 
 		payroll_year,
 		industry_name,
 		avg_wage,
 		LAG(avg_wage) OVER(PARTITION BY industry_name ORDER BY payroll_year) AS previous_year_wage,			-- Načtení dat z předchozího řádku, počítáno pro každé odvětví zvlášť, seřazeno podle roku. 
 		ROUND((avg_wage - LAG(avg_wage) OVER (PARTITION BY industry_name ORDER BY payroll_year))			-- výpočet procentní změny
 		/ LAG(avg_wage) OVER(PARTITION BY industry_name ORDER BY payroll_year) * 100, 2
 		) AS percent_value
	FROM t_tereza_zdrahalova_project_sql_primary_final
 )
	SELECT 
 		industry_name,
 		COUNT(CASE WHEN percent_value < 0 THEN 1 END) AS percent_decline									-- Počítáme podmínku kolikrát byla hodnota menší než 0 - určí nám kolikrát byl pokles mezd.
	FROM wage_changes
	GROUP BY industry_name																					-- Seskupení podle odvětví.
	ORDER BY percent_decline DESC;	-- Seřazeno dle poklesu sestupně.
	
 -- A: V průběhu let 2006 - 2018 mzdy celkově rostly, ale né rovnoměrně ve všech odvětvích.
 -- Nejvyšší pokles mezd byl zaznamenán v těžbě a stavebnictví a poté ve Výrobě a rozvodu el, plynu, tepla a klim. vzduchu.
 -- Celkem 2x jsme zaznamenali pokles ve čtyřech odvětví a 1x pokles evidujeme u devíti odvětví.
 -- Naopak zdravotní a sociální péče, doprava a skladování, zpracovatelský průmysl a ostatní činnosti nezaznamenali žádný pokles, tzn. měli nepřetržitý meziroční růst.
 -- V žádném z odvětví ale neevidujeme dlouhodobý klesající trend.

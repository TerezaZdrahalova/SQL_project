# SQL_project
## Zadání projektu
Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují **dostupnost základních potravin široké veřejnosti.** Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast. Potřebují k tomu **od vás připravit robustní datové podklady**, ve kterých bude možné vidět **porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.**
Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací **dalších evropských států** ve stejném období, jako primární přehled pro ČR.

###Výzkumné otázky
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10%)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

###Výstupy z projektu
Výstupem by měly být dvě tabulky v databázi, ze kterých se požadovaná data dají záskat. Tabulky pojmenujte t_jmeno_prijmeni_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období - společné roky) a t_jmeno_prijmeni_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech). Dále připravte sadu SQL, které z vámi připravených tabulek získají datový podklad k odpovězení na vytyčené výzkumné otázky.

##Průzkum dat a tvorba tabulek
1. **Určení kódů pro mzdy**
   - value_type_code = 5958 - Průměrná hrubá mzda na zaměstnance.
   - calculation_code = 200 - Přepočtený.
2. **Určení kódů pro potraviny**
   - 114201 = Mléko polotučné paterované (jednotka: litr).
   - 111301 = Chléb konzumní kmínový (jednotka: kilogram).
3. **Časový rozsah**
   - czechia_payroll = udává roky 2000 - 2021
   - czechia_price = udává roky 2006 - 2018
   * Pro primární tabulku byly zvoleny roky 2006 - 2018, aby byla splněna podmínka porovnatelného období.*
##Práce s daty
1. 

# SQL_project
## Zadání projektu
Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují **dostupnost základních potravin široké veřejnosti.** Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast. Potřebují k tomu **od vás připravit robustní datové podklady**, ve kterých bude možné vidět **porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.**
Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací **dalších evropských států** ve stejném období, jako primární přehled pro ČR.

### Výzkumné otázky
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10%)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

### Výstupy z projektu
Výstupem by měly být dvě tabulky v databázi, ze kterých se požadovaná data dají záskat. Tabulky pojmenujte t_jmeno_prijmeni_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období - společné roky) a t_jmeno_prijmeni_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech). Dále připravte sadu SQL, které z vámi připravených tabulek získají datový podklad k odpovězení na vytyčené výzkumné otázky.

## Primární tabulka
### Průzkum dat a tvorba tabulek
1. **Určení kódů pro mzdy**
   - value_type_code = 5958 - Průměrná hrubá mzda na zaměstnance.
   - calculation_code = 200 - Přepočtený.
2. **Určení kódů pro potraviny**
   - 114201 = Mléko polotučné paterované (jednotka: litr).
   - 111301 = Chléb konzumní kmínový (jednotka: kilogram).
3. **Časový rozsah**
   - czechia_payroll = udává roky 2000 - 2021
   - czechia_price = udává roky 2006 - 2018

 *(Pro primární tabulku byly zvoleny roky 2006 - 2018, aby byla splněna podmínka porovnatelného období.)*
### Práce s daty
1. **Mzdy**
   - Agregace AVG a GROUP BY = dosáhlo se hodnot za rok a odvětví.
2. **NULL**
   - Vyřazení NULL z industry_branch_code = nelze přiřadit k odvětví.
   - Vyřazení NULL z region_code = omezení krajských hodnot.
3. **Filtr roku**
   - Byly vybrány roky 2006 - 2018 = při ověření přes MIN, MAX, COUNT (DISTINCT) ... jsou společné roky 2006 - 2018, proto byl aplikován filtr BETWEEN místo           JOINU, aby byl výsledek přehlednější s jasně ukázal v jakém rozsahu se pohybujeme. 

## Sekundární tabulka
### Práce s daty
1. **Spojení tabulek**
   - Spojení tabulek přes sloupec country, který mají tabulky stejné.
2. **Filtry**
   - Vyfiltrování pouze na státy Evropy.
   - Filtr na Českou republiku = ČR jsme z dat vyřadili, jelikož sekundární tabulka se zaměřuje na dodatečná data ostatních zemí.
   - Filtr roku 2006 - 2018 = konzistentnost s primární tabulkou.
  
## Odpovědi na výzkumné otázky
**1.** **Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**

V průběhu let 2006 - 2018 mzdy celkově **rostly, ale ne rovnoměrně** ve všech odvětvích. **Nejvyšší pokles jsme zaznamenali** ve stavebnictví a poté ve výrobě a rozvodu el., plynu, tepla a klim. vzduchu. Celkem 2x jsme zaznamenali pokles ve čtyřech odvětvích a 1x pokles evidujeme u devíti odvětví. **Naopak** zdravotní a sociální péče, doprava a skladování, zpracovatelský průmysl a ostatní činnosti **nezazanamenali žádný pokles**, tzn. měli **nepřetržitý meziroční růst.** **V žádném z odvětví ale neevidujeme dlouhodobý klesající trend.**

**2.** Dostupnost základních potravin, jako je chleba a mléko **v čase vzrostla**. Lidé si **mohli** za průměrnou mzdu **koupit více** základních potravin.
- **Mléko:** Zatímco v roce 2006 si za průměrnou mzdu lidí mohli koupit 1 466 litrů mléka. V roce 2018 to bylo 1 670 litrů.
- **Chleba:** Zatímco v roce 2006 si za průměrnou mzdu lidé mohli koupit 1 313 kilogramů chleba. V roce 2018 to bylo 1 365 kilogramů.
Zajímavostí je, že dostupnost mléka měla větší nárůst než dostupnost chleba.

*Pozn. Míry kilogramů a litrů jsou zaokrouhleny na jednotky.*

**3.** Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?


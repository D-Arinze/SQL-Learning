USE portfolioproject;
-- Total cases vs. Total deaths

SELECT location, date, total_cases, new_cases, total_deaths, population, (total_deaths/total_cases) *100 AS deathpercent -- , MAX(total_cases) AS TOTAL_CASES, SUM(total_deaths) AS TOTAL_DEATHS, 

FROM portfolioproject.coviddeathssql1

ORDER BY 1,2;

-- Total cases vs. population
SELECT location, date, total_cases, new_cases, population, (total_cases/population) *100 AS infected_populace 

FROM portfolioproject.coviddeathssql1

WHERE (total_cases/population)*100 != 0;

-- Total deaths vs. population

SELECT location, date, population, total_deaths, (total_deaths/population) *100 AS death_counts-- , MAX(total_deaths)

FROM portfolioproject.coviddeathssql1

ORDER BY death_counts DESC;

-- The sum aggregate function was used with an OVER function so as to only sum distinct population by each country. 
-- So instead of summing up each population cell, it will only sum incrementally when there is a change in location.
SELECT cd.location, cd.date, cd.population, cv.total_vaccinations, SUM(cd.population) OVER (PARTITION BY location)

FROM coviddeathssql1 cd
JOIN covidvaccinationssql cv ON (cd.continent = cv.continent AND cd.date = cv.date)

GROUP BY location
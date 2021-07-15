-- select data that we are going to be using

SELECT location, STR_TO_DATE(date, '%m/%d/%Y') AS date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
order by 1,2;


-- Loking at total cases vs total deaths
-- Shows likelihood of dying if you contractcovid in your country

SELECT location, STR_TO_DATE(date, '%m/%d/%Y') AS date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 2) as DeathPercentage
FROM coviddeaths
WHERE location LIKE '%turkey%'
OrDER BY deathpercentage desc


-- Looking at total cases versus population
-- Shows what percentage of population infected Covid-19

SELECT location, STR_TO_DATE(date, '%m/%d/%Y') AS date, total_cases, population, ROUND((total_cases/population)*100, 2) AS infection_rate
FROM coviddeaths
ORDER BY infection_rate DESC


-- Looking at Countries with Highest Infection Rtae compared to Population

SELECT location, MAX(total_cases) AS HighestInfectionCount, population, ROUND(MAX((total_cases/population))*100, 2) AS infection_rate
FROM coviddeaths
GROUP BY location, population
ORDER BY infection_rate DESC


-- Showing Countries with Highest Death Count per Population

SELECT location, MAX(CAST(total_deaths as double)) as totaldeathscount
From coviddeaths
where continent is not null
group by location
order by totaldeathscount desc


-- Showing total number of cases by continent


SELECT continent, MAX(total_cases) as totaldeathscountbycontinent
FROM coviddeaths
WHERE continent is not null
GROUP BY continent
ORDER BY totaldeathscountbycontinent DESC


-- Showing total number of deaths by continent

SELECT location, MAX(CAST(total_deaths as double)) as totaldeathscountbycontinent
FROM coviddeaths
WHERE continent is not null
GROUP BY location
ORDER BY totaldeathscountbycontinent DESC

-- global numbers
 
SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as double)) as total_deaths, SUM(CAST(new_deaths as double))/SUM(new_cases)*100 as DeathPercentage
From coviddeaths
WHERE continent is not null
-- group by date
order by 1,2 


-- Looking at total population vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as double)) OVER (PARTITION BY dea.location order by dea.location,dea.date) as RollingPeopleVaccinations
FROM coviddeaths dea 
JOIN covidvaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null


-- Looking at total Vaccination rate by popoulation

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinations)
as
(
SELECT dea.continent, dea.location, STR_TO_DATE(vac.date, '%m/%d/%Y'), dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as double)) OVER (PARTITION BY dea.location order by dea.location, STR_TO_DATE(vac.date, '%m/%d/%Y')) as RollingPeopleVaccinations
FROM coviddeaths dea 
JOIN covidvaccinations vac 
 ON dea.location = vac.location 
 AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, round((RollingPeopleVaccinations/population)*100,2) as vaccinationrates
FROM popvsvac

-- TEMP TABEL

Drop Table If Exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations double,
RollingPeopleVaccinations numeric
)

Insert Into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, STR_TO_DATE(vac.date, '%m/%d/%Y'), dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as double)) OVER (PARTITION BY dea.location order by dea.location, STR_TO_DATE(vac.date, '%m/%d/%Y')) as RollingPeopleVaccinations
FROM coviddeaths dea 
JOIN covidvaccinations vac 
 ON dea.location = vac.location 
 AND dea.date = vac.date
-- WHERE dea.continent is not null

SELECT *, round((RollingPeopleVaccinations/population)*100,2) as vaccinationrates
FROM #PercentPopulationVaccinated


-- Creating view to store data for later visualizations

percentpeoplevaccinatedCreate view PercentPeopleVaccinated as
SELECT dea.continent, dea.location, STR_TO_DATE(vac.date, '%m/%d/%Y'), dea.population, vac.new_vaccinations,
 SUM(cast(vac.new_vaccinations as double)) OVER (PARTITION BY dea.location order by dea.location, STR_TO_DATE(vac.date, '%m/%d/%Y')) as RollingPeopleVaccinations
FROM coviddeaths dea 
JOIN covidvaccinations vac 
 ON dea.location = vac.location 
 AND dea.date = vac.date
WHERE dea.continent is not null



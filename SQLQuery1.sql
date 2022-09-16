SELECT *
FROM portfolioproject..coviddeath

SELECT *
FROM portfolioproject..covidvaccination


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject..coviddeath
order by 1,2



SELECT location, date, total_cases, population, (total_cases/population)*100 as Percentage
FROM portfolioproject..coviddeath
where location like '%states%'
order by 1,2




SELECT location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population)*100) as Percentage
FROM portfolioproject..coviddeath
--where location like '%states%'
group by location, population
order by percentage desc



SELECT location, MAX(cast(total_deaths as int)) as TotalDeathsCount
FROM portfolioproject..coviddeath
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathsCount desc



SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathsCount
FROM portfolioproject..coviddeath
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathsCount desc



SELECT date, SUM(new_cases) as SumOfCases, SUM(cast(new_deaths as int)) as SumOFDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Percentage
FROM portfolioproject..coviddeath
--where location like '%states%'
where continent is not null
group by date
order by 1,2




SELECT SUM(new_cases) as SumOfCases, SUM(cast(new_deaths as int)) as SumOFDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Percentage
FROM portfolioproject..coviddeath
--where location like '%states%'
where continent is not null
order by 1,2



with PopVsVac( continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as  
(
SELECT dea.continent,dea.location, dea.date,  dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location) as RollingPeopleVaccinated 
FROM portfolioproject..coviddeath  dea
JOIN portfolioproject..covidvaccination  vac
ON  dea.location=vac.location
AND dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100 as percentage
from PopVsVac



Drop table if exists #percentpopulationvaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population  numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
SELECT dea.continent,dea.location, dea.date,  dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location) as RollingPeopleVaccinated 
FROM portfolioproject..coviddeath  dea
JOIN portfolioproject..covidvaccination  vac
ON  dea.location=vac.location
AND dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100 as percentage
from #PercentPopulationVaccinated




Create view PercentPopulationVaccinated as
SELECT dea.continent,dea.location, dea.date,  dea.population, vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location) as RollingPeopleVaccinated 
FROM portfolioproject..coviddeath  dea
JOIN portfolioproject..covidvaccination  vac
ON  dea.location=vac.location
AND dea.date=vac.date
where dea.continent is not null
--order by 2,3


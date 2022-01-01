Select * 
from [Portfolio Project]..CovidDeaths
where continent is not null
order by 3,4 

Select * 
from [Portfolio Project]..covidvaccinarion
order by 3,4 

--Select Data that for analysis

Select Location, date,total_cases, new_cases, total_deaths, population
from [Portfolio Project]..CovidDeaths
order by 1,2


-- Total cases vs total deaths
-- Shows the likelihood of dying if you contract covid in your country
Select Location, date,total_cases, total_deaths,(total_deaths/total_cases) * 100 as DeathPercentage
from [Portfolio Project]..CovidDeaths
where location like '%states%'
order by 1,2


--Total cases vs Population
-- Show the percentage of population have covid

Select Location, date,total_cases, population,(total_cases/population) * 100 as Percentofpopulation
from [Portfolio Project]..CovidDeaths
where location like '%states%'
order by 1,2


--Countries with highest infestion rate compared to population

Select Location, population, continent, Max(total_cases) as HighestInfectionCount, population, Max(total_cases/population) * 100 as percentpopulationinfectd
from [Portfolio Project]..CovidDeaths
--where location like '%states%'
group by location, population, continent
order by percentpopulationinfectd desc

--Countries with highest Death count per population

Select Location, continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project]..CovidDeaths
--where location like '%states%' 
where continent is not null
group by location, continent
order by TotalDeathCount desc


--Breakdown by Continent


-- Continents with the highest deaths counts
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project]..CovidDeaths
--where location like '%states%' 
where continent is not null
group by continent
order by TotalDeathCount desc



--GLOBAL NUMBER
Select  Sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(new_cases)/sum(cast(new_deaths as int)) as DeathPercentage
from [Portfolio Project]..CovidDeaths
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

Select * 
from [Portfolio Project]..CovidDeaths  dea
join [Portfolio Project]..CovidVaccinarion vac 
	on dea.location = vac.location
	and dea.date = vac.date





Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from [Portfolio Project]..CovidDeaths  dea
join [Portfolio Project]..CovidVaccinarion vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

WIth popvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int, vac.new_vaccinations)) Over(partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths  dea
join [Portfolio Project]..CovidVaccinarion vac 
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--der by 2, 3
)
Select *, (RollingPeopleVaccinated/population)*100 from popvsVac


--TEMP TABLE
Drop table if exists #PercentpopulationVaccinated
Create table #PercentpopulationVaccinated
( 
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentpopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int, vac.new_vaccinations)) Over(partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths  dea
join [Portfolio Project]..CovidVaccinarion vac 
	on dea.location = vac.location
	and dea.date = vac.date

--der by 2, 3
Select *, (RollingPeopleVaccinated/population)*100 from #PercentpopulationVaccinated

--create view to store for late vizualisation
Create view highestdeath
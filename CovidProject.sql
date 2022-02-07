select *
from CovidDeaths
--where continent is not null
order by 3,4

select *
from CovidVaccinated
order by 3,4


-- Select Data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
where continent is not null
order by 1,2


-- Looking at Total cases vs. Total deaths in Poland

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
Where Location = 'Poland'
and continent is not null
order by 1,2 desc


-- Looking at Total Cases Vs Population

select location, date, total_cases, population, (total_cases/population)*100 as CasesPrecentage
from CovidDeaths
Where Location = 'Poland'
and  continent is not null
order by 1,2


-- Looking at coutries with highest infection rate compared to population

select location, population,  MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as CasesPrecentage
from CovidDeaths
where continent is not null
group by location ,population
order by 4 desc

-- Showing countries with Highest Death Count 

select Location, MAX(cast(total_deaths as int)) as TotalDeathCount 
from CovidDeaths
where continent is not null
group by location
order by 2 desc

-- Now let's break things down by Continent

select Location, MAX(cast(total_deaths as int)) as TotalDeathCount 
from CovidDeaths
where continent is  null and location not like '%inc%'
group by location
order by 2 desc

-- Showing countries with Highest Death Count per Population

select Location, population, MAX(cast(total_deaths as int)) as TotalDeathCount, MAX(cast(total_deaths as int)/population)*100 as TotalDeathPercentage
from CovidDeaths
where continent is not null
group by location, population
order by 4 desc

-- GLOBAL NUMBERS

select  date, SUM(new_cases) as NewCases, SUM(cast(new_deaths as int)) as NewDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathToCases
from CovidDeaths
Where continent is not null
group by date
order by 1

-- Total Number of Infections, Deaths and Death to cases ratio

select  SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathToCases
from CovidDeaths
Where continent is not null


-- Looking at Total Population vs Vaccinations

select   cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
,SUM(cast(cv.new_vaccinations as bigint)) OVER (Partition by cd.location order by cd.location, cd.date  ) as RollingNewVaccines
from CovidDeaths cd
JOIN CovidVaccinated cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
order by 2,3


--PercentageOfPeopleVaccinated


select  cd.location ,cd.population
,MAX(cv.people_vaccinated) as PeopleVaccinated, MAX(cv.people_vaccinated)/cd.population*100 as PercentageOfPeopleVacci
from CovidDeaths cd
JOIN CovidVaccinated cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
group by cd.location, cd.population
order by 4 desc


-- Creating View

Create View PercentageOfPeopleVaccinated as
select  cd.location ,cd.population
,MAX(cv.people_vaccinated) as PeopleVaccinated, MAX(cv.people_vaccinated)/cd.population*100 as PercentageOfPeopleVacci
from CovidDeaths cd
JOIN CovidVaccinated cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
group by cd.location, cd.population
--order by 4 desc
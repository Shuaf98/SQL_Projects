
Select *
From covid_project..covidDeaths

order by 3,4

--Select *
--From covid_project..covidVaccinations
-- 
-- Select Data Which we will use
Select Location, date, total_cases, new_cases, total_deaths, population
From covid_project..covidDeaths
order by 1,2 
-- We can see clearly just from the top of the data that Afghanistans cases went from null to high, very quickly.

-- Total Cases Vs. Total Deaths (deaths per cases): Likelihood of dying, when contracting Covid (in the US)
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From covid_project..covidDeaths
Where location like '%states%'
order by 1,2

-- Total Cases vs. the Population (percentage of population in US which contracted Covid
Select Location, date, total_cases, population, (total_cases/population)*100 as CasePerPopulation
From covid_project..covidDeaths
Where location like '%states%'
order by 1,2
-- We can see, that as of 2022, almost 20% percent of the US population has contracted COVID

--Countries with highest Infection Rate per Population
Select Location, Population,  MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectionRate
From covid_project..covidDeaths
Group by Location, Population
order by InfectionRate desc -- United States ranks 21. Andorra has a crazy high infection rate of 36%

--Highest Death Rate Per Population
Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount --need to cast, as the data typ is varchar.
From covid_project..covidDeaths
Where continent is not null -- There is a problem in the location, in that it also shows data per continent and other groupings as well.
Group by Location
order by TotalDeathCount desc
--United States has the highest Total Death Count

-- Deaths Per Continent
Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount --need to cast, as the data typ is varchar.
From covid_project..covidDeaths
Where continent is null --
Group by Location
order by TotalDeathCount desc

-- Global Analysis
Select date, SUM(new_cases) as CaseTotal, SUM(CAST(new_deaths as int)) as DeathTotal, SUM(CAST(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From covid_project..covidDeaths
Where continent is not null
Group By date
order by 1,2

--Total Global Cases
Select SUM(new_cases) as CaseTotal, SUM(CAST(new_deaths as int)) as DeathTotal, SUM(CAST(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From covid_project..covidDeaths
Where continent is not null
--Group By date
order by 1,2 -- 5,469,576 have died from Covid since January 2022, which is a 1.765% rate of death per infections.



--Analyse Deaths and Vaccinations by JOINING the dataframes
Select * 
From covid_project..covidVaccinations


Select * --checking that the join works
From covid_project..covidDeaths dea --aliases
JOIN covid_project..covidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

-- Look at Total Amount who have been vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From covid_project..covidDeaths dea --aliases
JOIN covid_project..covidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- WE want to create a cumulative count of the new_vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
		-- We want to create a rolling count per country, which restarts for each country
		,SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date)  as CumulativeVaccinations
		, 
From covid_project..covidDeaths dea --aliases
JOIN covid_project..covidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_project..covidDeaths dea
Join covid_project..covidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location = 'Albania'
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 -- Population Accumulation over Total Population
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_project..covidDeaths dea
Join covid_project..covidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_project..covidDeaths dea
Join covid_project..covidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


Select *
From PercentPopulationVaccinated
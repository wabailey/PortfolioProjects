--select location, date, cast(total_cases as int), new_cases, cast(total_deaths as int), population
--from CovidProject.dbo.CovidDeaths
--order by 1,2

---- total cases vs total deaths in UK
---- probability of dying after contracting covid in UK
--select location, date, total_cases, total_deaths, (convert(float, total_deaths) / convert(float, total_cases)) * 100 as DeathPercentage
--from CovidProject.dbo.CovidDeaths
--where location = 'United Kingdom'
--order by 1,2

---- total cases vs population in UK
---- shows the percentage of population that contracted covid in UK
--select location, date, population, total_cases, (cast(total_cases as int) / population ) * 100 as PercentOfPopInfected
--from CovidProject.dbo.CovidDeaths
--where location = 'United Kingdom'
--order by 1,2

---- countries with highest infection rate vs population
--select location, population, max(cast(total_cases as int)) as HighestInfectionCount, (max(cast(total_cases as int)) / population ) * 100 as PercentOfPopInfected
--from CovidProject.dbo.CovidDeaths
--group by population, location
--order by 4 desc

---- countries with highest death count per population
--select location, max(cast(total_deaths as int)) as TotalDeathCount
--from CovidProject.dbo.CovidDeaths
--where continent is not null
--group by location
--order by 2 desc

---- continents with highest death count
--select continent, max(cast(total_deaths as int)) as TotalDeathCount
--from CovidProject.dbo.CovidDeaths
--where continent is not null
--group by continent
--order by 2 desc

---- GLOBAL NUMBERS by day
--select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths) / nullif(sum(new_cases), 0)) * 100 as DeathPercentage
--from CovidProject.dbo.CovidDeaths
--where continent is not null
--group by date
--order by 1,2

---- GLOBAL CASES, DEATHS, PERCENTAGE
--select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths) / nullif(sum(new_cases), 0)) * 100 as DeathPercentage
--from CovidProject.dbo.CovidDeaths
--where continent is not null
--order by 1,2

--select *
--from CovidProject..CovidDeaths dea
--join CovidProject..CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date

---- total population vs vaccinations
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--from CovidProject..CovidDeaths dea
--join CovidProject..CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2, 3

--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CumulativeVaccinations
---- CumulativeVaccinations/Population * 100 for percentage of people that have been vaccinated in each country - for this query to work we need to put the calculation in a temp table or CTE
--from CovidProject..CovidDeaths dea
--join CovidProject..CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2, 3

---- CTE with above query
--With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, CumulativeVaccinations)
--as
--(
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CumulativeVaccinations
--from CovidProject..CovidDeaths dea
--join CovidProject..CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
---- order by 2, 3
--)
--select *, (CumulativeVaccinations/Population)*100 as PopulationVaccinated
--from PopVsVac


---- Temp Table with above query
--drop table if exists #PercentPopulationVaccinated
--create table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_Vaccinations numeric,
--CumulativeVaccinations numeric
--)

--insert into #PercentPopulationVaccinated
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CumulativeVaccinations
--from CovidProject..CovidDeaths dea
--join CovidProject..CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
----order by 2, 3

--select *, (CumulativeVaccinations/Population)*100 as PopulationVaccinated
--from #PercentPopulationVaccinated


-- CREATING VIEWS FOR DATA VIS

--create view PercentPopulationVaccinated as
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CumulativeVaccinations
--from CovidProject..CovidDeaths dea
--join CovidProject..CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null

--create view GlobalCasesVsDeaths as
--select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths) / nullif(sum(new_cases), 0)) * 100 as DeathPercentage
--from CovidProject.dbo.CovidDeaths
--where continent is not null

--create view DeathCountByContinent as
--select continent, max(cast(total_deaths as int)) as TotalDeathCount
--from CovidProject.dbo.CovidDeaths
--where continent is not null
--group by continent
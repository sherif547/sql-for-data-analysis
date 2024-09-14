select  * from coviddeath

select date,total_cases,new_cases,total_deaths,population from coviddeath

-- total cases vs total deaths
--1.
select location ,date,total_deaths,total_cases,round((total_deaths/total_cases)*100,2)  as death_percantage
from coviddeath
where total_deaths is not null

order by 1,2 


--2.
select location ,date,total_deaths,total_cases,round((total_deaths/total_cases)*100,2)  as death_percantage
from coviddeath
where total_deaths is not null and location like '%state%'

order by 1



--3 select info about countrirs death percentage > avg (2.92)
with temptable as
(
select location ,date,total_deaths,total_cases,round((total_deaths/total_cases)*100,2)  as death_percantage
from coviddeath
where total_deaths is not null
)

select * from temptable
where death_percantage >(select avg(death_percantage )from temptable)

--4. get max highst death percentage in countries 
with temptable as
(
select location ,date,total_deaths,total_cases,round((total_deaths/total_cases)*100,2)  as death_percantage
from coviddeath
where total_deaths is not null
)

select location,max(death_percantage)  as max_death,total_deaths,total_cases
from temptable
group by location,total_deaths,total_cases
order by max_death desc 

--5 avg_death per year in en=very country
with temptable as
(
select format(date,'yyyy')as year,(total_cases/total_deaths) as death_percantage,location
from coviddeath
where total_deaths is not null
)
select location,year,round(avg(death_percantage),2) as avg_death_percantage
from temptable
group by yEAR,location
order by location,year

-----------------------------------
-- total cases vs populaion
select location,date,(total_cases/population)*100as per_cases 
from coviddeath
order by 1

-- max total cases per country
select location,population,max((total_cases/population)*100)as per_cases 
from coviddeath
group by location,population
order by 3 desc


----------------------
select * from coviddeath

select continent,max(cast(total_deaths as int)) as death_max
from coviddeath
where continent is not null
group by continent
order by death_max


--------------------------------
select location,max(cast(total_deaths as int)) as death_max
from coviddeath
where continent is not null
group by location
order by death_max


---------------------------------------------------------------------------------

--q.total population vs vaccaion

select *
from covidvacation vac
join
coviddeath dea
on vac.location=dea.location
and vac.date=dea.date

-- Shows information about COVID-19 deaths and vaccinations from two tables
select dea.continent,dea.location,vac.date,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.date) sum_vac
from covidvacation vac
join
coviddeath dea
on vac.location=dea.location
and vac.date=dea.date
where  dea.continent is not null
order by 1,2,3



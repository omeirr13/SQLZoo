-- 1. List each country name where the population is larger than that of 'Russia'.

SELECT name FROM world WHERE population > ALL (SELECT population FROM world WHERE name='Russie')

-- 2. Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.

SELECT name FROM world WHERE gdp/population > (SELECT gdp/population FROM world WHERE name = 'United Kingdom') AND continent = 'Europe';

-- 3. List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.

SELECT name, continent FROM world WHERE continent IN (SELECT continent FROM world WHERE name IN ('Argentina', 'Australia'));

-- 4. Which country has a population that is more than United Kingdom but less than Germany? Show the name and the population.

SELECT name, population FROM world WHERE population > (SELECT population FROM world WHERE name = 'United Kingdom') AND population < (SELECT population FROM world WHERE name = 'Germany');

-- 5. Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.

SELECT name, CONCAT(ROUND(population / (SELECT population FROM world WHERE name = 'Germany')*100, 0), '%')
FROM world
WHERE continent = 'Europe';

-- 6. Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)

SELECT name FROM world WHERE gdp > ALL (SELECT gdp FROM world WHERE continent='Europe');

-- 7. Find the largest country (by area) in each continent, show the continent, the name and the area:

SELECT continent, name, area FROM world WHERE area IN (SELECT MAX(area) FROM world
GROUP BY continent);

SELECT x.continent, x.name, x.area
FROM world x
WHERE x.area > ALL (SELECT area FROM world y WHERE x.continent = y.continent AND x.area <> y.area)

SELECT x.continent, x.name, x.area
FROM world x
WHERE x.area >= ALL (SELECT area FROM world y WHERE x.continent = y.continent)

-- 8. List each continent and the name of the country that comes first alphabetically.

SELECT continent, name FROM world WHERE name IN (SELECT MIN(name) FROM world
GROUP BY continent);

SELECT continent, name FROM world x WHERE name < ALL (SELECT name FROM world y WHERE x.continent = y.continent AND x.name <> y.name);

SELECT continent, name FROM world x WHERE name <= ALL (SELECT name FROM world y WHERE x.continent = y.continent);

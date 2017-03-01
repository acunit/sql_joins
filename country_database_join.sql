-- RELATIVELY SIMPLE JOINS

-- What languages are spoken in the United States? (12)
SELECT
  cl.countrycode,
  c.name,
  cl.language,
  cl.percentage
FROM
  country c JOIN
  countrylanguage cl ON (cl.countrycode = c.code)
WHERE
  cl.countrycode = 'USA';

-- What languages are spoken in Brazil? (not Spanish...)
SELECT
  cl.countrycode,
  c.name,
  cl.language,
  cl.percentage
FROM
  country c JOIN
  countrylanguage cl ON (cl.countrycode = c.code)
WHERE
  c.name = 'Brazil';

-- What languages are spoken in Switzerland? (6)
SELECT
  cl.countrycode,
  c.name,
  cl.language,
  cl.percentage
FROM
  country c JOIN
  countrylanguage cl ON (cl.countrycode = c.code)
WHERE
  c.name = 'Switzerland';

-- What are the cities of the US? (274)
SELECT
  c.name,
  city.name,
  city.district
FROM
  country c JOIN
  city ON (city.countrycode = c.code)
WHERE
  city.countrycode = 'USA'
ORDER BY
  city.name ASC;

-- What are the cities of India? (341)
SELECT
  c.name,
  city.name,
  city.district
FROM
  country c JOIN
  city ON (city.countrycode = c.code) JOIN
  countrylanguage cl ON (cl.countrycode = c.code)
WHERE
  c.name = 'India'
GROUP BY
  c.name,
  city.name,
  city.district
ORDER BY
  city.name ASC;

-- What are the official languages of Switzerland? (4 languages)
SELECT
  c.name,
  cl.language,
  cl.isofficial
FROM
  country c JOIN
  city ON (city.countrycode = c.code) JOIN
  countrylanguage cl ON (cl.countrycode = c.code)
WHERE
  c.name = 'Switzerland'
  AND
  cl.isofficial = TRUE
GROUP BY
  c.name,
  cl.language,
  cl.isofficial;

-- Which country or contries speak the most languages? (12 languages)
-- Hint: Use GROUP BY and COUNT(...)
SELECT
  c.name,
  count(cl.language) AS number_of_languages
FROM
  country c JOIN
  countrylanguage cl ON (cl.countrycode = c.code)
GROUP BY
  c.name
ORDER BY
  number_of_languages DESC;

-- Which country or contries have the most offficial languages? (4 languages)
-- Hint: Use GROUP BY and ORDER BY
SELECT
  c.name,
  count(cl.language) AS number_of_languages
FROM
  country c JOIN
  countrylanguage cl ON (cl.countrycode = c.code)
WHERE
  cl.isofficial = TRUE
GROUP BY
  c.name
ORDER BY
  number_of_languages DESC;

-- Which languages are spoken in the ten largest (area) countries?
-- Hint: Use WITH to get the countries and join with that table
WITH biggest AS
  (SELECT
    name,
    code,
    surfacearea
  FROM
    country
  ORDER BY
    surfacearea DESC
  LIMIT 10)
SELECT
  b.code,
  b.name,
  cl.language,
  b.surfacearea
FROM
  biggest b JOIN
  countrylanguage cl ON (cl.countrycode = b.code)
GROUP BY
  b.code,
  b.name,
  cl.language,
  b.surfacearea
ORDER BY
  b.surfacearea DESC;

-- What languages are spoken in the 20 poorest (GNP/ capita) countries in the world? (94 with GNP > 0)
-- Hint: Use WITH to get the countries, and SELECT DISTINCT to remove duplicates
WITH poorest AS
  (SELECT
    code,
    name,
    gnp / population AS gnp_per_capita
  FROM
    country
  WHERE
    gnp > 0
  ORDER BY
    gnp_per_capita ASC
  LIMIT 20)
SELECT
  p.code,
  p.name,
  cl.language,
  cl.percentage,
  p.gnp_per_capita
FROM
  poorest p JOIN
  countrylanguage cl ON (cl.countrycode = p.code)
GROUP BY
  p.code,
  p.name,
  cl.language,
  cl.percentage,
  p.gnp_per_capita
ORDER BY
  p.gnp_per_capita ASC;

-- Are there any countries without an official language?
-- Hint: Use NOT IN with a SELECT
SELECT
  cl.countrycode,
  c.code,
  c.name
FROM
  country c JOIN
  countrylanguage cl ON (cl.countrycode = c.code)
WHERE c.code NOT IN (
              SELECT
                c.code
              FROM
                country c JOIN
                countrylanguage cl ON (cl.countrycode = c.code)
              WHERE
                cl.isofficial = TRUE
              GROUP BY
                c.code)
GROUP BY
  cl.countrycode,
  c.code,
  c.name
ORDER BY
  c.code ASC;

-- What are the languages spoken in the countries with no official language? (49 countries, 172 languages, incl. English)
SELECT
  cl.countrycode,
  cl.language,
  c.name
FROM
  country c JOIN
  countrylanguage cl ON (cl.countrycode = c.code)
WHERE c.code NOT IN (
              SELECT
                c.code
              FROM
                country c JOIN
                countrylanguage cl ON (cl.countrycode = c.code)
              WHERE
                cl.isofficial = TRUE
              GROUP BY
                c.code)
GROUP BY
  cl.countrycode,
  cl.language,
  c.name
ORDER BY
  cl.countrycode ASC;

-- Which countries have the highest proportion of official language speakers?
SELECT
  c.name,
  cl.countrycode,
  SUM(cl.percentage) AS official_lang_proportion
FROM
  country c JOIN
  countrylanguage cl ON (cl.countrycode = c.code)
WHERE
  cl.isofficial = TRUE
GROUP BY
  c.name,
  cl.countrycode
ORDER BY
  official_lang_proportion DESC;

-- Which countries have the lowest proportion of official language speakers?
SELECT
  c.name,
  cl.countrycode,
  SUM(cl.percentage) AS official_lang_proportion
FROM
  country c JOIN
  countrylanguage cl ON (cl.countrycode = c.code)
WHERE
  cl.isofficial = TRUE
GROUP BY
  c.name,
  cl.countrycode
ORDER BY
  official_lang_proportion ASC;

-- What is the most spoken language in the world?
WITH speakers_by_country AS
    (SELECT
      c.code,
      cl.language,
      c.population * (cl.percentage/100) AS number_of_speakers
    FROM
      country c JOIN
      countrylanguage cl ON (cl.countrycode = c.code)
    ORDER BY
      c.code)
SELECT
  spc.language,
  SUM(number_of_speakers) AS total_speakers
FROM
  speakers_by_country spc
GROUP BY
  spc.language
ORDER BY
  total_speakers DESC;


-- CITIES

-- What is the population of the United States?
SELECT
  c.name,
  c.population
FROM
  country c
WHERE
  c.code = 'USA';

-- What is the city population of the United States?
SELECT
  city.countrycode,
  SUM(city.population) AS total_city_pop
FROM
  city city
WHERE
  city.countrycode = 'USA'
GROUP BY
  city.countrycode;

-- What is the population of the India?
SELECT
  c.name,
  c.population
FROM
  country c
WHERE
  c.name = 'India';




-- What is the city population of the India?
SELECT
  c.name,
  SUM(city.population) AS total_city_pop
FROM
  city city JOIN
  country c ON (city.countrycode = c.code)
WHERE
  c.name = 'India'
GROUP BY
  c.name;

-- Which countries have no cities? (7 not really contries...)
SELECT
  c.code,
  c.name
FROM
  country c
WHERE c.code NOT IN (
              SELECT
                cy.countrycode
              FROM
                city cy
              GROUP BY
                cy.countrycode)
GROUP BY
  c.code,
  c.name
ORDER BY
  c.name ASC;

-- LANGUAGES AND CITIES

-- What is the total population of cities where English is the offical language?
SELECT
  cl.language,
  SUM(cy.population) AS total_population
FROM
  city cy JOIN
  countrylanguage cl ON (cl.countrycode = cy.countrycode)
WHERE
  cl.isofficial = 'TRUE'
  AND
  cl.language = 'English'
GROUP BY
  cl.language;

-- What is the total population of cities where Spanish is the offical language?
SELECT
  cl.language,
  SUM(cy.population) AS total_population
FROM
  city cy JOIN
  countrylanguage cl ON (cl.countrycode = cy.countrycode)
WHERE
  cl.isofficial = 'TRUE'
  AND
  cl.language = 'Spanish'
GROUP BY
  cl.language;

-- Which countries have the 100 biggest cities in the world?
WITH hundred_biggest AS
    (SELECT
      *
    FROM
      city
    ORDER BY
      population DESC
    LIMIT 100)
SELECT
  c.code,
  c.name
FROM
  country c JOIN
  hundred_biggest b ON (b.countrycode = c.code)
GROUP BY
  c.code,
  c.name
ORDER BY
  c.name ASC;

-- What languages are spoken in the countries with the 100 biggest cities in the world?
WITH countries_with_hundred_biggest AS
    (WITH hundred_biggest AS
        (SELECT
          *
        FROM
          city
        ORDER BY
          population DESC
        LIMIT 100)
    SELECT
      c.code,
      c.name
    FROM
      country c JOIN
      hundred_biggest b ON (b.countrycode = c.code)
    GROUP BY
      c.code,
      c.name
    ORDER BY
      c.name ASC)
SELECT
  c.code,
  c.name,
  cl.language
FROM
  country c JOIN
  countries_with_hundred_biggest cwhb ON (cwhb.code = c.code) JOIN
  countrylanguage cl ON (cl.countrycode = c.code)
GROUP BY
  c.code,
  c.name,
  cl.language
ORDER BY
  c.name;

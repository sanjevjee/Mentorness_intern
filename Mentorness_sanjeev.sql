-- Ensure the date column is of type DATETIME
ALTER TABLE corona.`corona virus dataset`
MODIFY COLUMN date DATETIME;

-- Q1. Check NULL values
SELECT * 
FROM corona.`corona virus dataset`
WHERE confirmed IS NULL OR deaths IS NULL OR recovered IS NULL;

-- Q2. Update NULL values to zeros
-- UPDATE corona.`corona virus dataset`
-- SET confirmed = IFNULL(confirmed, 0),
 --   deaths = IFNULL(deaths, 0),
  --  recovered = IFNULL(recovered, 0);

-- Q3. Check total number of rows
SELECT COUNT(*) AS total_rows 
FROM corona.`corona virus dataset`;

-- Q4. Check start_date and end_date
SELECT MIN(date) AS start_date, MAX(date) AS end_date
FROM corona.`corona virus dataset`;

-- Q5. Number of months present in dataset
SELECT COUNT(DISTINCT DATE_FORMAT(date, '%d-%m-%Y')) AS num_months
FROM corona.`corona virus dataset`;

-- Q6. Monthly average for confirmed, deaths, recovered
SELECT DATE_FORMAT(date, '%Y-%m') AS month,
       AVG(confirmed) AS avg_confirmed,
       AVG(deaths) AS avg_deaths,
       AVG(recovered) AS avg_recovered
FROM corona.`corona virus dataset`
GROUP BY month;

-- Q7. Most frequent value for confirmed, deaths, recovered each month
SELECT month, 
       confirmed, 
       deaths, 
       recovered
FROM (
    SELECT DATE_FORMAT(date, '%Y-%m') AS month,
           confirmed,
           deaths,
           recovered,
           ROW_NUMBER() OVER (PARTITION BY DATE_FORMAT(date, '%Y-%m') ORDER BY COUNT(*) DESC) AS rnk
    FROM corona.`corona virus dataset`
    GROUP BY month, confirmed, deaths, recovered
) AS sub
WHERE rnk = 1;

-- Q8. Minimum values for confirmed, deaths, recovered per year
SELECT YEAR(date) AS year,
       MIN(confirmed) AS min_confirmed,
       MIN(deaths) AS min_deaths,
       MIN(recovered) AS min_recovered
FROM corona.`corona virus dataset`
GROUP BY year;

-- Q9. Maximum values of confirmed, deaths, recovered per year
SELECT YEAR(date) AS year,
       MAX(confirmed) AS max_confirmed,
       MAX(deaths) AS max_deaths,
       MAX(recovered) AS max_recovered
FROM corona.`corona virus dataset`
GROUP BY year;

-- Q10. Total number of confirmed, deaths, recovered each month
SELECT DATE_FORMAT(date, '%Y-%m') AS month,
       SUM(confirmed) AS total_confirmed,
       SUM(deaths) AS total_deaths,
       SUM(recovered) AS total_recovered
FROM corona.`corona virus dataset`
GROUP BY month;

-- Q11. Spread of coronavirus with respect to confirmed cases
SELECT SUM(confirmed) AS total_confirmed,
       AVG(confirmed) AS avg_confirmed,
       VARIANCE(confirmed) AS variance_confirmed,
       STDDEV(confirmed) AS stdev_confirmed
FROM corona.`corona virus dataset`;

-- Q12. Spread of coronavirus with respect to death cases per month
SELECT DATE_FORMAT(date, '%Y-%m') AS month,
       SUM(deaths) AS total_deaths,
       AVG(deaths) AS avg_deaths,
       VARIANCE(deaths) AS variance_deaths,
       STDDEV(deaths) AS stdev_deaths
FROM corona.`corona virus dataset`
GROUP BY month;

-- Q13. Spread of coronavirus with respect to recovered cases
SELECT SUM(recovered) AS total_recovered,
       AVG(recovered) AS avg_recovered,
       VARIANCE(recovered) AS variance_recovered,
       STDDEV(recovered) AS stdev_recovered
FROM corona.`corona virus dataset`;
-- Q14. Country having highest number of confirmed cases
SELECT country, 
       SUM(confirmed) AS total_confirmed
FROM corona.`corona virus dataset`
GROUP BY country
ORDER BY total_confirmed DESC
LIMIT 1;


-- Q15. Country having lowest number of death cases
SELECT country, 
       SUM(deaths) AS total_deaths
FROM corona.`corona virus dataset`
GROUP BY country
ORDER BY total_deaths ASC
LIMIT 1;

-- Q16. Top 5 countries having highest recovered cases
SELECT country, 
       SUM(recovered) AS total_recovered
FROM corona.`corona virus dataset`
GROUP BY country
ORDER BY total_recovered DESC
LIMIT 5;

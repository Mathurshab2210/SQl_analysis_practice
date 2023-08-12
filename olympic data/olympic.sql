SELECT * FROM zomato_practice.athelte;
select count(*) from athelte;

-- How many olympics games have been held?
select count(distinct year) from athelte;

-- Write a SQL query to list down all the Olympic Games held so far.
select distinct(games),year,Season,city from athelte
order by year;

-- SQL query to fetch total no of countries participated in each olympic 
SELECT Games, COUNT(DISTINCT NOC) AS NumberOfCountries
FROM athelte
GROUP BY Games
ORDER BY NumberOfCountries DESC;

-- Write a SQL query to return the Olympic Games which had the highest participating countries and the lowest participating countries.
 SELECT Games, COUNT(DISTINCT NOC) AS NumberOfCountries
FROM athelte
GROUP BY Games
HAVING NumberOfCountries = (SELECT MAX(NumberOfCountries) FROM (SELECT Games, COUNT(DISTINCT NOC) AS NumberOfCountries FROM athelte GROUP BY Games) AS CountryCounts)
   OR NumberOfCountries = (SELECT MIN(NumberOfCountries) FROM (SELECT Games, COUNT(DISTINCT NOC) AS NumberOfCountries FROM athelte GROUP BY Games) AS CountryCounts);

-- SQL query to return the list of countries who have been part of every Olympics games.
SELECT NOC AS Country, COUNT(DISTINCT Games) AS ParticipatedGamesCount
FROM athelte
GROUP BY NOC
HAVING ParticipatedGamesCount = (SELECT COUNT(DISTINCT Games) FROM athelte)
ORDER BY ParticipatedGamesCount DESC;

-- SQL query to fetch the list of all sports which have been part of every olympics.	
SELECT Sport, COUNT(DISTINCT Games) AS ParticipatedGames
FROM athelte
GROUP BY Sport
HAVING ParticipatedGames =(select max(ParticipatedGames) from ( select count(distinct games) as ParticipatedGames from athelte group by sport) cnt);


-- Using SQL query, Identify the sport which were just played once in all of olympics.
 SELECT Sport, COUNT(DISTINCT Games) AS ParticipatedGames,games
FROM athelte
GROUP BY Sport, games
HAVING ParticipatedGames = (select min(ParticipatedGames) from ( select count(distinct games) as ParticipatedGames from athelte group by sport) cnt);

-- Write SQL query to fetch the total no of sports played in each olympics.
select games,count(distinct sport) as cnt 
from athelte
group by games
order by cnt desc;

-- Query to fetch the details of the oldest athletes to win a gold medal at the olympics.
select * from gold
where age = (select max(age) from gold);

-- Write a SQL query to get the ratio of male and female participants
SELECT
    (SELECT  COUNT(*) FROM athelte WHERE Sex = 'M'  group by sex  ) / (SELECT COUNT(*) FROM athelte) AS male_ratio,
    (SELECT COUNT(*) FROM athelte WHERE Sex = 'F' group by sex) / (SELECT COUNT(*) FROM athelte) AS female_ratio;
    
-- SQL query to fetch the top 5 athletes who have won the most gold medals.
select name ,count(medal) as cnt from athelte
where Medal='gold'
group by name
order by cnt desc
limit 5 ;

-- SQL Query to fetch the top 5 athletes who have won the most medals (Medals include gold, silver and bronze).
select name , team,count(medal) as cnt from athelte
where Medal in ('gold','silver','bronze')
group by name,team
order by cnt desc
limit 5;

--  Write a SQL query to fetch the top 5 most successful countries in olympics. (Success is defined by no of medals won).
with cte1 as (select n.region as regions, count(medal) total_medals
from athelte a 
join noc_regions n 
on n.noc=a.noc
where medal in ('gold','silver','bronze')
group by n.region
order by total_medals desc)
select *, rank() over(order by total_medals desc) rnk
from cte1
order by total_medals desc;

-- Write a SQL query to list down the  total gold, silver and bronze medals won by each country.
SELECT
    n.region AS Country,
    SUM(CASE WHEN a.medal = 'gold' THEN 1 ELSE 0 END) AS Gold_Medals,
    SUM(CASE WHEN a.medal = 'silver' THEN 1 ELSE 0 END) AS Silver_Medals,
    SUM(CASE WHEN a.medal = 'bronze' THEN 1 ELSE 0 END) AS Bronze_Medals
FROM
    athelte a 
JOIN
    noc_regions n 
ON
    n.noc = a.noc
WHERE
    a.medal IN ('gold', 'silver', 'bronze')
GROUP BY
    n.region
ORDER BY
    gold_medals desc;
    
-- Write a SQL query to list down the  total gold, silver and bronze medals won by each country corresponding to each olympic games.
SELECT
    n.region AS Country,a.games,
    SUM(CASE WHEN a.medal = 'gold' THEN 1 ELSE 0 END) AS Gold_Medals,
    SUM(CASE WHEN a.medal = 'silver' THEN 1 ELSE 0 END) AS Silver_Medals,
    SUM(CASE WHEN a.medal = 'bronze' THEN 1 ELSE 0 END) AS Bronze_Medals
FROM
    athelte a 
JOIN
    noc_regions n 
ON
    n.noc = a.noc
WHERE
    a.medal IN ('gold', 'silver', 'bronze')
GROUP BY
    n.region,a.games
ORDER BY
    gold_medals desc;


-- Write a SQL Query to fetch details of countries which have won silver or bronze medal but never won a gold medal

with cte1 as (SELECT
    n.region AS Country,
    SUM(CASE WHEN a.medal = 'gold' THEN 1 ELSE 0 END) AS Gold_Medals,
    SUM(CASE WHEN a.medal = 'silver' THEN 1 ELSE 0 END) AS Silver_Medals,
    SUM(CASE WHEN a.medal = 'bronze' THEN 1 ELSE 0 END) AS Bronze_Medals
FROM
    athelte a 
JOIN
    noc_regions n 
ON
    n.noc = a.noc
WHERE
    a.medal IN ('gold', 'silver', 'bronze')
GROUP BY
    n.region
)
select country,gold_medals,silver_medals,bronze_medals
from cte1 
where gold_medals=0
order by country;

-- Write SQL Query to return the sport which has won India the highest no of medals. 
with cte1 as (select n.region as country ,a.sport ,count(medal) as cnt from athelte a 
join noc_regions n on
a.noc=n.noc
where Medal in ('gold','silver','bronze') 
group by n.region,a.sport
order by cnt desc)
select * from cte1 
where country='india' and cnt=(select max(cnt) from cte1 where country='india');

-- Write an SQL Query to fetch details of all Olympic Games where India won medal(s) in hockey. 
select team,sport,games,count(medal) as total_medals
from athelte
where team='india' and sport='hockey' 
group by team,sport,games
order by total_medals desc;








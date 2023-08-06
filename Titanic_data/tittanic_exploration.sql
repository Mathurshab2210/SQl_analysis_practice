SELECT * FROM trains.`trains`;
select count(*) from trains;

-- Retrieve unique passenger genders:
select distinct(sex) from trains;
-- Calculate the average age of passengers:
select avg(age) as avg_age
 from trains;
 
 -- Retrieve passengers who survived:
 select * from trains 
 where Survived =1;
 
 -- Calculate the average fare by passenger class
 select pclass, avg(fare) as avg_pclass_fare from trains
 group by pclass;
 
 -- Retrieve passengers who were female and under 18 years old:
 select * from trains 
 where sex like "%female%" and age<=18;
 
 -- Count the number of passengers by embarkation port:
 select embarked, count(PassengerId) as cnt_of_passenger
 from trains 
 group by Embarked;
 
 -- Retrieve passengers with the highest fare:
 select * from trains 
 where fare in(select max(fare) from trains);
 
 -- Calculate the survival rate for each passenger class:
 select pclass, 100*(sum(survived)/count(*)) as survival_rate from trains
 group by pclass;
 
 -- Identify the most common age among male passengers:
 select age, count(*) as cnt from trains 
 where sex='male'
 group by age
 order by cnt desc 
 limit 1;
 
 -- Identify the top 5 most common ages among passengers:
 select age ,count(*) as cnt from trains
 group by age 
 order by cnt  desc
 limit 5;
 
 
 --  Find the passenger(s) with the longest name:
 select name, length(name) from trains
 where length(name) in (select max(length(name)) from trains);
  -- or
   select name, length(name) as cnt from trains
   order by cnt desc
   limit 1;


-- Calculate the average age of male passengers who survived:
SELECT AVG(Age) AS avg_age FROM trains WHERE Sex = 'male' AND Survived = 1;

-- Identify passengers who were likely part of a family (same last name):
SELECT DISTINCT SUBSTRING_INDEX(Name, ',', 1) AS last_name,count(*) from trains
group by last_name
having count(*)>1
order by last_name;

-- Calculate the percentage of passengers who survived by embarkation port:
select embarked, 100*sum(survived=1)/count(*) as survival_rate from trains
group by Embarked;

-- Calculate the average age of passengers by gender:
select sex,avg(age) as avg_age from  trains
group by sex;

-- Calculate the survival rate for each combination of gender and class:
select sex,pclass,100*(sum(survived=1)/count(*)) as rate
from trains
group by pclass,sex
order by pclass;

-- Find the passengers with the highest fare in each class:
with cte1 as (SELECT  Pclass, MAX(Fare) AS max_fare
FROM trains
GROUP BY Pclass),
cte2 as(select name,pclass,fare from trains)
select t.name , cte1.pclass,cte1.max_fare from cte1
join cte2 t on
cte1.pclass=t.pclass
where t.fare=cte1.max_fare
order by t.pclass;

-- Calculate the number of passengers who were traveling alone (no siblings, spouses, parents, or children):
SELECT COUNT(*) AS alone_passengers
FROM trains
WHERE SibSp = 0 AND Parch = 0;

-- Identify passengers who paid a fare higher than the average fare for their class:
with cte1 as (select pclass, avg(fare) as avg_fare from trains
group  by pclass),
cte2 as (select * from trains),cte3 as (
select p.name as names,p.fare as fares,q.avg_fare,q.pclass
from cte1 q
join cte2 p on
p.pclass=q.pclass
where p.fare>q.avg_fare
order by p.pclass,avg_fare)
select pclass, count(names) as cnt
from cte3
group by pclass;

-- Calculate the average fare paid by passengers who survived vs. those who did not:
select Survived ,avg(fare) as avg_fare from trains
group by survived;

-- Calculate the average age of passengers who had siblings, spouses, parents, or children on board:

SELECT CASE
           WHEN SibSp > 0 OR Parch > 0 THEN 'With Family'
           ELSE 'Alone'
       END AS family_status,
       AVG(Age) AS avg_age
FROM trains
GROUP BY family_status;



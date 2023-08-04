-- Find the names of users who are members of at least one group.
select name from 
users 
where user_id in (select distinct(user_id) from membership);

-- : Retrieve all groups that have users aged above 30.

select distinct(g.group_name), u.name,u.age from `groups` g
join membership m 
on g.group_id=m.group_id
join users u 
on m.user_id=u.user_id
where u.age > 30;

-- Get the list of group names along with the count of members for each group using a CTE.
with cte1 as (select  count( distinct user_id) as cnt,group_id from membership
group by group_id)
select cte1.cnt,cte1.group_id,g.group_name
from `groups` g join cte1 
on cte1.group_id=g.group_id;

-- Find the names of users who are members of multiple groups using a CTE.
with cte1 as (SELECT user_id, COUNT(DISTINCT group_id) AS group_count
FROM membership
GROUP BY user_id) 
select c.user_id,c.group_count,u.name
from users u 
join cte1 c
on c.user_id=u.user_id
where c.group_count>1;

-- Calculate the average age of users and display it as a separate column for each user record.
select *, avg(age) over() as avg_age
from users;

-- Rank users based on their age within each group.
select u.name,u.age,g.group_name,
dense_rank() over(partition by g.group_id order by u.age desc) as rnk
from `groups` g 
join membership m 
on m.group_id=g.group_id
join users u 
on u.user_id=m.user_id;

-- Find the top 3 oldest users in each group along with their names and ages.

SELECT user_name, age, group_name
FROM (
  SELECT u.name AS user_name, u.age, g.group_name,
         ROW_NUMBER() OVER (PARTITION BY m.group_id ORDER BY u.age DESC) AS row_num
  FROM users u
  JOIN membership m ON u.user_id = m.user_id
  JOIN `groups` g ON m.group_id = g.group_id
) ranked_users
WHERE row_num <= 3;

-- select topp 3 for each group 
 SELECT u.name AS user_name, u.age, g.group_name,
         ROW_NUMBER() OVER (PARTITION BY m.group_id ORDER BY u.age DESC) AS row_num
  FROM users u
  JOIN membership m ON u.user_id = m.user_id
  JOIN `groups` g ON m.group_id = g.group_id;
  
-- Retrieve all group names along with their respective members' names.
select g.group_name, group_concat(u.name) as members_of_grp
from `groups` g 
join membership m 
on g.group_id=m.group_id
join users u 
on u.user_id=m.user_id
group by group_name;

-- List all users and the names of the groups they belong to.
select u.name,g.group_name
from `groups` g
join membership m 
on g.group_id=m.group_id
join users u on
u.user_id=m.user_id;

-- common user between two groups 
SELECT u.name
FROM users u
JOIN membership m1 ON u.user_id = m1.user_id AND m1.group_id = 2
JOIN membership m2 ON u.user_id = m2.user_id AND m2.group_id = 3;

-- Calculate the total age of all users in each group.
select g.group_name, sum(u.age) as sum_of_ages
from `groups` g 
join membership m on
g.group_id=m.group_id
join users u on
u.user_id=m.user_id
group by g.group_name;

-- Find the maximum and minimum age of users in each group.
select g.group_name,min(u.age) as min_age,max(u.age) as max_age
from `groups` g 
join membership m on
g.group_id=m.group_id
join users u on
u.user_id=m.user_id
group by g.group_name;

-- Find the names of users who are members of both Group 1 and Group 3 using a subquery factoring.
with grpmembers as (
select user_id from membership where group_id=1),
grp2mem as ( select user_id from membership where group_id=3)
select name from users u
where u.user_id in (SELECT g1.user_id FROM grpmembers g1
INNER JOIN grp2mem g2 ON g1.user_id = g2.user_id);

-- Get the names of users who are not members of any group using a subquery factoring.
WITH GroupMembers AS (
    SELECT user_id FROM membership
)
SELECT name
FROM users
WHERE user_id NOT IN (SELECT user_id FROM GroupMembers);


CREATE VIEW group_total_age AS
SELECT g.group_name, SUM(u.age) AS total_age
FROM `groups` g
JOIN membership m ON g.group_id = m.group_id
JOIN users u ON m.user_id = u.user_id
GROUP BY g.group_name;

-- For each user, find the name, age, and the rank of their 
-- age within their respective groups based on the descending order of age.
select u.name,u.age,g.group_name,
rank() over (partition by g.group_name order by u.age desc) as rnk
from `groups` g 
join membership m on
m.group_id=g.group_id
join users u on
u.user_id=m.user_id;

-- find the top 3 oldest users in each group along with their names and ages.
with cte1 as (select u.name as name,u.age as age ,g.group_name as gname,
row_number() over (partition by g.group_name order by u.age desc) as rnk
from `groups` g 
join membership m on 
m.group_id=g.group_id
join users u on 
u.user_id=m.user_id)
select name,age,gname,rnk from cte1
where rnk <=3;

-- Calculate the average age of users within each group and display the result alongside the user details.

SELECT  g.group_name,u.name,
       AVG(u.age) over(partition by g.group_id)
FROM users u
JOIN membership m ON u.user_id = m.user_id
JOIN `groups` g ON m.group_id = g.group_id;

-- Retrieve the name and age of the youngest user in each group.

with cte1 as (
select u.name as uname,g.group_name as gname,
row_number() over(partition by g.group_name order by u.age asc) as rnk
FROM users u
JOIN membership m ON u.user_id = m.user_id
JOIN `groups` g ON m.group_id = g.group_id)
select uname,gname,rnk 
from cte1 
where rnk=1;




 


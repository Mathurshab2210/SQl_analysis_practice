SELECT * FROM random_tables.ev;
select count(*) from ev;
-- Number of vehicles by make
select make, count(*) as cars_made 
from ev
group by make
order by cars_made desc;

-- Calculate the average electric range of all vehicles:
SELECT AVG(`electric range`) AS average_electric_range
FROM ev;

-- List the vehicles with an electric range greater than 200
select model,`electric range`
from ev
where `electric range`>200;

-- -- Number of BEVs vs PHEVs 
SELECT 
  SUM(CASE WHEN `Electric Vehicle Type` = 'Battery Electric Vehicle (BEV)' THEN 1 ELSE 0 END) AS num_bevs,
  SUM(CASE WHEN `Electric Vehicle Type` = 'Plug-in Hybrid Electric Vehicle (PHEV)' THEN 1 ELSE 0 END) AS num_phevs
FROM ev;

-- Average range of eligible BEVs 
select avg(`electric range`)
from ev
where `Electric Vehicle Type` = 'Battery Electric Vehicle (BEV)' 
and `Clean Alternative Fuel Vehicle (CAFV) Eligibility`='Clean Alternative Fuel Vehicle Eligible';

-- Identify the number of vehicles eligible for Clean Alternative Fuel Vehicle (CAFV) in each state:
select State, count(*) as cnt 
from ev
where `Clean Alternative Fuel Vehicle (CAFV) Eligibility`='Clean Alternative Fuel Vehicle Eligible'
group by State;

-- Find the model and electric range of vehicles located in Seattle, WA:
select model, `electric range`from ev
where state='wa' and city='seattle';

--  Calculate the average electric range for each vehicle type:
select `Electric Vehicle Type`,avg(`electric range`) as avg_rang
from ev 
group by `Electric Vehicle Type`;

-- Determine the average electric range and average base MSRP for each make and model:
select make,model, avg (`electric range`) as avg_range, avg(`Base MSRP`) as avg_msrp
from ev
group by make, model;

-- Rank the cities by the number of vehicles they have, showing the rank, city, state, and vehicle count:
select city,state,count(*) as cnt,
dense_rank() over(order by count(*) desc) as rnk
from ev
group by city,State
order by cnt desc;

-- Calculate the total electric range and average base MSRP for each vehicle type and year:
select `Electric Vehicle Type` as evt , `Model Year` as my,
sum(`electric range`) as sum_rng,
avg(`Base MSRP`) as avg_msrp 
from ev
group by evt,my
order by my desc;

-- List the cities and states where vehicles have an electric range greater than the average electric range:
select city,state,`electric range`
from ev
where `electric range` > (select avg(`electric range`) from ev)
order by `electric range`;

-- Calculate the percentage of total electric range contributed by each vehicle model:
select model,`electric range`,
100*( `electric range`/ sum(`electric range`) over()) as pct  
from ev 
group by model,`electric range`
order by pct desc;

--  Find the top 3 makes with the highest average electric range, and display their models as well:
select make,model, avg(`electric range`) as avg_rng
from ev
group by make,Model
order by avg_rng desc
limit 3;

-- Calculate the average electric range for vehicles eligible for CAFV and those that are not
select `Clean Alternative Fuel Vehicle (CAFV) Eligibility`,
avg(`electric range`) as avg_rng
from ev
group by `Clean Alternative Fuel Vehicle (CAFV) Eligibility`;

-- Find the city and state with the highest total electric range, along with the total range:
select city,state,sum(`electric range`) as tot_range
from ev
group by city,state
order by tot_range desc
limit 1;

-- Find vehicles with the lowest and highest electric range for each make:
select make,
min(`electric range`) as min_rng,
max(`electric range`) as max_rng
from ev
group by make;

-- Create a Common Table Expression (CTE) to calculate the total electric range for each state,
--  and then find the state with the highest total range:
with cte1 as (
select state,sum(`electric range`) as tot
from ev 
group by state)
select * from cte1
order by tot desc
limit 1;

-- dentify and count duplicate vehicle entries based on their make, model, and year:
select make,model,`model year`, count(*) as cnt 
from ev 
group by make,Model,`Model Year`
having cnt>1
order by cnt;

-- Rank cities based on their total electric range, and calculate the percentile rank of each city's electric range:
Select city,state,SUM(`electric range`) AS total_electric_range,
       RANK() OVER (ORDER BY SUM(`electric range`) DESC) AS rnk,
       PERCENT_RANK() OVER (ORDER BY SUM(`electric range`)) AS percentile_rank
FROM ev
GROUP BY city, state
ORDER BY total_electric_range DESC;

-- Percentage of vehicles eligible for CAFV rebate by make:
select make,
	100*(sum(case when `Clean Alternative Fuel Vehicle (CAFV) Eligibility`='Clean Alternative Fuel Vehicle Eligible' then 1 else 0 end )/count(*)) as pct
    from ev
    group by make
    order by pct desc;
    
--  Rank makes by average electric range:
select make, avg(`electric range`) as avg_rng,
rank() over(order by avg(`electric range`)) as rnk
from ev
group by make;

-- Flag vehicles with electric range higher than make average:
with cte1 as (
select make,
avg(`electric range`) as avg_range
from ev
group by make
)
select c.make,
case when (`electric range` > avg_range) then "above avg"
else "below avg"
end as 'flag',avg_range
from cte1 c
join ev e
on c.make=e.make;



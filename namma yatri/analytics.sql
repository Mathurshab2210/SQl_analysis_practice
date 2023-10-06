-- Analysis For nama yatri
-- 1 Total Trips
select count(*) as tot_trip from trip_details;
 -- check for duplicate
 select tripid,count(tripid) as cnt from trip_details
 group by tripid
 having cnt>1;
 
 -- total drivers
 select count(distinct driverid) as total_drivers from trips;
 
 -- total earnings
 select sum(fare) as
 tota_earnings from trips;
 
 -- total completed trips
 select count(*) from trip_details
 where end_ride=1;

-- total searches took place
select count( searches) as total_searches from trip_details;

-- total searces got estimated
select count(searches_got_estimate) from trip_details
where searches_got_estimate=1;

-- total search for quotes
select sum(searches_for_quotes) from trip_details;

-- total number of trips cancelled by driver
select count(driver_not_cancelled) from trip_details
where driver_not_cancelled =0;

-- total otp entered
select sum(otp_entered) from trip_details;

-- end ride total

select sum(end_ride) from trip_details;

-- average distance per trip
select avg(distance) as avg_distance from trips;

-- avg fare per trip
select avg(fare) as avg_fare
 from trips;
 
 -- total distance traveeled
 select sum(distance) as tot_distance from trips;
 
 
-- which is the most used payment method
select p.method, count(*) as cnt
from trips t join  payments p 
on t.faremethod=p.id
group by p.method
order by cnt desc
limit 1;

-- the highest payment thorugh whcih instrument

select p.method,fare from trips t
join payments p 
on 
p.id=t.faremethod
where fare=(select max(fare) from trips);

select p.method,sum(fare) as sum_fare 
from trips t 
join payments p 
on p.id=t.faremethod
group by p.method
order by sum(fare) desc 
limit 1;


-- which two location has the most number of trips

with cte1 as (select loc_from, loc_to ,count(tripid) as cnt from trips
group by loc_from,loc_to
order by cnt  desc
) , cte2 as(select *, dense_rank() over (order by cnt desc) rnk from cte1)
select * from cte2 where rnk=1;


-- top 5 earning drivers
select driverid,sum(fare) as driver_income from trips
group by  driverid
order by driver_income desc
limit 5;


-- which duration hs more trips

with cte1 as (select duration, count(distinct tripid) cnt from trips
group by duration 
order by cnt desc),cte2 as ( select *, dense_rank() over(order by cnt desc) as rnk from cte1)
select * from cte2 where rnk=1;

-- which driver customer pair has more orders

with cte1 as (select driverid,custid,count(distinct tripid) cnt from trips
group by driverid,custid
order by cnt desc) , cte2 as( select * , dense_rank() over (order by cnt desc) rnk from cte1)
select * from cte2 where rnk=1;


-- search to estimate rate
select sum(searches_got_estimate)/sum(searches)*100 as search_to_estimate_rate from trip_details;

-- which area got higjest trip in which duration
with cte1 as (select  duration,loc_from, count(distinct tripid) cnt from trips
group by duration,loc_from
order by cnt desc) ,cte2 as (select *, rank() over (partition by duration order by cnt desc) rnk from cte1)select * from cte2 where rnk =1;


with cte1 as (select loc_from,duration, count(distinct tripid) cnt from trips
group by loc_from,duration
order by cnt desc) ,cte2 as (select *, rank() over (partition by loc_from order by cnt desc) rnk from cte1)select * from cte2 where rnk =1;


-- area wise fare cnacellation and trips 

with cte1 as (select loc_from,sum(fare) as total_fare from trips group by loc_from ),  cte2 as (
select * , rank () over (order by total_fare desc) rnk from cte1)select * from cte2 where rnk=1;

with cte1 as(select loc_from,count(*)-sum(driver_not_cancelled) as can  from trip_details group by loc_from),
cte2 as (select *, rank() over(order by can desc) rnk from cte1) select * from cte2  where rnk=1;

with cte1 as(select loc_from,count(*)-sum(customer_not_cancelled) as can  from trip_details group by loc_from),
cte2 as (select *, rank() over(order by can desc) rnk from cte1) select * from cte2  where rnk=1;


-- which duration got the highest trips and fare
with cte1 as (select duration , count(distinct tripid) cnt,sum(fare) sf from trips
group by duration ),cte2 as (select * ,rank() over(order by cnt ,sf desc) rnk  from cte1) select * from cte2 where rnk=1
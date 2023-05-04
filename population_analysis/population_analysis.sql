select  * from d1;
select * from d2;
# number of rows in data
select count(*) from d1;
select count(*) from d2;

-- dataset fro jharkhand and bihar
select * from d1
where state in('jharkhand','bihar');

-- population of india
select sum(population) as total_population_india
from d2;
-- average grwoth rate
select avg(growth) as avg_growth_rate
from d1;
-- state wise growth rate
select state, avg(growth) as gr
from d1
group by state
order by gr desc
limit 3;

-- avg sex ratio state wise
select state, avg(Sex_Ratio) as sr 
from d1 
group by State
order by sr desc ;

-- literacy ratio
select state, avg(Literacy) as lr
from d1 
group by State
having lr >90
order by lr desc;
-- avg sex ratio state wise find lowest three
select state, avg(Sex_Ratio) as sr 
from d1 
group by State
order by sr 
limit 3 ;

-- top 3 and bottom 3 states in literacy rates
select * from(select state, avg(Literacy) as lr
from d1 
group by State
order by lr desc limit 3) a
union
select * from (
select state, avg(Literacy) as lr
from d1 
group by State
order by lr
limit 3) b
;
-- states starting with letter a 
select distinct state from d1 
where state like "A%";

-- starting with a and ending with d
 select distinct state from d1 
 where state like "a%d";
 
 -- number of males and females 
 -- m+f=p
 -- f/m= sex_ratio
 -- m=
 with cte1 as (select d1.District ,d1.state,d1.Sex_Ratio/1000 ,d2.Population, 
 round(d2.Population/((d1.sex_ratio/1000)+1),0) as males,
 round(d2.Population -  round(d2.Population/((d1.sex_ratio/1000)+1),0),0) as females
 from d1
 join d2
 on d1.District=d2.District)
 select state , sum(males) as tot_m, sum(females) as tot_f
 from cte1
 group by state;
 
 -- total literate 
 with cte1 as (select d1.District ,d1.state,d2.Population,d1.Literacy/100 as literacy_rate,
 round(((d1.literacy/100)*d2.population),0) as literate_people
 from d1
 join d2
 on d1.District=d2.District)
 select state, sum(literate_people) as tot_lp
 from cte1 
 group by state
 order by state ;
 
 -- previous census population 
 -- prev+gr*prev=pop
 -- prev =pop/(gr+1)
 
 with cte1 as (select d1.District,d1.state,d1.Growth/100 as gr,d2.Population
 from d1
 join d2 on
 d1.District=d2.District), cte2 as(
 select *, (1+gr) as cont
 from cte1),cte3 as (
 select *, round((population/cont),0)as prev from cte2)
 select state,sum(prev) as prev_population from cte3
 group by state
 order by state
 ;
 select o.tot_ar/o.current, o.tot_ar/o.prev_population from
 (select q.*,r.tot_ar from(
 select '1' as keyy,m.* from (select * from population_tab) m) q inner join 
 (select '1' as keyy,n.* from (select sum(Area_km2) as tot_ar from d2) n) r
 on 
 q.keyy=r.keyy) o;
 
 --  top three districts with highest literacy rate from each state
 select a.District,a.literacy,a.rnk from( select state,district,literacy,
 rank() over(partition by state  order by literacy desc) as rnk
 from d1) a where a.rnk in(1,2,3)
 

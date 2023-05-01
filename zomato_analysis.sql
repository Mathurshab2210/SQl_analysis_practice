select * from product;
select * from  goldusers_signup;
select * from sales;
select * from users;
show tables;

-- total amount spent by customer
select sum(p.price) as amt_spent, s.userid
from sales s 
join product p
on s.product_id=p.product_id
group by s.userid;
-- how many days user visited zomato
select userid,count(distinct(created_date)) as num_days 
from sales
group by userid;

-- what was the first product purchased by each customer
 with cte1 as 
 (select *,
rank() over(partition by userid order by created_date) as rnk
from sales)
select userid,product_id from cte1 where rnk=1;

-- most purchased item and how many times it was purchased by all the customers
select product_id,count(product_id) as prch_cnt 
from sales
group by product_id
order by prch_cnt desc
limit 1;
select userid,count(product_id) from sales where product_id=2 group by userid;

-- favourite item of customer
 with cte1 as (
	select userid,product_id,count(product_id) as cnt from sales group by userid,product_id
) ,
cte2 as (select * ,
	rank() over(partition by userid order by cnt desc) as rnk
    from cte1
    )
    select userid,product_id,cnt 
		from cte2 
		where rnk=1
        order by cnt;

-- which item was purchased by customer after they become member
 with cte1 as (
	select s.userid,s.product_id,s.created_date,g.gold_signup_date
	from sales s
    join goldusers_signup g 
    on s.userid=g.userid 
    and s.created_date >  g.gold_signup_date
    ),
    cte2 as (
    select *,
     rank() over (partition by s.userid order by s.created_date) as rnk
     from cte1
     )
     select * from cte2 where rnk=1;
     
-- which item was purchased by customer just before they become member
 with cte1 as (
	select s.userid,s.product_id,s.created_date,g.gold_signup_date
	from sales s
    join goldusers_signup g 
    on s.userid=g.userid 
    and s.created_date <= g.gold_signup_date
    ),
    cte2 as (
    select *,
     rank() over (partition by s.userid order by s.created_date desc) as rnk
     from cte1
     )
     select * from cte2 where rnk=1;
     
-- what is total order and money spent just before the become gold members
-- i have used view here
select j.userid,count(j.product_id),
sum(p.price) as amt
from just_befor_gold j 
join product p
on p.product_id=j.product_id
group by j.userid;

-- If buying each product generates points for eg 5rs-2 zomato point and each product has different purchasing points
-- for eg for pl 5rs-1 zomato point, for p2 10rs=5zomato point and p3 5rs-1 zomato point
with cte1 as (select s.userid,s.product_id,p.price
	from sales s 
    join product p
    on s.product_id=p.product_id
    ), cte2 as(
    select userid,product_id,sum(price) as tot_amt from cte1 
		group by userid,product_id
        order by userid),cte3 as(
	 select *,
     case 
     when product_id=1 then 5
	 when product_id=2 then 2
	 when product_id=3 then 5
     else 0
     end as pt
     from cte2
      ) , cte4 as(select *,(tot_amt/pt) as zomato_points
		from cte3)
        select userid,sum(zomato_points) as tot_zp,
			sum(zomato_points)*2.5 as cashback
        from cte4
        group by userid;
        
with cte1 as (select s.userid,s.product_id,p.price
	from sales s 
    join product p
    on s.product_id=p.product_id
    ), cte2 as(
    select userid,product_id,sum(price) as tot_amt from cte1 
		group by userid,product_id
        order by userid),cte3 as(
	 select *,
     case 
     when product_id=1 then 5
	 when product_id=2 then 2
	 when product_id=3 then 5
     else 0
     end as pt
     from cte2
      ) , cte4 as(select *,(tot_amt/pt) as zomato_points
		from cte3)
        select product_id,sum(zomato_points) as tot_zp_pr
        from cte4
        group by product_id;
       

-- 10 In the first one year after a customer joins the gold program (including their join date) irrespective
-- of what the customer has purchased they earn 5 zomato points for every 10 rs spent who earned more more 1 or 3
-- and what was their points earnings in thier first yr?

with cte1 as (select s.userid,s.product_id,s.created_date,g.gold_signup_date
	from sales s
    join goldusers_signup g 
    on s.userid=g.userid 
    and s.created_date >= g.gold_signup_date
    and s.created_date <= DATE_ADD(g.gold_signup_date,interval 1 year))
    select cte1.*,p.price,
    round((p.price/2),2) as points -- 5rs=10pt therefore 1rs=2pt
    from cte1 
    join product p
    on cte1.product_id=p.product_id;
    
-- rank all the transactions of customers
select *,
rank() over(partition by userid order by created_date) as rnk
from sales;

-- rank all the transaction for each memeber whenever they are a zomato gold member
-- for every non gold member mark transaction na
with cte1 as (select s.userid,s.product_id,s.created_date,g.gold_signup_date
	from sales s
    left join goldusers_signup g 
    on s.userid=g.userid 
    and s.created_date >= g.gold_signup_date
    ), cte2 as (
    select cte1.*,
    case 
    when gold_signup_date is null 
    then 0
    else
    rank() over(partition by userid order by created_date desc) 
    end  as rnk
    from cte1
    )
    select cte2.*,
    case 
    when gold_signup_date is null then
     "na"
	else
    cte2.rnk
    end as rnnk
    from cte2
    
    

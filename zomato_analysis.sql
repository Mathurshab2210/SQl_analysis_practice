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
     

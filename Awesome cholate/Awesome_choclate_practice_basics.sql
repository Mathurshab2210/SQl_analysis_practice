select * from sales;
select SaleDate,Amount,Boxes,
	Amount/Boxes as amt_pr_box
    from sales;
    
-- amount is in dollars-

select * from sales
where Amount >=10000
order by Amount asc;

select GeoID,PID,sum(Amount) from sales 
where GeoID='g1'
group by PID
order by PID;

-- amount>10000 and year =2022
with cte1 as (select *,
extract(YEAR from SaleDate) as yr
 from
 sales)
 select * from cte1 
 where Amount>=10000 and yr=2022;
 -- or 
 select * from 
 sales 
 where 
 Amount>10000 and SaleDate>='2022-01-01';
 
 select year(SaleDate) from sales;
 
 -- number of boxes 0 to 50
 
 select * from sales 
 where boxes between 0 and 50
 order by boxes asc;
 
 -- get week days
 select SaleDate,Amount,Boxes,weekday(SaleDate) as dw
 from sales
 having dw=4 ;
 
 -- people from dlish or jucies
 
 select Salesperson, team from people
 where team in ('delish','jucies');
 
 -- categorizing data
 select * ,
	case when Amount<1000 then "Under 1k"
         when Amount<5000 then "under 5k"
		 when Amount<10000 then "under 10k"
         else "hoga yar 10k sey jyada"
	end as Category
    from sales;
    
    
-- exploring datasets
show tables;
select * from geo;
select * from people;
select * from products;
select * from sales;
-- exploring geo table:
select distinct(geo) from geo;
select distinct(region) from geo;
-- exploring people:
SHOW COLUMNS FROM people;
select count(*) from people;
select distinct(team) from people;
select distinct(location) from people;
select distinct(Salesperson) from people;
select count(distinct(spid)) from people;
-- exploring products:
Show columns from products;
select max(Cost_per_box) as max_size,avg(Cost_per_box) as avg_size,min(Cost_per_box) as min_size from products;
-- exploring sales:
show columns from sales;
-- getting info from data:
-- Find the sales amount and the total number of boxes sold by each salesperson
SELECT spid, SUM(amount) AS total_sales_amount, SUM(boxes) AS total_boxes_sold
FROM sales
GROUP BY spid;
-- Calculate the total sales amount and the average sales amount for each product:
SELECT pid, SUM(amount) AS total_sales_amount, AVG(amount) AS avg_sales_amount
FROM sales
GROUP BY pid
order by pid;

-- Retrieve the sales amount, customer count, and average sales amount for each product category:
SELECT p.category, SUM(amount) AS total_sales_amount, COUNT(DISTINCT customers) AS customer_count, AVG(amount) AS avg_sales_amount
FROM sales s
JOIN products p ON s.pid = p.pid
GROUP BY p.category;

-- Find the salesperson and the total sales amount for each location:
SELECT pe.salesperson, pe.location, SUM(sa.amount) AS total_sales_amount
FROM sales sa
JOIN people pe ON pe.spid = sa.spid
GROUP BY pe.salesperson, pe.location;

-- Get the sales amount and the total number of boxes sold for each product category and region
SELECT p.category, g.Region, SUM(sa.amount) AS total_sales_amount, SUM(sa.boxes) AS total_boxes_sold
FROM sales sa
JOIN products p ON sa.pid = p.pid
JOIN geo g ON sa.geoid = g.Geoid
GROUP BY p.category, g.Region;
-- Retrieve the products that have not been sold yet:
SELECT p.*
FROM products p
LEFT JOIN sales s ON p.pid = s.pid
WHERE s.pid="";

--  Find the number of sales records for each product category from the "sales" and "products" tables.
SELECT p.category, COUNT(s.pid) AS num_sales_records
FROM sales s
JOIN products p ON s.pid = p.pid
GROUP BY p.category;

-- Get the total number of sales and the average amount for each salesperson in each team.
select p.salesperson,p.team,count(s.amount) as total_sales,avg(s.amount) as avg_sale
from sales s
join people p 
on s.SPID=p.SPID
group by p.Team,p.Salesperson;

-- find sales records where the amount is greater than the average amount of all sales from the "sales" table.
select amount 
from sales where amount >(select avg(amount) from sales);

-- Get salespeople from the "people" table who belong to a team with members from the 'Americas' region.


select * from people 
where team in  (select team from geo where region like "%america%");
-- another way using joins
select p.salesperson,g.region,p.Team,p.location from people p
join sales s on s.SPID=p.SPID
join geo g 
on g.GeoID=s.GeoID
where g.region like "%americas%";

-- Display products from the "products" table with a cost per box less than the average cost per box of all products
select product,cost_per_box from products
where Cost_per_box<(select avg(Cost_per_box) from products);

-- Calculate the total sales amount for each salesperson and display only those with a total amount greater than 10000
select p.salesperson,sum(s.amount) as tot_indi_sales from sales s
join people p 
on s.SPID=p.SPID
group by p.Salesperson
having tot_indi_sales>10000;

-- Find the number of sales records for each product category and show only those with more than 5 sales records.
select pr.category,count(s.pid) as sales_record
from products pr 
join sales s 
on pr.PID=s.PID
group by pr.Category
having sales_record>5;

-- Find the salesperson(s) who made the maximum sales (amount) in the "sales" table
select p.salesperson,s.amount
from sales s 
join people p on
s.SPID=p.SPID
where s.amount=(select max(Amount) from sales);

-- Retrieve products and their total number of sales records from the "products" table, ordered by the number of sales records in descending order
select pr.product,pr.category,count(s.pid) as cnt from 
products pr
join sales s 
on pr.pid=s.pid
group by pr.Product,pr.Category
order by cnt desc;

-- Find sales records in the "sales" table where the product sold exists in the "products" table.
 select s.pid from sales s 
 where exists(select 1 from products p where p.PID=s.PID);
 
 -- Get sales records in the "sales" table where the product sold does not exist in the "products" table.
  select s.pid from sales s 
 where not exists(select 1 from products p where p.PID=s.PID);
 
 -- Calculate the total sales amount for each salesperson and product combination in the "sales" table.
 select p.salesperson,pr.product,sum(s.amount) as total 
 from people p
 join sales s 
 on p.spid=s.SPID
 join products pr 
 on s.pid=pr.pid
 group by p.Salesperson,pr.product
 order by  p.salesperson,total;
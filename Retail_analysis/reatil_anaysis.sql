## **SQL Queries and Insights**

### **Q1. Total revenue generated by each product category**  

select category, sum(total_sale) as revenue from retail_analysis.retail_data group by category order by revenue desc;

### **Q2. Top 5 customers contributing the most to sales**  

Select customer_id , sum(total_sale) as rev from retail_analysis.retail_data group by customer_id order by rev desc limit 5;
-- Q2.a top customer in each category 
select category ,customer_id ,sum(total_sale) ,rank() over(partition by category order by  sum(total_sale) desc) as rn from retail_analysis.retail_data group by category,customer_id
;
### **Q3. Which gender contributes the most to sales revenue?**  
-- cte / subquery / window function
SELECT gender, SUM(total_sale) AS total_sales  FROM retail_analysis.retail_data GROUP BY gender ORDER BY total_sales DESC;
### **Q4. Age distribution of customers purchasing products**  
 select age,count(distinct customer_id) unique_customer,sum(total_sale -cogs) as rev from retail_analysis.retail_data group by age order by rev,unique_customer desc;
## revenue = toatl_sale - cogs 

### **Q5. Seasonal trends or patterns in sales based on sale dates**   -- homework 

### **Q6. Most profitable product category in terms of revenue and COGS**  
select distinct category ,count(distinct customer_id) unique_customer, Round(sum(total_sale - cogs),2) as rev from retail_analysis.retail_data
 group by category order by rev desc;

### **Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**  
select year,month,avg_sale 
from 
(
select year(sale_date) as year ,
month(sale_date) as month ,
avg(total_sale) as avg_sale,
Rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rn 
from retail_analysis.retail_data
group by year,month
) as t1
where rn = 1;

### **Q8. Top 5 customers based on the highest total sales**   -- homework


### **Q9. Number of unique customers who purchased items from each category**  


### **Q10. Create shifts and calculate the number of orders for each shift**  

-- morning
-- evening 
-- afternoon 

select 
case 
when hour(sale_time) < 12 then 'morning'
when hour(sale_time) between 12 and 15 then  'afternoon'
else 'evening'
end as shift ,
count(*) as tot_orders
from retail_analysis.retail_data 
group by shift



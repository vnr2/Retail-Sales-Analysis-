-- # Data Exploration & Cata Cleaning

-- 1) Determining the total number of records in the dataset
select count(*)
from retail_sales;

--2) Determining number of unique customers that are in dataset
select count(distinct customer_id)
from retail_sales

--3) Identifying all unique product categories in the dataset
select distinct category
from retail_sales;

--4) Checking if there are any null values in the dataset
select * from retail_sales
where sale_date is null;

select * from retail_sales
where sale_time is null;

select * from retail_sales
where customer_id is null;

select * from retail_sales
where gender is null;

select * from retail_sales
where age is null;

select * from retail_sales
where category is null;

select * from retail_sales
where quantiy is null;

select * from retail_sales
where price_per_unit is null;

select * from retail_sales
where cogs is null;


--5) Deleting all records with missing data
delete from retail_sales
where sale_date is null;

delete from retail_sales
where sale_time is null;

delete from retail_sales
where customer_id is null;

delete from retail_sales
where gender is null;

delete from retail_sales
where age is null;

delete from retail_sales
where category is null;

delete from retail_sales
where quantiy is null;

delete from retail_sales
where price_per_unit is null;

delete from retail_sales
where cogs is null;

-- # Data Analysis & Findings

-- a) SQL query to retrieve all columns for sales made on '2022-11-05'

select * from retail_sales
where sale_date = '2022-11-05';

-- b) Sql Query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022

select * from retail_sales
where category = 'Clothing' and to_char(sale_date, 'YYYY-MM') = '2022-11'
and quantiy >= 4;

-- c) SQL query to calculate the total sales for each category

select category, sum(total_sale) as net_sale, count(*) as total_orders
from retail_sales
group by 1;

-- d) Sql query to find the average age of customers who purchased items from the 'Beauty' category

select round(avg(age), 2) as avg_age
from retail_sales
where category = 'Beauty';

-- e) Sql query to find all transactions where the total_sale is greater than 1000;

select * from retail_sales
where total_sale > 1000;

--f) Sql query to find total number of transactions(transaction_id) made ny each gender in each category

select category, gender, count(*) as total_transactions
from retail_sales
group by category, gender
order by 1;

--g) Sql query to calculate the average sale for each month.Find out the best selling month in each year

select year, month, avg_sale
from (select extract(year from sale_date) as year,
	  extract(month from sale_date) as month,
	  avg(total_sale) as avg_sale,
	  rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as Rank
from retail_sales
group by 1, 2
) as t1
where Rank = 1;

--h) SQl query to find the Top 5 customers based in the highest total sales

select customer_id, sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

--i) SQL query to create each shift and number of orders(Example Morning <12, Afternoon Between 12 & 17, Evening>17)

With hourly_sale
as
(
select *,
	case
		when extract(hour from sale_time)<12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
	from retail_sales
)
select shift, count(*) as total_orders
from hourly_sale
group by shift
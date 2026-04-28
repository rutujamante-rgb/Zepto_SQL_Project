create database Zepto_project;
use Zepto_project;
create table zepto(
				  category varchar(120),
                  name varchar(120) not null,
                  mrp float,
                  discountpercent float,
                  availablequantity int,
                  discountsellingprice float,
                  weightingms int,
                  outofstock boolean,
                  quantity int);
                  -- data exploration
                  
                  -- count of rows
                  select count(*) from zepto;
                  -- add column
                  Alter Table Zepto add column sku_id int auto_increment primary key first;
                  -- Sample data
                  select * from zepto limit 10;
                  -- null values
                  select * from zepto 
                  where name is null
                  or 
                   category is null
                  or 
                   mrp is null
                  or 
                  discountpercent is null
                  or 
                  discountsellingprice is null
                  or
                  weightingms is null
                  or
                   availablequantity is null
                  or
				outofstock is null 
                 or 
                  quantity is null;
                  
                  -- different product categories
                  select distinct category 
                  from zepto
                  order by category ;
                   -- products in stock vs out of stock
                   select outofstock,count(sku_id)
                   from zepto
                   group by outofstock;
                   
                   -- product names present multiple times
                   select name ,count(sku_id) as "number of skus"
                   from zepto
                   group by name
                   having count(sku_id)>1
                   order by count(sku_id) desc;
                   
                   -- data cleaning
                    -- products with price =0
                    select * 
                    from zepto
                    where mrp=0 or discountsellingprice=0;
                    
                    delete from zepto
                    where mrp=0;
                    set sql_safe_updates=0;
                    
                    -- convert paise to rupees
                    update zepto
                    set mrp=mrp/100.0,
                    discountsellingprice=discountsellingprice/100.0;
                    select mrp,discountsellingprice from zepto;
                    
                   -- Q1. Find the top 10 best-value products based on the discount percentage.
                   select distinct name,mrp,discountpercent 
                   from zepto 
                   order by discountpercent desc
                   limit 10;
                    
-- Q2.What are the Products with High MRP but Out of Stock
select distinct name ,mrp
from zepto
where outofstock=1 and mrp >300
order by mrp desc;

-- Q3.Calculate Estimated Revenue for each category
select category ,sum(discountsellingprice*availablequantity) as total_revenue 
from zepto
group by category
order by total_revenue;

-- Q4. Find all products where MRP is greater than <500 and discount is less than 10%.
select distinct name,mrp,discountpercent 
from zepto
where mrp>500 and discountpercent <10
order by mrp desc,discountpercent desc;
-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category,round(avg(discountpercent) ,2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;


-- Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name,weightingms,discountsellingprice,
round(discountsellingprice/weightingms,2) as pricepergms
from zepto
where weightingms>=100
order by pricepergms;
-- Q7.Group the products into categories like Low, Medium, Bulk.
select distinct name,weightingms,
case when weightingms<1000 then 'low'
     when weightingms <5000 then 'medium'
     else 'bulk'
     end as weight_category
     from zepto;
-- Q8.What is the Total Inventory weight Per Category
select category,
sum(weightingms*availablequantity) as total_weight
from zepto
group by category
order by total_weight;
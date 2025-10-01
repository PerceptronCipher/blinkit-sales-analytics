-- create database 
create database blinkit

-- create table
create table BlinkIT("Item Fat Content" varchar,
	"Item Identifier" varchar,
	"Item Type" varchar,
	"Outlet Establishment Year" int,
	"Outlet Identifier" varchar,
	"Outlet Location Type" varchar,
	"Outlet Size" varchar,
	"Outlet Type" varchar,
	"Item Visibility" decimal,
	"Item Weight" decimal,
	Sales decimal,
	Rating decimal)

-- Inspect table
select * from BlinkIT

import from file
	copy BlinkIT from 'C:\Program Files\PostgreSQL\Datasets\BlinkIT.csv'csv header

-- Rows Validation 
select count(*) from blinkit /* 12 columns * 8523 rows */


-- Column stats for first column 
select distinct "Item Fat Content" from blinkit

-- Standardizize Item_Fat_Content Values
update blinkit 
	set "Item Fat Content" = case 
	when lower("Item Fat Content") in ('low fat', 'lf') then 'Low fat'
	when lower("Item Fat Content") in ('regular', 'reg') then 'Regular'
	else "Item Fat Content"
	end /* file saved in path */

-- Column stats for second column 
select distinct "Item Identifier" from blinkit /* distinct about 1559 */ 

-- Column stats for third column 
select distinct "Item Type" from blinkit /* distinct about 16 */ 

-- Column stats for fourth column 
select distinct "Outlet Establishment Year" from blinkit /* 2011-2022 */

-- Column stats for fifth column 
select distinct "Outlet Identifier" from blinkit /* 10 distinct */

-- Column stats for sixth column 
select distinct "Outlet Location Type" from blinkit /* 3 tiers */

-- Column stats for seventh column 
select distinct "Outlet Size" from blinkit /* 3 size */

-- Column stats for eight column 
select distinct "Outlet Type" from blinkit /* 4 distinct groups */

-- Column stats for ninth column 
select distinct "Item Visibility" from blinkit /* 7880 distinct */

-- Column stats for tenth column 
select distinct "Item Weight" from blinkit /* 416 distinct */

-- Column stats for eleventh column 
select distinct Sales from blinkit /* 5938 distinct */

-- Column stats for twelveth column 
select distinct Rating from blinkit /* 39 distinct */

-- Check for nulls
select exists (
  select 1 from blinkit
  where "Item Fat Content" is null
     or "Item Identifier" is null
     or "Item Type" is null
     or "Outlet Establishment Year" is null
     or "Outlet Identifier" is null
     or "Outlet Location Type" is null
     or "Outlet Size" is null
     or "Outlet Type" is null
     or "Item Visibility" is null
     or "Item Weight" is null
     or Sales is null
     or Rating is null) as has_nulls

-- count nulls per column
select 
    count(*) filter (where "Item Fat Content" is null) as null_item_fat_content,
    count(*) filter (where "Item Identifier" is null) as null_item_identifier,
    count(*) filter (where "Item Type" is null) as null_item_type,
    count(*) filter (where "Outlet Establishment Year" is null) as null_outlet_establishment_year,
    count(*) filter (where "Outlet Identifier" is null) as null_outlet_identifier,
    count(*) filter (where "Outlet Location Type" is null) as null_outlet_location_type,
    count(*) filter (where "Outlet Size" is null) as null_outlet_size,
    count(*) filter (where "Outlet Type" is null) as null_outlet_type,
    count(*) filter (where "Item Visibility" is null) as null_item_visibility,
    count(*) filter (where "Item Weight" is null) as null_item_weight, /* 1463 total nulls here */
    count(*) filter (where Sales is null) as null_sales,
    count(*) filter (where Rating is null) as null_rating from blinkit 

-- Inspect data 
select * from blinkit

-- Check which outlet type(s) have null item weight
select "Outlet Type", count(*) as null_count from blinkit where "Item Weight" is null 
group by "Outlet Type"

-- fill null item weight with outlet-type avg and if outlet-type avg is null then global avg 
update blinkit b
set "Item Weight" = coalesce(sub.avg_weight, global.avg_weight)
from (select "Outlet Type", avg("Item Weight") as avg_weight
    from blinkit group by "Outlet Type") 
	sub,
(select avg("Item Weight") as avg_weight 
	from blinkit) global where b."Item Weight" is null and b."Outlet Type" = sub."Outlet Type"

-- Re-check nulls in item weight
select count(*) as nulls_left from blinkit where "Item Weight" is null


-- kpi 1: total sales by item fat content
select "Item Fat Content", sum(sales) as total_sales from blinkit 
group by "Item Fat Content" order by total_sales desc
 
-- kpi 2: total sales by item type
select "Item Type", sum(sales) as total_sales from blinkit
group by "Item Type" order by total_sales desc

-- kpi 3: total sales by fat content across outlets
select "Outlet Identifier", "Item Fat Content", sum(sales) as total_sales
from blinkit group by "Outlet Identifier", "Item Fat Content" 
order by "Outlet Identifier", total_sales desc

-- kpi 4: total sales by outlet establishment year
select "Outlet Establishment Year", sum(sales) as total_salesn from blinkit
group by "Outlet Establishment Year" order by "Outlet Establishment Year"

-- kpi 5: total sales by outlet size 
select "Outlet Size", sum(sales) as total_sales from blinkit
group by "Outlet Size" order by total_sales desc

-- kpi 6: total sales by outlet location type
select "Outlet Location Type", sum(sales) as total_sales from blinkit
group by "Outlet Location Type" order by total_sales desc

-- kpi 7: descriptive stats of sales by outlet type
select "Outlet Type",
       count(*) as total_rows,
       sum(sales) as total_sales,
       avg(sales) as avg_sales,
       min(sales) as min_sales,
       max(sales) as max_sales,
       stddev(sales) as stddev_sales,
       percentile_cont(0.5) within group (order by sales) as median_sales
from blinkit group by "Outlet Type" order by total_sales desc

-- kpi 8: sales ranking by outlet with running total
select "Outlet Identifier",
       "Outlet Type",
       sum(sales) as total_sales,
       rank() over (order by sum(sales) desc) as sales_rank,
       dense_rank() over (order by sum(sales) desc) as dense_sales_rank,
       sum(sum(sales)) over (order by sum(sales) desc) as running_total_sales
from blinkit group by "Outlet Identifier", "Outlet Type" order by sales_rank

-- kpi 9: top 3 performing items per outlet type using window function
select * from (
    select "Outlet Type",
           "Item Type",
           sum(sales) as total_sales,
           rank() over (partition by "Outlet Type" order by sum(sales) desc) as rank_per_outlet_type,
           round(avg(rating), 2) as avg_rating
    from blinkit group by "Outlet Type", "Item Type") ranked
where rank_per_outlet_type <= 3 order by "Outlet Type", rank_per_outlet_type

-- kpi 10: sales performance vs outlet average using window function
select "Outlet Identifier",
       "Item Type",
       sum(sales) as item_sales,
       avg(sum(sales)) over (partition by "Outlet Identifier") as outlet_avg_sales,
       sum(sales) - avg(sum(sales)) over (partition by "Outlet Identifier") as diff_from_avg
from blinkit group by "Outlet Identifier", "Item Type" order by "Outlet Identifier", item_sales desc

-- export cleaned blinkit table to CSV and Load to Python for Statistical computations
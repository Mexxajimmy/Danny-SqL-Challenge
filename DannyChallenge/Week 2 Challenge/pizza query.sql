use pizza_runner
-- for the null and blank values in the exclusions column
UPDATE customer_orders
SET exclusions = CASE WHEN exclusions = '' THEN NULL 
                 WHEN exclusions = 'null' THEN NULL 
                 ELSE exclusions END;

-- for the null and blank values in the extras column
UPDATE customer_orders
SET extras = CASE WHEN extras = '' THEN NULL 
             WHEN extras = 'null' THEN NULL 
             ELSE extras END;

UPDATE runner_orders
SET pickup_time = CASE WHEN pickup_time = 'null' THEN NULL 
                  ELSE pickup_time END;
                    
UPDATE runner_orders
SET distance = CASE WHEN distance = 'null' THEN NULL 
               WHEN distance LIKE '%km' THEN 
                  TRIM(REPLACE(distance, 'km', '')) ELSE distance END;
            
UPDATE runner_orders
SET duration = CASE WHEN duration LIKE '%min%' THEN LEFT(duration, 2) 
               WHEN duration = 'null' THEN NULL 
               ELSE duration END ;
            
UPDATE runner_orders
SET cancellation = CASE WHEN cancellation IN ('null', '') THEN NULL 
                   ELSE cancellation END; 
Describe runner_orders
--to change data type of columns
ALTER TABLE runner_orders
Alter COLUMN distance float;
select *
from pizza_recipes
alter table runner_orders
alter column pickup_time datetime
ALTER TABLE runner_orders
Alter COLUMN duration INT;

--A. Pizza Metrics
--1.	How many pizzas were ordered?
select top 1 *
from customer_orders
select  *
from runners
select top 1 *
from runner_orders
select top 1 *
from pizza_toppings
select top 1 *
from pizza_names
select top 1 *
from pizza_recipes;
select COUNT(pizza_id) as no_of_pizza_ordered
from customer_orders;
14 pizzas were ordered.

--2.	How many unique customer orders were made?
select count(distinct(order_id)) as unique_order
from customer_orders
10 unique orders were made.

--3.	How many successful orders were delivered by each runner?
select runner_id,count(order_id) as successful_order
from runner_orders
where cancellation is null 
group by runner_id;
8 successful orders where made.
runner_id 1 had 4 successful orders, runner_id 2 had 3 successful orders and runner_id 3 had 1 successful order.

--4.	How many of each type of pizza was delivered?
select count(co.pizza_id) as pizza_delivered,pn.pizza_id
from customer_orders co
join pizza_names pn
on co.pizza_id = pn.pizza_id
join runner_orders ro
on co.order_id =ro.order_id
where cancellation is null 
group by pn.pizza_id
--5.	How many Vegetarian and Meatlovers were ordered by each customer?
select customer_id, count(case when pn.pizza_name  = 'meatlover' 
                         then pizza_name end) as count_of_meatlover,
				     count(case when pn.pizza_name ='vegetarian'
					      then pizza_name end) as count_of_vegetarian
from customer_orders co
join pizza_names pn
on co.pizza_id = pn.pizza_id
group by customer_id
order by customer_id

select customer_id,count( case when cast(pn.pizza_name as int) = 'Meatlovers'
                           then pizza_name End) as count_of_meatlover_pizza,
				 count(case when cast (pn.pizza_name as int) = 'vegetarian' 
				       then pizza_name End) as count_of_vegetarian_pizza
from customer_orders co
join pizza_names pn
on co.pizza_id = pn.pizza_id
group by customer_id
order by customer_id;
select TABLE_NAME, COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.columns

SELECT co.customer_id, pn.pizza_name, COUNT (co.pizza_id) AS Pizzas_Ordered
FROM customer_orders co
INNER Join pizza_names as pn 
ON co.pizza_id = pn.pizza_id
GROUP BY co.customer_id, pn.pizza_name;

Case when cast(pn.pizza_name as varchar(50)


--6.	What was the maximum number of pizzas delivered in a single order?
select co.order_id, max(pizza_id) as max_pizza
from customer_orders co
join runner_orders ro
on co.order_id = ro.order_id
where cancellation is null
group by co.order_id

--2 is the maximum order of pizza delivered in a single order

--7.	For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select customer_id,count(case when exclusions is not null or extras is not null then 1 end) as delivered_pizza_with_atleast_one_change, 
                   COUNT(case when exclusions is null and extras is null then 1 end) as delivered_pizza_with_no_change
from customer_orders co
join runner_orders ro
on co.order_id = ro.order_id
where cancellation is null
group by customer_id;


--8.	How many pizzas were delivered that had both exclusions and extras?
select ro.order_id,count(exclusions) as exclusions, COUNT(extras) as extras
from customer_orders co
join runner_orders ro
on co.order_id = ro.order_id
where exclusions is not null and extras is not null and cancellation is null
group by ro.order_id;
--9.	What was the total volume of pizzas ordered for each hour of the day?
select Datepart(hour, order_time) as hour_of_the_day, count(pizza_id) as vol_of_pizza
from customer_orders
group by Datepart(hour, order_time)

--10.	What was the volume of orders for each day of the week?
select day(order_time) as day_of_week,datename(WEEKDAY,order_time) as day_name,count(pizza_id) as vol_pizza
from customer_orders
group by day(order_time),datename(weekday,order_time)
order by day(order_time) , datename(weekday,order_time)

--B. Runner and Customer Experience
--1.	How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
select top 1 *
from customer_orders
select top 1 *
from runners
select top 1 *
from runner_orders
select top 1 *
from pizza_toppings
select top 1 *
from pizza_names
select top 1 *
from pizza_recipes;

select sum(case when r.runner_id is not null then 1 end ) as runners,dateadd(week,1,registration_date) as weeks
from runners r
join runner_orders ro
on r.runner_id = ro.runner_id
group by dateadd(week,1,registration_date)
--week 1 was 4 runners
--week 2 was 4 runners 
--week 3 was 2 runners


--2.	What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
select r.runner_id,avg(duration) as avg_time_in_mins
from runners r
join runner_orders ro
on r.runner_id = ro.runner_id
group by r.runner_id
-- run 1 = 22
-- run 2 = 26
-- run 3 = 15
--3.	Is there any relationship between the number of pizzas and how long the order takes to prepare?
select customer_id,sum(pizza_id) as num_of_pizza,ro.order_id,order_time,pickup_time,duration
from customer_orders co
join runner_orders ro
on co.order_id = ro.order_id
group by customer_id,ro.order_id,order_time,pickup_time,duration

--there is no relationship



--4.	What was the average distance travelled for each customer?
select customer_id, avg(distance) as avg_dis
from customer_orders co
left join runner_orders ro
on co.order_id = ro.order_id
group by customer_id

--5.	What was the difference between the longest and shortest delivery times for all orders?
 select max(duration) as longest,
 min(duration) as shortest,
 max(duration)- min(duration) as diff_in_delivery_time
 from runner_orders

--6.	What was the average speed for each runner for each delivery and do you notice any trend for these values?
select r.runner_id, round(avg(distance/duration),2) as avg_speed
from runner_orders ro
join runners r
on r.runner_id = ro.runner_id
group by r.runner_id


SELECT r.runner_id,
	   ROUND(AVG((100/6) * distance/duration), 2) AS avg_speed_in_metre_per_seconds
FROM runner_orders AS ro
	 JOIN runners AS r
     on r.runner_id =ro.runner_id
GROUP BY r.runner_id;
--7.	What is the successful delivery percentage for each runner?


--C. Ingredient Optimisation
--1.	What are the standard ingredients for each pizza?
select top 1 *
from customer_orders
select top 1  *
from pizza_recipes
select top 1 *
from runners


select top 1 *
from pizza_toppings
select top 1 *
from pizza_names



--2.	What was the most commonly added extra?
--3.	What was the most common exclusion?
--4.	Generate an order item for each record in the customers_orders table in the format of one of the following:
--o Meat Lovers
--o	Meat Lovers - Exclude Beef
--o	Meat Lovers - Extra Bacon
--o	Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
--5.	Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
--o	For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
--6.	What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

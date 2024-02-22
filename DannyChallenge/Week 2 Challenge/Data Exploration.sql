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












/*
Project Name: Pizza Sales Data Analysis using Oracle SQL
Developed by Golam Kaderye
*/

-- ============================================================================
-- QUERIES (SET-1: EASY)
-- ============================================================================

/*
    Query-1: Retrieve the total number of orders placed.
*/
-- show the all data of pizza_orders table
SELECT * FROM pizza_orders;

-- solution of Query-1:
SELECT
    COUNT(order_id) "Total Orders"
FROM
    pizza_orders;

-- ============================================================================

/*
    Query-2: Calculate the total revenue generated from pizza sales.
*/
-- show the all data of pizzas table
SELECT * FROM pizzas;
-- show the all data of pizza_order_details table
SELECT * FROM pizza_order_details;

-- solution of Query-2:
SELECT
    SUM(p.price * pod.quantity) "Total Revenue"
FROM
         pizza_order_details pod
    JOIN pizzas p ON p.pizza_id = pod.pizza_id;

-- ============================================================================

/*
    Query-3: Identify the highest-priced pizza with ID.
*/
-- show the all data of pizzas table
SELECT * FROM pizzas;
-- show the all data of pizza_types table
SELECT * FROM pizza_types;

-- solution of Query-3:
SELECT
    pizzas.pizza_id,
    pizza_types.name,
    pizzas.price
FROM
         pizza_types
    JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY
    pizzas.price DESC
FETCH FIRST 1 ROW ONLY;

-- ============================================================================

/*
    Query-4: Identify the most common quantity ordered
*/
-- show the all data of pizza_order_details table
SELECT * FROM pizza_order_details;

-- solution of Query-4:
SELECT
    quantity,
    COUNT(order_details_id)
FROM
    pizza_order_details
GROUP BY
    quantity
ORDER BY
    quantity;
    
-- ============================================================================

/*
    Query-5: Identify the most common pizza size ordered
*/
-- show the all data of pizza_order_details table
SELECT * FROM pizza_order_details;

-- solution of Query-5:
SELECT
    p.pizza_size,
    COUNT(pod.order_details_id)
FROM
        pizza_order_details pod
    JOIN pizzas p ON p.pizza_id=pod.pizza_id
GROUP BY
    p.pizza_size
ORDER BY
    COUNT(pod.order_details_id) DESC;
    
-- ============================================================================

/*
    Query-6: List the top 5 most ordered 
    pizza names along with their quantities.
*/
-- show the all data of pizza_types table
SELECT * FROM pizza_types;
-- show the all data of pizzas table
SELECT * FROM pizzas;
-- show the all data of pizza_order_details table
SELECT * FROM pizza_order_details;

-- solution of Query-6:
SELECT pt.name, SUM(pod.quantity)
FROM pizza_order_details pod
JOIN pizzas p ON p.pizza_id=pod.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id=p.pizza_type_id
GROUP BY pt.name
ORDER BY COUNT(pod.quantity) DESC
FETCH FIRST 5 ROWS ONLY;

-- ============================================================================

/*
    Query-7: Join the necessary tables to find the total quantity 
    of each pizza type / category ordered.
*/
-- show the all data of pizza_types table
SELECT * FROM pizza_types;
-- show the all data of pizzas table
SELECT * FROM pizzas;
-- show the all data of pizza_order_details table
SELECT * FROM pizza_order_details;

-- solution of Query-7:
SELECT pt.category, SUM(pod.quantity)
FROM pizza_order_details pod
JOIN pizzas p ON p.pizza_id=pod.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id=p.pizza_type_id
GROUP BY pt.category
ORDER BY COUNT(pod.quantity) DESC;

-- ============================================================================

/*
    Query-8: Identify the top 5 highest-priced pizza with ID 
    and count their total number of orders.
*/
-- show the all data of pizzas table
SELECT * FROM pizzas;
-- show the all data of pizza_types table
SELECT * FROM pizza_types;
-- show the all data of pizza_order_details table
SELECT * FROM pizza_order_details;

-- solution of Query-8:
SELECT
    p.pizza_id,
    pt.name,
    p.price "Higest Price",
    COUNT(pod.order_id) "Total Number of Order"
FROM
         pizza_types pt
    JOIN pizzas p ON p.pizza_type_id = pt.pizza_type_id
    JOIN pizza_order_details pod ON pod.pizza_id=p.pizza_id
GROUP BY
    p.pizza_id,
    pt.name,
    p.price
ORDER BY
    p.price DESC
FETCH FIRST 5 ROWS ONLY;

-- ============================================================================

/*
    Query-9: Calculate the total prices based on pizza ID and pizza name, 
    generated from pizza sales.
*/
-- show the all data of pizzas table
SELECT * FROM pizzas;
-- show the all data of pizza_order_details table
SELECT * FROM pizza_order_details;
-- show the all data of pizza_types table
SELECT * FROM pizza_types;

-- solution of Query-9:
SELECT p.pizza_id "Pizza ID", pt.name "Pizza Name", 
SUM(p.price*pod.quantity) "Total Prices"
FROM pizza_order_details pod
JOIN pizzas p ON p.pizza_id=pod.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id=p.pizza_type_id
GROUP BY p.pizza_id, pt.name
ORDER BY "Total Prices" DESC;

-- ============================================================================




-- ============================================================================
-- QUERIES (SET-2: INTERMEDIATE)
-- ============================================================================

/*
    Query-10: Determine the distribution of orders by hour of the day.
*/
-- show the all data of pizza_orders table
SELECT * FROM pizza_orders;

-- solution of Query-10:
SELECT
    to_char(to_date(time, 'HH:MI:SS AM'), 'HH12') AS hour_12,
    COUNT(order_id) "Total Order"
FROM
    pizza_orders
GROUP BY
    to_char(to_date(time, 'HH:MI:SS AM'), 'HH12')
ORDER BY
    "Total Order" DESC;

-- ============================================================================

/*
    Query-11: Join relevant tables to find 
    the category-wise distribution of pizzas.
*/
-- show the all data of pizza_types table
SELECT * FROM pizza_types;

-- solution of Query-11:
SELECT
    category, COUNT(name) "Number of Pizzas"
FROM
    pizza_types
GROUP BY
    category
ORDER BY
    "Number of Pizzas" DESC;

-- ============================================================================

/*
    Query-12: Group the orders by date and calculate 
    the average number of pizzas ordered per day.
*/
-- show the all data of pizza_types table
SELECT * FROM pizza_types;
-- show the all data of pizza_order_details table
SELECT * FROM pizza_order_details;

-- First way: solution of Query-12:
SELECT 
ROUND(SUM(quantity)/COUNT(DISTINCT po.order_date), 3) "Average Order Per Day"
from pizza_order_details pod
JOIN pizza_orders po ON po.order_id=pod.order_id;

-- Second way: solution of Query-12:
SELECT ROUND(AVG("Number of orders"), 3) "Average Order Per Day" FROM
(SELECT po.order_date "Order Date", SUM(pod.quantity) "Number of orders"
FROM pizza_orders po
JOIN pizza_order_details pod ON pod.order_id=po.order_id
GROUP BY po.order_date
ORDER BY "Number of orders" DESC) "order quantity";

-- Third way: solution of Query-12:
WITH order_quantity AS(
SELECT po.order_date "Order Date", SUM(pod.quantity) "Number of orders"
FROM pizza_orders po
JOIN pizza_order_details pod ON pod.order_id=po.order_id
GROUP BY po.order_date
ORDER BY "Number of orders" DESC
)
SELECT ROUND(AVG("Number of orders"), 3) "Average Order Per Day" 
FROM order_quantity;

-- ============================================================================

/*
    Query-13: Determine the top 5 most ordered pizza 
    types based on revenue.
*/
-- show the all data of pizzas table
SELECT * FROM pizzas;
-- show the all data of pizza_types table
SELECT * FROM pizza_types;

-- solution of Query-13:
SELECT pt.name "Pizza Name", SUM(p.price*pod.quantity) "Total Revenue"
FROM pizzas p
JOIN pizza_types pt ON pt.pizza_type_id=p.pizza_type_id
JOIN pizza_order_details pod ON pod.pizza_id=p.pizza_id
GROUP BY pt.name
ORDER BY "Total Revenue" DESC
FETCH FIRST 5 ROWS ONLY;

-- ============================================================================



-- ============================================================================
-- QUERIES (SET-3: ADVANCED)
-- ============================================================================

/*
    Query-14: Calculate the percentage contribution of 
    each pizza type to total revenue.
*/
-- show the all data of pizza_types table
SELECT * FROM pizza_types;

-- First way: solution of Query-14:
SELECT pt.category, SUM(p.price*pod.quantity) "Revenue",

ROUND(((SUM(p.price*pod.quantity)/(SELECT SUM(p.price*pod.quantity) "Total Revenue"
FROM pizza_order_details pod
JOIN pizzas p ON p.pizza_id=pod.pizza_id))*100), 3) "Percentage"

FROM pizza_types pt
JOIN pizzas p ON p.pizza_type_id=pt.pizza_type_id
JOIN pizza_order_details pod ON pod.pizza_id=p.pizza_id
GROUP BY pt.category
ORDER BY "Revenue" DESC;


-- Second way: solution of Query-14:
WITH category_revenue AS(
SELECT pt.category, SUM(p.price*pod.quantity) revenue
FROM pizza_types pt
JOIN pizzas p ON p.pizza_type_id=pt.pizza_type_id
JOIN pizza_order_details pod ON pod.pizza_id=p.pizza_id
GROUP BY pt.category
ORDER BY revenue DESC
),
total_revenue AS(
    SELECT SUM(revenue) Total FROM category_revenue
)
SELECT 
cr.category,
cr.revenue,
ROUND((cr.revenue/tr.total)*100, 3) Percentage
FROM category_revenue cr
CROSS JOIN total_revenue tr
order by cr.revenue desc;

-- ============================================================================

/*
    Query-15: Analyze the cumulative revenue generated over time.
*/
-- show the all data of pizza_orders table
SELECT * FROM pizza_orders;
-- show the all data of pizza_order_details table
SELECT * FROM pizza_order_details;
-- show the all data of pizzas table
SELECT * FROM pizzas;

-- First style: solution of Query-14:
SELECT order_date, revenue,
SUM(revenue) over(order by order_date) cumulative_revenue
from
(SELECT po.order_date, SUM(pod.quantity*p.price) revenue
FROM pizza_orders po
JOIN pizza_order_details pod ON pod.order_id=po.order_id
JOIN pizzas p ON p.pizza_id=pod.pizza_id
GROUP BY po.order_date) sales
ORDER BY order_date;

-- Second style: solution of Query-14:
WITH sales AS(
SELECT po.order_date, SUM(pod.quantity*p.price) revenue
FROM pizza_orders po
JOIN pizza_order_details pod ON pod.order_id=po.order_id
JOIN pizzas p ON p.pizza_id=pod.pizza_id
GROUP BY po.order_date
ORDER BY order_date
)
SELECT s.order_date, s.revenue,
SUM(revenue) over(order by order_date) cumulative_revenue
from sales s;

-- ============================================================================

/*
    Query-16: Determine the top 3 most ordered pizza types based 
    on revenue for each pizza category.
*/
-- show the all data of pizza_orders table
SELECT * FROM pizza_orders;
-- show the all data of pizza_order_details table
SELECT * FROM pizza_order_details;
-- show the all data of pizzas table
SELECT * FROM pizzas;

-- solution of Query-16:
SELECT category, name, Revenue,rank
FROM
(SELECT category, name, Revenue,
rank() over(partition by category order by revenue desc) Rank
FROM 
(SELECT pt.category, pt.name, SUM(p.price*pod.quantity) Revenue
FROM pizza_order_details pod
JOIN pizzas p ON p.pizza_id=pod.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id=p.pizza_type_id
GROUP BY pt.category, pt.name
ORDER BY Revenue DESC
) info) final
WHERE rank<=3;

-- ============================================================================

/*
    Query-17: Determine the ordered pizza types based 
    on revenue for each pizza category with the rank only 1.
*/
-- show the all data of pizza_orders table
SELECT * FROM pizza_orders;
-- show the all data of pizza_order_details table
SELECT * FROM pizza_order_details;
-- show the all data of pizzas table
SELECT * FROM pizzas;

-- solution of Query-17:
SELECT category, name, Revenue,rank
FROM
(SELECT category, name, Revenue,
rank() over(partition by category order by revenue desc) Rank
FROM 
(SELECT pt.category, pt.name, SUM(p.price*pod.quantity) Revenue
FROM pizza_order_details pod
JOIN pizzas p ON p.pizza_id=pod.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id=p.pizza_type_id
GROUP BY pt.category, pt.name
ORDER BY Revenue DESC
) info) final
WHERE rank=1;

-- ============================================================================

SELECT pt.name, COUNT(pod.order_id) "Number of order"
FROM pizza_types pt
JOIN pizzas p ON p.pizza_type_id=pt.pizza_type_id
JOIN pizza_order_details pod ON pod.pizza_id=p.pizza_id
GROUP BY pt.name
ORDER BY "Number of order" DESC;





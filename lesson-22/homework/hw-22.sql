CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')

	CREATE TABLE OneColumn (
    Value SMALLINT
);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);

CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17);

CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);

CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 

INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54); 
----- EASY -----
--1.
SELECT customer_id,
       total_amount,
       SUM(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM sales_data;

--2.
SELECT product_category,
       COUNT(*) OVER(PARTITION BY product_category) AS order_count
FROM sales_data;

--3.
SELECT product_category,
       MAX(total_amount) OVER(PARTITION BY product_category) AS max_total
FROM sales_data;

--4.
SELECT product_category,
       MIN(unit_price) OVER(PARTITION BY product_category) AS min_price
FROM sales_data;

--5.
SELECT order_date,
       AVG(total_amount) OVER(ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg
FROM sales_data;

--6.
SELECT region,
       SUM(total_amount) OVER(PARTITION BY region) AS total_sales
FROM sales_data;

--7.
WITH customer_totals AS (
SELECT customer_id,
SUM(total_amount) AS tot_purchase
FROM sales_data
GROUP BY customer_id
)
SELECT customer_id,
tot_purchase,
RANK() OVER(ORDER BY tot_purchase DESC) AS rank
FROM customer_totals;

--8.
SELECT customer_id,
       total_amount,
       total_amount - LAG(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS diff
FROM sales_data;

--9.
WITH ranked_products AS (
    SELECT *,
           DENSE_RANK() OVER(PARTITION BY product_category ORDER BY unit_price DESC) AS rank
    FROM sales_data
)
SELECT *
FROM ranked_products
WHERE rank <= 3;

--10.
SELECT region,
       order_date,
       SUM(total_amount) OVER(PARTITION BY region ORDER BY order_date) AS cumulative_sales
FROM sales_data;

----- MEDIUM -----

--11.
SELECT product_category,
       SUM(total_amount) OVER(PARTITION BY product_category ORDER BY order_date) AS cumulative_revenue
FROM sales_data;

--12.
WITH input(ID) AS (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5)
SELECT ID,
       SUM(ID) OVER(ORDER BY ID ROWS UNBOUNDED PRECEDING) AS SumPreValues
FROM input;

--13.
SELECT Value,
       SUM(Value) OVER(ORDER BY Value ROWS UNBOUNDED PRECEDING) AS SumPrevious
FROM OneColumn;

--14.
SELECT customer_id
FROM sales_data
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category) > 1;

--15.
WITH customer_totals AS (
    SELECT customer_id,
           region,
           SUM(total_amount) AS total_spent
    FROM sales_data
    GROUP BY customer_id, region
),
region_avg AS (
    SELECT region,
           AVG(total_spent) AS avg_spent
    FROM customer_totals
    GROUP BY region
)
SELECT c.customer_id,
       c.total_spent,
       c.region
FROM customer_totals c
JOIN region_avg r ON c.region = r.region
WHERE c.total_spent > r.avg_spent;

--16.
SELECT customer_id,
       SUM(total_amount) AS total_spent,
       RANK() OVER(PARTITION BY region ORDER BY SUM(total_amount) DESC) AS rank
FROM sales_data
GROUP BY customer_id, region;

--17.
SELECT customer_id,
       total_amount,
       SUM(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS cumulative_sales
FROM sales_data;

--18.
SELECT YEAR(order_date) AS yr,
       MONTH(order_date) AS mon,
       SUM(total_amount) AS monthly_sales,
       (SUM(total_amount) - LAG(SUM(total_amount)) OVER(ORDER BY YEAR(order_date), MONTH(order_date))) / LAG(SUM(total_amount)) OVER(ORDER BY YEAR(order_date), MONTH(order_date)) AS growth_rate
FROM sales_data
GROUP BY YEAR(order_date), MONTH(order_date);

--19.
WITH prev_sales AS (
    SELECT customer_id,
           total_amount,
           LAG(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS last_amount
    FROM sales_data
)
SELECT customer_id,
       total_amount,
       last_amount
FROM prev_sales
WHERE total_amount > last_amount;

----- HARD -----

--20.
SELECT product_name,
       unit_price
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data);

--21.
SELECT *,
       CASE WHEN ROW_NUMBER() OVER(PARTITION BY Grp ORDER BY Id)=1 THEN SUM(Val1+Val2) OVER(PARTITION BY Grp) ELSE NULL END AS Tot
FROM MyData;

--22.
SELECT ID,
       SUM(Cost) AS Cost,
       SUM(Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY ID;

--23.
WITH nums AS (SELECT ROW_NUMBER() OVER(ORDER BY SeatNumber) AS rn, SeatNumber FROM Seats)
SELECT prev.SeatNumber+1 AS GapStart, curr.SeatNumber-1 AS GapEnd
FROM nums prev
JOIN nums curr ON curr.rn = prev.rn + 1
WHERE curr.SeatNumber - prev.SeatNumber > 1;

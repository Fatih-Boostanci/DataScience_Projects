------------------------------------------------------------------------------------------
----------------------------------------MICROSOFT SQL SERVER PROJECT----------------------------------------------
--------------E-Commerce Data and Customer Retention Analysis with SQL-------------------------------
-----------------------27 June 2022--------------------------------------

--An e-commerce organization demands some analysis of sales and delivery processes. 
--Thus, the organization hopes to be able to predict more easily the opportunities and threats for the future. 

--According to this scenario, 
--You are asked to make the following analyzes consistant with following the instructions given. 

--Introduction:

-- * You have to create a database and import into the given csv files. 
--(You should research how to import a .csv file or a .xlsx file)

-- * During the import process, you will need to adjust the date columns. 
-- You need to carefully observe the data types and how they should be. 

-- * The data are not very clean and fully normalized. 
-- However, they don't prevent you from performing the given tasks. 
-- In some cases you may need to use the string, window, system or date functions.

-- * There may be some issues where you need to update the tables. 

-- * Manually verify the accuracy of your analysis.


--OPTIONAL: 

--You can (but not must) clean and normalize the data, 
--change the data types of some columns, 
--clear the id columns, and assign them as keys. 
-- Then you can create the data model. 


-- *** Analyze the data by finding the answers to the questions below:





--We had some problems during the import process. 
--'orders.dimen' and 'shipping.dimen' tables contain 'order_date' and 'shipping_date' columns respectively 
--which were in 'date' type. Because of that we got error messages during import process. 

--How we solved this issue?
--We changed the type of these 2 columns as 'varchar' before during the importing. 

--Beside this issue, we had 2 tables in excel format.
--We converted these 2 tables to csv files. 


--After the importing, we realized that the format of date columns were not appropriate. 
-- They were in DD-MM-YYYY, but they must be in YYYY-MM-DD format. 
--So, before changing data type of these columns, we had to amend the format of date columns.
--To do this, we used the query below;

--'order_date' column in 'orders.dimen' table
UPDATE orders_dimen
set order_date = concat(SUBSTRING(order_date,7,4),'-' , SUBSTRING(order_date,4,2),'-', SUBSTRING(order_date, 1,2))
where order_date like '[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'; 

--Then, in order to change data type from varchar to date, we did this.

alter table orders_dimen
ALTER COLUMN order_date date;

--As an alternative solution, we can right click on the related table and click 'design' button.


SELECT *
FROM orders_dimen 

--'shipping_date' column in 'shipping.dimen' table

UPDATE shipping_dimen
set ship_date = concat(SUBSTRING(ship_date,7,4),'-' , SUBSTRING(ship_date,4,2),'-', SUBSTRING(ship_date, 1,2))
where ship_date like '[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'; 

--To change data type to 'date'

alter table shipping_dimen
ALTER COLUMN ship_date date;


SELECT *
FROM shipping_dimen 
----------------------------------

SELECT *
FROM cust_dimen 

SELECT *
FROM orders_dimen 

SELECT *
FROM market_fact 



-- *** In the OPTIONAL part of the project, 
--we were told we could clean and normalize the data, 
--by changing the data types of some columns, 
--by clearing the id columns, and assign them as keys

-- *** So, we consider it would be better to make these amendments.

--*** We had cleaned str expressions 
--in 'Cust_id', 'Ord_id', 'Prod_id', 'Ship_id' 
--and changed the data types of these columns as 'int'
--and assign them as 'Primary Key'



--'Cust_id' column in Cust_Dimen Table
UPDATE cust_dimen
SET Cust_id = TRIM ('Cust_' FROM Cust_id)
FROM cust_dimen

SELECT *
FROM cust_dimen 

-- 'Ord_id' column in Orders_Dimen Table 
SELECT *
FROM Orders_dimen 

UPDATE Orders_dimen
SET Ord_id = TRIM ('Ord_' FROM Ord_id)
FROM Orders_dimen

SELECT *
FROM Orders_dimen 

--Change data types from nvarchar to int
alter table Orders_dimen
ALTER COLUMN Ord_id int; 

SELECT *
FROM Orders_dimen 

--'Prod_id' column in Prod_Dimen Table     
SELECT *
FROM Prod_dimen 

UPDATE Prod_dimen
SET Prod_id = TRIM ('Prod_' FROM Prod_id)
FROM Prod_dimen

SELECT *
FROM Prod_dimen 

--Change data types from nvarchar to int
alter table Prod_dimen
ALTER COLUMN Prod_id int; 

--'Ship_id' column in Shipping_Dimen Table 
SELECT *
FROM Shipping_dimen 

UPDATE Shipping_dimen
SET Ship_id = TRIM ('SHP_' FROM Ship_id)
FROM Shipping_dimen 

SELECT *
FROM Shipping_dimen  

--Change data types from nvarchar to int w/ design feature 

--'Cust_id', 'Ord_id', 'Prod_id', 'Ship_id' columns in Market_Fact Table 

SELECT *
FROM Market_Fact 

UPDATE Market_Fact 
SET Ord_id = TRIM ('Ord_' FROM Ord_id),
    Prod_id = TRIM ('Prod_' FROM Prod_id),
    Ship_id = TRIM ('SHP_' FROM Ship_id),
    Cust_id = TRIM ('Cust_' FROM Cust_id)
FROM Market_Fact
;

SELECT *
FROM Market_Fact 

--Change data types from nvarchar to int w/ design feature 

SELECT *
FROM Market_Fact 
ORDER BY 1 
----------------------------------------------------

--Assign 'Cust_id', 'Ord_id', 'Prod_id', 'Ship_id' columns as for each table but  Market_Fact Table

-- with Design feature


--------------------------------------------------------




-- *** Analyze the data by finding the answers to the questions below:


--1. Using the columns of “market_fact”, “cust_dimen”, “orders_dimen”, 
--“prod_dimen”, “shipping_dimen”, Create a new table, 
--named as “combined_table”. 

--INNER JOIN
SELECT *
FROM market_fact m,
     cust_dimen c,
     orders_dimen o,
     prod_dimen p,
     shipping_dimen s
WHERE m.Cust_id = c.Cust_id
    AND m.Ord_id = o.Ord_id 
    AND m.Prod_id = p.Prod_id 
    AND m.Ship_id = s.Ship_id
;

--LEFT JOIN
SELECT m.*, c.Customer_Name, c.Province, c.Region, c.Customer_Segment, 
       o.Order_Date, o.Order_Priority, 
       p.Product_Category, p.Product_Sub_Category, 
       s.Cargo_Track_id, s.Ship_Date, s.Ship_Mode 
INTO combined_table
FROM market_fact m 
LEFT JOIN cust_dimen c 
ON m.Cust_id = c.Cust_id 
LEFT JOIN orders_dimen o 
ON m.Ord_id = o.Ord_id 
LEFT JOIN prod_dimen p 
ON m.Prod_id = p.Prod_id 
LEFT JOIN shipping_dimen s 
ON m.Ship_id = s.Ship_id 
;
---------
SELECT *
FROM combined_table 
;

--2. Find the top 3 customers who have the maximum count of orders.


SELECT TOP 3 Cust_id, Customer_Name,  COUNT(DISTINCT Ord_id) count_of_order
FROM combined_table
GROUP BY Cust_id, Customer_Name
ORDER BY count_of_order DESC
;

--3. Create a new column at combined_table as DaysTakenForDelivery 
--that contains the date difference of Order_Date and Ship_Date. 

SELECT *, DATEDIFF(DAY, order_date, Ship_Date) DaysTakenForDelivery
FROM combined_table
;

-----


ALTER TABLE combined_table
ADD DaysTakenForDelivery int
; 

UPDATE combined_table
SET DaysTakenForDelivery = DATEDIFF(DAY, order_date, Ship_Date)
FROM combined_table 
; 

-- 4. Find the customer whose order took the maximum time to get delivered.


SELECT TOP 1 Cust_id, Customer_Name, DaysTakenForDelivery max_delivery
FROM combined_table
ORDER BY max_delivery DESC 
; 

--2nd Solution

SELECT TOP 1 Cust_id, Customer_Name, MAX(DaysTakenForDelivery) max_delivery
FROM combined_table 
GROUP BY Cust_id, Customer_Name 
ORDER BY 3 DESC

-- 5. Count the total number of unique customers in January and 
--how many of them came back every month over the entire year in 2011

WITH TBL AS (
SELECT	DISTINCT Cust_id
FROM	combined_table
WHERE	YEAR (Order_Date) = 2011
AND		MONTH(Order_Date) = 1
)
SELECT	DATENAME(MONTH, Order_Date) ORD_MONTH, MONTH(order_date) ord_month_2 , COUNT (DISTINCT T.Cust_id) CNT_CUST
FROM	combined_table A, TBL T
WHERE	A.Cust_id = T.Cust_id
AND		YEAR (Order_Date) = 2011
GROUP BY 	DATENAME(MONTH, Order_Date), MONTH(order_date)
ORDER BY 2


--6. Write a query to return for each user the time elapsed 
--between the first purchasing and the third purchasing, 
--in ascending order by Customer ID.

SELECT distinct Cust_id, Order_date, 
		DENSE_RANK() OVER(PARTITION BY Cust_id ORDER BY Order_date) d_rank
FROM combined_table
ORDER  BY 1

----

WITH tbl AS 
        (
        SELECT DISTINCT Cust_id, Order_date, 
            DENSE_RANK() OVER(PARTITION BY Cust_id ORDER BY Order_date) d_rank
        FROM combined_table
        ),  tbl2 as 
        (
        SELECT Cust_id, Order_date
        FROM tbl
        WHERE d_rank = 1
        ), tbl3 as 
        (
        SELECT Cust_id, Order_date
        FROM tbl
        WHERE d_rank = 3
        )
SELECT  tbl2.Cust_id, DATEDIFF(DAY, tbl2.Order_Date, tbl3.Order_Date) [DateDiff]
FROM tbl2, tbl3
WHERE tbl2.Cust_id = tbl3.Cust_id 
ORDER BY 1 
;



--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products 
--purchased by the customer. 

SELECT * 
FROM combined_table



WITH tbl AS(
SELECT Cust_id, prod_id, SUM(Order_Quantity) total_product_amount
FROM combined_table
WHERE Cust_id IN (  SELECT Cust_id 
					FROM combined_table
					WHERE Prod_id = 11 
					INTERSECT
					SELECT Cust_id
					FROM combined_table
					WHERE Prod_id = 14
					)
GROUP BY Cust_id, prod_id

), tbl2 AS(
SELECT DISTINCT  Cust_id, SUM(total_product_amount) over(PARTITION BY Cust_id) total_amount
FROM tbl
), tbl3 AS (
SELECT DISTINCT  Cust_id, SUM(total_product_amount) over(PARTITION BY Cust_id) prod11_14_total_amount
FROM tbl
WHERE prod_id = 11 OR Prod_id = 14
)
SELECT tbl2.Cust_id,  CAST (1.0*(prod11_14_total_amount/total_amount) AS numeric (10,3)) ratio_of_prod_11_14
FROM tbl2, tbl3
WHERE tbl2.Cust_id = tbl3.Cust_id 
;


--Customer Segmentation
--Categorize customers based on their frequency of visits. 
--The following steps will guide you. If you want, you can track your own way.

--1. Create a “view” that keeps visit logs of customers on a monthly basis. 
--(For each log, three field is kept: Cust_id, Year, Month)

CREATE VIEW VISIT_LOGS AS 
SELECT DISTINCT Cust_id, YEAR(Order_Date) YEAR_, MONTH(Order_Date) MONTH_,
		COUNT(Order_Date) OVER(PARTITION BY Cust_id, YEAR(Order_Date), MONTH(Order_Date) ) count_of_visit
FROM combined_table

SELECT * 
FROM VISIT_LOGS
ORDER BY 1 

--2. Create a “view” that keeps the number of monthly visits by users. 
--(Show separately all months from the beginning business)

CREATE VIEW VISIT_LOGS_MONTHLY AS 
SELECT DISTINCT Cust_id,  MONTH(Order_Date) MONTH_,
		COUNT(Order_Date) OVER(PARTITION BY Cust_id, MONTH(Order_Date) ) count_of_visit
FROM combined_table

SELECT * 
FROM VISIT_LOGS_MONTHLY
ORDER BY 1,2


SELECT * 
FROM VISIT_LOGS
ORDER BY 1 
------ OPTIONAL  
SELECT DISTINCT Cust_id,  DATENAME (M, Order_Date) MONTH_,
		COUNT(Order_Date) OVER(PARTITION BY Cust_id, MONTH(Order_Date) ) count_of_visit
FROM combined_table
; 

--3. For each visit of customers, 
--create the next month of the visit as a separate column.

WITH tbl AS (
SELECT DISTINCT  Cust_id, Order_Date, 
		DENSE_RANK() over(PARTITION BY Cust_id ORDER BY Order_Date) d_rank
FROM combined_table
)
SELECT DISTINCT Cust_id, Order_Date, 
		LEAD(MONTH(Order_Date)) OVER(PARTITION BY Cust_id ORDER BY Order_Date) next_visit
FROM tbl
ORDER BY 1
;





--Create next_level table 

WITH tbl AS (
SELECT DISTINCT  Cust_id, Order_Date, 
		DENSE_RANK() over(PARTITION BY Cust_id ORDER BY Order_Date) d_rank
FROM combined_table
), tbl2 AS (
SELECT DISTINCT Cust_id, Order_Date, 
		LEAD(Order_Date) OVER(PARTITION BY Cust_id ORDER BY Order_Date) next_visit
FROM tbl
)
SELECT *
INTO next_visit_tbl2
FROM tbl2


--2nd Solution 
SELECT DISTINCT Cust_id, Order_Date, 
		LEAD(MONTH(Order_Date)) OVER(PARTITION BY Cust_id ORDER BY Order_Date) next_visit
FROM (
		SELECT DISTINCT  Cust_id, Order_Date, 
				DENSE_RANK() over(PARTITION BY Cust_id ORDER BY Order_Date) d_rank
		FROM combined_table
		) A
;


--4. Calculate the monthly time gap between 
--two consecutive visits by each customer.

WITH tbl AS (
SELECT DISTINCT  Cust_id, Order_Date, 
		DENSE_RANK() over(PARTITION BY Cust_id ORDER BY Order_Date) d_rank
FROM combined_table
), tbl2 AS (
SELECT DISTINCT Cust_id, Order_Date, 
		LEAD(Order_Date) OVER(PARTITION BY Cust_id ORDER BY Order_Date) next_visit
FROM tbl
)
SELECT  *, DATEDIFF(MONTH, Order_Date, next_visit) monthly_time_gap
FROM tbl2
ORDER BY 1
;



--5. Categorise customers using average time gaps. 
--Choose the most fitted labeling model for you.

WITH tbl AS (
SELECT DISTINCT  Cust_id, Order_Date, 
		DENSE_RANK() over(PARTITION BY Cust_id ORDER BY Order_Date) d_rank
FROM combined_table
), tbl2 AS (
SELECT DISTINCT Cust_id, Order_Date, 
		LEAD(Order_Date) OVER(PARTITION BY Cust_id ORDER BY Order_Date) next_visit, d_rank
FROM tbl
), tbl3 AS (
SELECT  *, DATEDIFF(MONTH, Order_Date, next_visit) monthly_time_gap
FROM tbl2
), tbl4 AS (
SELECT DISTINCT Cust_id, 
		AVG(monthly_time_gap) OVER(PARTITION BY Cust_id) avg_monthly_time_gap, 
		COUNT(d_rank) OVER(PARTITION BY Cust_id) Rows_count
FROM tbl3
), tbl5 AS (
SELECT Cust_id, avg_monthly_time_gap , Rows_count
FROM tbl4
WHERE Rows_count >= 3  AND avg_monthly_time_gap > 0
), tbl6 AS (
SELECT Cust_id, CAST ((1.0*Rows_count/avg_monthly_time_gap) AS decimal(10,3)) loyalty_score
FROM tbl5
)
SELECT * , CAST (ROUND(AVG(loyalty_score) over(), 2) AS decimal (5,2)) avg_loyalty_score
INTO loyalty_table2
FROM tbl6


--- We found that the avg of loyalty score is 2.01
--- Now we classify the cust_id acoording to loyaly score
SELECT Cust_id, loyalty_score, 
		CASE 
			WHEN loyalty_score >= 2 THEN 'Loyal'
			WHEN 2 > loyalty_score AND loyalty_score >= 1 THEN 'Normal'
			ELSE 'Churn'
		END Customer_category 
FROM loyalty_table2


--Create Customer_Category Table
SELECT Cust_id, loyalty_score, 
		CASE 
			WHEN loyalty_score >= 2 THEN 'Loyal'
			WHEN 2 > loyalty_score AND loyalty_score >= 1 THEN 'Normal'
			ELSE 'Churn'
		END Customer_category 
INTO Customer_Category2
FROM loyalty_table2
;

SELECT *
FROM Customer_Category2

--Month-Wise Retention Rate
--Find month-by-month customer retention rate 
--since the start of the business. 

--1. Find the number of customers retained month-wise. 
--(You can use time gaps) 

-- We already created the table below in previous section 
select *
from next_visit_tbl2
order by 1

SELECT MONTH(Order_Date), COUNT(*)
FROM next_visit_tbl2
GROUP BY MONTH(Order_Date)
ORDER BY 1


SELECT MONTH(next_visit), COUNT(*)
FROM next_visit_tbl2
GROUP BY MONTH(next_visit)
ORDER BY 1

SELECT *
FROM Customer_Category2


--- We assumed that Loyal and Normal customers should be categorized as 'retained' customers
SELECT MONTH(nvt.Order_Date) MONTH_, COUNT(nvt.Cust_id) month_wise_retained_cust
--INTO retained_cust_table2
FROM next_visit_tbl2 nvt, Customer_Category2 cc
WHERE nvt.Cust_id = cc.Cust_id AND
		(cc.Customer_category = 'Normal' OR  cc.Customer_category =  'Loyal')
GROUP BY  MONTH(nvt.Order_Date)
ORDER BY 1




SELECT MONTH(nvt.Order_Date) MONTH_, COUNT(nvt.Cust_id) month_wise_all_cust
INTO all_customers2
FROM next_visit_tbl2 nvt, Customer_Category2 cc
WHERE nvt.Cust_id = cc.Cust_id 	
GROUP BY  MONTH(nvt.Order_Date)
ORDER BY 1 


--2. Calculate the month-wise retention rate.

--Month-Wise Retention Rate 
-- = 1.0 * Number of Customers Retained in The Current Month 
-- / Total Number of Customers in the Current Month

SELECT *
FROM all_customers2 

SELECT r.*, a.month_wise_all_cust, 
		CAST((1.0*r.month_wise_retained_cust/a.month_wise_all_cust)  AS DECIMAL (10,2)) month_wise_retention_rate
FROM retained_cust_table2 r, all_customers2 a
WHERE r.MONTH_ = a.MONTH_
ORDER BY 1
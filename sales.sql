use belajar_mysql;
CREATE DATABASE IF NOT EXISTS SalesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(10) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2),
    gross_margin_pct FLOAT(10,2),
    gross_income DECIMAL(10, 2),
    rating FLOAT(2, 1)
);

-- ----------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------FEATURE ENGINERING---------------------------------------------------------------------------


-- time_of_day

SELECT
	time,
    (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning" # ingat hati2 dalam meletakkan tanda petik dan tanda kutip satu (``/'')
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
    )  AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning" # ingat hati2 dalam meletakkan tanda petik dan tanda kutip satu (``/'')
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
);

-- day_name
SELECT
	date,
    DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(15);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name

SELECT
	date,
    MONTHNAME(date)
FROM sales;


ALTER TABLE sales ADD COLUMN month_name VARCHAR(15);

UPDATE sales
SET month_name = MONTHNAME(date);

-- -----------------------------------------------------------------------------------------------------------------------------------


-- ------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------GENERIC QUESTION----------------------------------------------------------------------------------
-- How many unique cities does the data have?

SELECT
	DISTINCT city
FROM sales;

-- in which city is each branch?

SELECT
	DISTINCT branch
FROM sales;
 
 -- we can one unswer for two question above
 SELECT
	DISTINCT city,
    branch
FROM sales;

-- ------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------- PRODUCT QUESTION---------------------

-- how many unique product lines does the data have?

SELECT
	DISTINCT product_line
FROM sales;

-- what is the most common payment method?
SELECT
	payment_method,
	COUNT(payment_method) as cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC; #DESC = mengurutukan dari nilai terbesar hingga terkecil, secara defoult dari kecil ke besar

-- what os the most selling product line?

SELECT
	* #untuk memilih seluruh table data
FROM sales;

SELECT
	product_line,
	COUNT(product_line) as cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- What is the total revenue by month?
SELECT
	month_name as month,
    SUM(total) as total_revenue
FROM sales
GROUP BY Month_name
ORDER BY total_revenue DESC;

 -- what month had the largest COGS?
 SELECT
	month_name as month,
    SUM(cogs) as cogs
FROM sales
GROUP BY month_name
ORDER BY cogs desc;
 
-- what product line had the largest revenue?
SELECT
	product_line,
    SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?and whith the branch
SELECT
	branch,
	city,
    SUM(total) as total_city
FROM sales
GROUP BY city, branch
ORDER BY total_city DESC;

-- what product line had the largest VAT?
SELECT
	product_line,
    AVG(VAT) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- fetch each product line and add a column to those prodcut line showing 'good','bad'. good if its grater than average sales?

-- wich branch sold more producs than average product sold?
SELECT
	branch,
    SUM(quantity) as qty
FROM sales
group by branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- what is the most common product line by gender?
SELECT
	gender,
    product_line,
    COUNT(gender) as total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
SELECT
	product_line,
    ROUND(AVG(rating),2) as avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;
    
-- ------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------- Sales---------------------
-- Number of sales made in each time of the day per weekday?
-- jumlah dari penjualan disetiap waktu dalam sehari selama perminggunya?
SELECT
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day
ORDER BY total_sales DESC;
-- the same question but in each day of the day per weekday?
 SELECT
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday" #Adding Query to slicing data what we want, that can be selective
GROUP BY time_of_day
ORDER BY total_sales DESC;
-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
    SUM(total) AS total_most_rev
FROM sales
GROUP BY customer_type
ORDER BY total_most_rev DESC;

-- which city has the largest tax percent/VAT(value added Tax)?
SELECT
	city,
    AVG(VAT) as largest_vat
FROM sales
GROUP BY city
ORDER BY largest_vat DESC;

-- which customer type pays the most in VAT?
SELECT
	customer_type,
    AVG(VAT) AS vat_custemr
FROM sales
GROUP BY customer_type
ORDER BY vat_custemr DESC;

-- -------------------------------------------------------------------------------------------------------------------------
-- -------------------------------CUSTOMERS------------------------------

-- How many uniqe costomer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;

-- how many unique payment methods does the data have?
SELECT
	DISTINCT payment_method
FROM sales;

-- which customer type buys the most?
SELECT
	customer_type,
    COUNT(*) AS quant_custemr # Must know diffrence between count and sum, count do from the fist to the last, sum is add up each value
FROM sales
GROUP BY customer_type
ORDER BY quant_custemr DESC;
 
-- what is the gender of mst the customers?
SELECT
	gender,
    COUNT(*) AS gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- what is the gender distribution per branch?
SELECT
	gender,
    COUNT(*) AS gender_branch
FROM sales
WHERE branch ="A"# adding where to be selected per branch
GROUP BY gender
ORDER BY gender_branch DESC;

-- which time of the day do cunstemors give most ratings?
SELECT
	time_of_day,
    AVG(rating) AS Avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY Avg_rating DESC;

-- which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- which day for the week has the best avg rating?
SELECT
	day_name,
    AVG(rating) as avg_rat
FROM sales
GROUP BY day_name
ORDER BY avg_rat DESC;

-- wich day of the week has the best average ratings per branch?
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY day_name
ORDER BY avg_rating DESC;









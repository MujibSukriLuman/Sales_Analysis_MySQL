
<h1 align="center">🛒🛍Sales Data Analysis with MySQL🛒🛍</h1>
<img align="right" alt="coding" width="500" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYHuYBJ7nspaM-k5bsq7ydtG2Iixt4lLTLTJSimTlP2zYdXt-IbvJPrsblsxpOcUKQ0Q8&usqp=CAU">

# 1. Data Introduction
This project aims to explore the Walmart Sales data to understanding top performing branches and products, sales trend of difference products, customer behaviour, the aims is to study how sales strategies can be improved and optimized. 

“in this recruiting competition, job-seekers are provided with historical sales data for 45 Walmart stores located in different regions. Each store contains many departments, and participants must project the sales for each department in each store. To add to the challenge, selected holiday markdown events are included in the dataset. These markdowns are known to affect sales, but it is challenging to predict which departments are affected and the extent of the impact”.[source](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting/data) and the dataset can be access on [WalmartSalesDataset](https://github.com/nurastars/Sales_Analysis_MySQL/blob/main/WalmartSalesData.csv).

## What the purpose of the project?

The major aim of this project is to gain insight into Walmart sales data, and then to understand factors that affect sales of different branches.

# 2. Data Wrangling:

```
>>> class pandas.core.frame.DataFrame
    [RangeIndex: 1000 entries, 0 to 999
            Data columns (total 17 columns):
           Column                   Non-Null Count  Dtype  
            ---  ------                   --------------  -----  
            0   Invoice ID               1000 non-null   object 
            1   Branch                   1000 non-null   object 
            2   City                     1000 non-null   object 
            3   Customer type            1000 non-null   object 
            4   Gender                   1000 non-null   object 
            5   Product line             1000 non-null   object 
            6   Unit price               1000 non-null   float64
            7   Quantity                 1000 non-null   int64  
            8   Tax 5%                   1000 non-null   float64
            9   Total                    1000 non-null   float64
            10  Date                     1000 non-null   object 
            11  Time                     1000 non-null   object 
            12  Payment                  1000 non-null   object 
            13  cogs                     1000 non-null   float64
            14  gross margin percentage  1000 non-null   float64
            15  gross income             1000 non-null   float64
            16  Rating                   1000 non-null   float64
            dtypes: float64(7), int64(1), object(9)
```

<img alt="Bibliothèque Hugging Face Transformers" src="https://github.com/nurastars/Sales_Analysis_MySQL/assets/149975589/c33141b4-3ed3-47be-a713-2927fc88e08d" width="1000" height="500" style="max-width: 100%;">

## About Data
```
 1. this dataset contains sales transactions from a walmart different branches.
    Respectively located in Mandalay and Naypyitaw. the data contains 17 columns and 1000 rows.

 2. this dataset was inspection where make sure NULL value is nothing missing value.
    this is indicated by the all white colour in the plot area.

```

| Column                  | Description                             | Data Type      |
| :---------------------- | :-------------------------------------- | :------------- |
| invoice_id              | Invoice of the sales made               | VARCHAR(30)    |
| branch                  | Branch at which sales were made         | VARCHAR(5)     |
| city                    | The location of the branch              | VARCHAR(30)    |
| customer_type           | The type of the customer                | VARCHAR(30)    |
| gender                  | Gender of the customer making purchase  | VARCHAR(10)    |
| product_line            | Product line of the product solf        | VARCHAR(100)   |
| unit_price              | The price of each product               | DECIMAL(10, 2) |
| quantity                | The amount of the product sold          | INT            |
| VAT                 | The amount of tax on the purchase       | FLOAT(6, 4)    |
| total                   | The total cost of the purchase          | DECIMAL(10, 2) |
| date                    | The date on which the purchase was made | DATE           |
| time                    | The time at which the purchase was made | TIMESTAMP      |
| payment_method                 | The total amount paid                   | DECIMAL(10, 2) |
| cogs                    | Cost Of Goods sold                      | DECIMAL(10, 2) |
| gross_margin_percentage | Gross margin percentage                 | FLOAT(11, 9)   |
| gross_income            | Gross Income                            | DECIMAL(10, 2) |
| rating                  | Rating                                  | FLOAT(2, 1)    |

create table for dataset with column, description and data type avobe. and then input [WalmartSalesDataset](https://github.com/nurastars/Sales_Analysis_MySQL/blob/main/WalmartSalesData.csv) to the column created. for this tutorial can be lean in this [link](https://github.com/nurastars/totorial_mysql/tree/main).

# 3. Feature Engineering:
This will help use generate some new columns from existing ones.

 1. Add a new column named `time_of_day` to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.

> the unswers:
```sql
					--add time_of_day---
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END);
```

 2. Add a new column named `day_name` that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.
> the unswers:
```sql
						-- Add day_name column--
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);
```

3. Add a new column named `month_name` that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.
< the unswers:
```sql
					   -- Add month_name column--
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);
```

2. **Exploratory Data Analysis (EDA):** Exploratory data analysis is done to answer the listed questions and aims of this project.

3. **Conclusion:**

# 4. Business Questions To Answer ------------------------------------

### Generic Question

1. How many unique cities does the data have?
```sql
SELECT 
	DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM sales;
```

2. In which city is each branch?
```sql
SELECT 
	DISTINCT city,
    branch
FROM sales;
```
### Product

1. How many unique product lines does the data have?
```sql
SELECT
	DISTINCT product_line
FROM sales;
```
2. What is the most common payment method?
3. What is the most selling product line?
```sql
SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;
```
4. What is the total revenue by month?
```sql
SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue;
```
5. What month had the largest COGS?
```sql
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs;
```
6. What product line had the largest revenue?
```sql
SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;
```
7. What is the city with the largest revenue?
```sql
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;
```
8. What product line had the largest VAT?
```sql
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;
```
9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
```sql

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;
```
10. Which branch sold more products than average product sold?
```sql
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);
```
11. What is the most common product line by gender?
```sql
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;
```
12. What is the average rating of each product line?
```sql
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;
```
### Sales

1. Number of sales made in each time of the day per weekday
```sql
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
```
2. Which of the customer types brings the most revenue?
```sql
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;
```
3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
```sql
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;
```
4. Which customer type pays the most in VAT?
```sql
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;
```
### Customer

1. How many unique customer types does the data have?
```sql
SELECT
	DISTINCT customer_type
FROM sales;
```
2. How many unique payment methods does the data have?
```sql
SELECT
	DISTINCT payment_method
FROM sales;
```
3. What is the most common customer type?

4. Which customer type buys the most?
```sql
SELECT
	customer_type,
    COUNT(*) AS quant_custemr # Must know diffrence between count and sum, count do from the fist to the last, sum is add up each value
FROM sales
GROUP BY customer_type
ORDER BY quant_custemr DESC;
```
5. What is the gender of most of the customers?
```sql
SELECT
	gender,
    COUNT(*) AS gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;
```
6. What is the gender distribution per branch?
```sql
SELECT
	gender,
    COUNT(*) AS gender_branch
FROM sales
WHERE branch ="A"# adding where to be selected per branch
GROUP BY gender
ORDER BY gender_branch DESC;
```
7. Which time of the day do customers give most ratings?
```sql
SELECT
	time_of_day,
    AVG(rating) AS Avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY Avg_rating DESC;
```
8. Which time of the day do customers give most ratings per branch?
```sql
SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
```
9. Which day fo the week has the best avg ratings?
```sql
SELECT
	day_name,
    AVG(rating) as avg_rat
FROM sales
GROUP BY day_name
ORDER BY avg_rat DESC;
```
10. Which day of the week has the best average ratings per branch?
```sql
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY day_name
ORDER BY avg_rating DESC;
```

## Revenue And Profit Calculations

$ COGS = unitsPrice * quantity $

$ VAT = 5\% * COGS $

$VAT$ is added to the $COGS$ and this is what is billed to the customer.

$ total(gross_sales) = VAT + COGS $

$ grossProfit(grossIncome) = total(gross_sales) - COGS $

**Gross Margin** is gross profit expressed in percentage of the total(gross profit/revenue)

$ \text{Gross Margin} = \frac{\text{gross income}}{\text{total revenue}} $

<u>**Example with the first row in our DB:**</u>

**Data given:**

- $ \text{Unite Price} = 45.79 $
- $ \text{Quantity} = 7 $

$ COGS = 45.79 * 7 = 320.53 $

$ \text{VAT} = 5\% * COGS\\= 5\%  320.53 = 16.0265 $

$ total = VAT + COGS\\= 16.0265 + 320.53 = $336.5565$

$ \text{Gross Margin Percentage} = \frac{\text{gross income}}{\text{total revenue}}\\=\frac{16.0265}{336.5565} = 0.047619\\\approx 4.7619\% $

## Code

For the rest of the code, check the [Sales.sql](https://github.com/nurastars/Sales_Analysis_MySQL/blob/main/README.md?plain=1#:~:text=WalmartSalesData.csv-,sales,-.sql) file

```sql
-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
```



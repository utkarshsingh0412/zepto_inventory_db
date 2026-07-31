CREATE DATABASE zepto_inventory;
USE zepto_inventory;
CREATE TABLE zepto(
unique_id SERIAL PRIMARY KEY,
Category VARCHAR(100),
name VARCHAR(100),
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INT,
discountedSellingPrice NUMERIC(8,2),
weightInGms INT,
outOfStock VARCHAR(10),
quantity INT
);
-- Data exploration

-- count of rows
SELECT COUNT(*)FROM ZEPTO;
-- Sample data
SELECT*FROM zepto LIMIT 100;
-- Null values
SELECT*FROM zepto
WHERE category IS NULL
or
 name IS NULL
or
 mrp IS NULL
or
 discountPercent IS NULL
or
 availableQuantity IS NULL
or
 discountedSellingPrice IS NULL
or
 weightInGms IS NULL
or
 outOfStock IS NULL
or
 quantity IS NULL;
 -- Distinct order
 SELECT DISTINCT category
 FROM zepto; 
 -- (according to alphabaticall order)
 SELECT DISTINCT category
 FROM zepto
 ORDER BY category;
 SELECT category,COUNT(*)AS quantity
 FROM zepto
 GROUP BY category
 ORDER BY category;
 -- (stock vs out of stock)
SELECT outofstock, COUNT(outofstock)AS quantity
 FROM zepto
 GROUP BY outofstock;
 -- (for cleaning some unknown data) 
UPDATE zepto
SET outofstock='NO'
WHERE outofstock IN('40','48');
-- product names prsent multiple times 
SELECT name ,count(unique_id) AS 'number of products'
FROM zepto
GROUP BY name
HAVING COUNT(unique_id)>1
ORDER BY COUNT(unique_id) DESC;
-- data cleaning
SELECT*FROM zepto
WHERE mrp=0 or discountedSellingPrice=0;
DELETE FROM zepto
WHERE mrp=0;
DELETE FROM zepto
WHERE discountedSellingPrice=0;
-- convert paise to rupees
UPDATE zepto
SET mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

-- business insight queries
-- Q1 What is the relationship between product weight and pricing strategy?  
-- Q2 Which products have the highest discount percentage, and how does that impact their sales volume?  
-- Q3 What are the top-selling products by available quantity, and do they align with high-margin or low-margin items?  
-- Q4 Which categories contribute most to revenue after discounts?
-- Q5 Are premium imported fruits priced competitively compared to local fruits ?
-- Q6 Which products frequently go out of stock, and what does that indicate about demand forecasting accuracy?  
-- Q7 Which products have the lowest discount but still maintain high availability — does this suggest strong brand loyalty?  
-- Q8 How do frozen or packaged goods compare in discounting and availability versus fresh produce?
-- Q9 Which items show the largest difference between MRP and discounted selling price, and what does that reveal about pricing flexibility?
-- Q10 Are staple items more resilient in terms of stock and pricing compared to perishable items ?

 
-- Q1 solution
SELECT name,Category,weightInGms,mrp,discountedSellingPrice,discountPercent,ROUND(discountedSellingPrice / NULLIF(weightInGms,0), 2) AS price_per_gram
FROM zepto
WHERE weightInGms > 0
ORDER BY weightInGms;

-- Q2 solution
SELECT name,Category,discountPercent,availableQuantity,discountedSellingPrice
FROM zepto
ORDER BY discountPercent DESC, 
availableQuantity DESC;

-- Q3 solution
SELECT name,Category,availableQuantity,mrp,discountedSellingPrice,
    (mrp - discountedSellingPrice) AS price_difference
FROM zepto
ORDER BY availableQuantity DESC;

-- Q4 solution
SELECT Category,SUM(discountedSellingPrice * availableQuantity) AS estimated_revenue
FROM zepto
GROUP BY Category
ORDER BY estimated_revenue DESC;

-- Q5 solution
SELECT name,Category,mrp,discountedSellingPrice,discountPercent
FROM zepto
WHERE Category LIKE '%Fruit%'
ORDER BY discountedSellingPrice DESC;

-- Q6 solution
SELECT name,Category,availableQuantity,outOfStock,discountPercent
FROM zepto
WHERE outOfStock = true
   OR outOfStock = 'TRUE'
ORDER BY availableQuantity;

-- Q7 solution
SELECT name,Category,discountPercent,availableQuantity,discountedSellingPrice
FROM zepto
ORDER BY discountPercent ASC,
         availableQuantity DESC;

-- Q8 solution
SELECT
    CASE
        WHEN Category LIKE '%Frozen%'
          OR Category LIKE '%Pack%'
          OR Category LIKE '%Munchies%'
          OR Category LIKE '%Beverages%'
        THEN 'Packaged/Frozen'
        ELSE 'Fresh Produce'
    END AS product_group,

    AVG(discountPercent) AS avg_discount,
    AVG(availableQuantity) AS avg_available_quantity,
    AVG(discountedSellingPrice) AS avg_price

FROM zepto
GROUP BY product_group;

-- Q9 solution
SELECT name,Category,mrp,discountedSellingPrice,
    (mrp - discountedSellingPrice) AS price_difference,
    discountPercent
FROM zepto
ORDER BY price_difference DESC;

-- Q10 solution
SELECT
    CASE
        WHEN Category IN (
            'Rice',
            'Atta',
            'Oil',
            'Salt',
            'Sugar',
            'Pulses',
            'Flour',
            'Spices'
        )
        THEN 'Staple'

        ELSE 'Perishable'
    END AS product_type,

    AVG(availableQuantity) AS avg_stock,
    AVG(discountPercent) AS avg_discount,
    AVG(discountedSellingPrice) AS avg_price,
    COUNT(*) AS total_products

FROM zepto
GROUP BY product_type;





 

--Who are the top 5 spending customers in each country? 
--Ensure they are marked with their position in the country with the total amount they spent.
SELECT * FROM(
  SELECT "customerid","country", 
  SUM ("quantity"*"unitprice") AS "totalprice",
  ROW_NUMBER () OVER 
  (PARTITION BY "country"
  ORDER BY SUM ("quantity"*"unitprice") DESC) 
  AS rank
FROM "retail"
GROUP BY "customerid","country") ranked
WHERE rank <=5
ORDER BY country, rank;

--BONUS: What items performed better in the United United Kingdom than France. 

SELECT "description","country",
COUNT (*) AS count_of_products
FROM "retail"
WHERE "country" IN ('United Kingdom','France') 
AND "description" Is NOT NULL
GROUP BY "description","country"
ORDER BY count_of_products DESC

--Which month has the highest sales. 
SELECT to_char("invoicedate", 'MM') AS month,
AVG ("quantity" * "unitprice") AS totalprice
FROM retail
GROUP BY to_char("invoicedate", 'MM')
ORDER BY "totalprice" DESC

--What is the month-on-month average sales? 
SELECT to_char("invoicedate", 'MM') AS month,
AVG ("quantity" * "unitprice") AS totalprice
FROM retail
GROUP BY to_char("invoicedate", 'MM')
ORDER BY "totalprice" DESC

--Which products are most commonly 
--purchased together by customers in the dataset?
SELECT invoiceno,country,description,
MAX ("quantity" * "unitprice") AS "quanity_per_price",
COUNT (*) AS record_count
FROM retail
WHERE country is not NULL
GROUP by DISTINCT ("invoiceno"),("country"),("description")
ORDER BY "quanity_per_price" DESC


--Which customers have only made a single purchase from the company?
WITH customer_purchases AS (
    SELECT "id", "country",
    COUNT(DISTINCT "invoiceno") as purchase_count
    FROM retail
    WHERE "id" is NOT NULL
    GROUP BY "id", "country"
    HAVING COUNT(DISTINCT "invoiceno") = 1
)
SELECT 
    "id", country,
    COUNT(*) as customers_with_single_purchase
FROM customer_purchases
GROUP BY "id", country
ORDER BY customers_with_single_purchase;



--How many unique products has each customer purchased?
WITH customer_purchases AS (
  SELECT "id","description",
  COUNT(DISTINCT "description") as unique_products_count
  FROM retail
  WHERE "id" IS NOT NULL
  GROUP BY "id","description"
)
SELECT * FROM customer_purchases
ORDER BY unique_products_count DESC;
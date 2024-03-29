SELECT * FROM [Fragrances].[dbo].['Lookup Table$'];
SELECT * FROM [dbo].['Percentage of Sales$'];
SELECT * FROM [dbo].['Total Sales$'];

-- get the year and week number from the [Week Commencing] column 
-- add a new column and update with year & week values
ALTER TABLE ['Percentage of Sales$']
ADD [Year Week Number] INT;

UPDATE ['Percentage of Sales$']
SET [Year Week Number] = CAST(DATEPART(YEAR, [Week Commencing]) AS VARCHAR) + RIGHT('0' + CAST(DATEPART(WEEK, [Week Commencing]) AS VARCHAR), 2);

-- remove scents that make up 0% of sales
DELETE FROM ['Percentage of Sales$']
WHERE [Percentage of Sales] = 0;

-- Seperate Product column in Lookup Table into Product (ID) and Size

-- First isolating the product ID

ALTER TABLE ['Lookup Table$']
ADD ID VARCHAR(255);

;WITH CTE AS (
    SELECT A.[Product] AS A_ID,
           CASE WHEN B.[Product ID] IS NOT NULL THEN B.[Product ID] ELSE NULL END AS ID
    FROM ['Lookup Table$'] AS A
    LEFT JOIN ['Percentage of Sales$'] AS B ON CHARINDEX(B.[Product ID], A.[Product]) > 0
)

UPDATE A
SET A.ID = CTE.ID
FROM ['Lookup Table$'] AS A
JOIN CTE ON A.[Product] = CTE.A_ID;

-- Then isolating the size
ALTER TABLE ['Lookup Table$']
ADD Size VARCHAR(16);

UPDATE ['Lookup Table$']
SET Size = LTRIM(REPLACE(Product, ID, ''))
WHERE ID <> '' AND Product LIKE ID + '%';

-- Removing the spaces, and fixing the ALLCAPS in the Scent column in Total Sales and Lookup Table

UPDATE ['Total Sales$']
SET Scent = REPLACE(Scent, ' ', '')
WHERE Scent LIKE '% %';

UPDATE ['Lookup Table$']
SET Scent = REPLACE(Scent, ' ', '')
WHERE Scent LIKE '% %';

UPDATE ['Total Sales$']
SET Scent = CONCAT(UPPER(SUBSTRING(Scent, 1, 1)), LOWER(SUBSTRING(Scent, 2, LEN(Scent))));

UPDATE ['Lookup Table$']
SET Scent = CONCAT(UPPER(SUBSTRING(Scent, 1, 1)), LOWER(SUBSTRING(Scent, 2, LEN(Scent))));

-- add additional columns to make life easier
ALTER TABLE ['Percentage of Sales$']
ADD [Weekly Sales] FLOAT(16)

ALTER TABLE ['Percentage of Sales$']
ADD [Product Name] VARCHAR(64)

-- update the product name column by joining on ID field of Lookup Table
UPDATE ['Percentage of Sales$']
SET [Product Name] = ['Lookup Table$'].Scent
FROM ['Percentage of Sales$']
INNER JOIN ['Lookup Table$'] ON ['Percentage of Sales$'].[Product ID] = ['Lookup Table$'].ID;

-- work out the weekly sales by joining on week number and scent from Total Sales 

UPDATE ['Percentage of Sales$']
SET [Weekly Sales] = ['Total Sales$'].[Total Scent Sales] * [Percentage of Sales]
FROM ['Percentage of Sales$']
INNER JOIN ['Total Sales$'] ON ['Percentage of Sales$'].[Product Name] = ['Total Sales$'].Scent AND ['Percentage of Sales$'].[Year Week Number] = ['Total Sales$'].[Year Week Number];

-- Output file format
SELECT [Year Week Number], [Product Name] AS "Scent",Size,  [Product Type], ROUND([Weekly Sales],2) AS "Sales"
FROM ['Percentage of Sales$'];
# Cleaning of Sales Data using SQL

This project was initally designed for the Week 12 2020 Data Preparation Challenge to be completed in Tableau. However, it has been entirely implemented using SQL.
## Dataset
- scent_sales.xls - The dataset containing information related to fragrance sales. Within the Excel Workbook there are 3 sheets:
  - Total Sales - Contains information on each scent and the total amount sold per week.
  - Percentage of Sales - Contains the percentage of the total sales sold for each fragrance, identified by its ID, the date it was sold, the product size and type.
  - Lookup Table - Provides the IDs for each available product.

## Tools

- SQL Server Management Studio

## Instructions

The following instructions were given in order to complete the challenge:

- The final output requires the Date to be in in the 'Year Week Number' format. 
- Remove product sizes that make up 0% of sales.
- In the Lookup Table, the Product ID and Size have been erroneously concatenated. These need to be separated.  
- Clean the Scent fields to join together the Total Sales and the Lookup Table.
- Calculate the sales per week for each scent and product size.
- Output the data

## Output

As specified in the requirements of the challenge, the final result should be a single file with the following columns:

- Year Week Number
- Scent
- Product Type
- Size
- Sales

The result has been exported as a csv file, output.csv.

## Acknowledgements
Special thanks to preppindata.com for providng an endless supply of datasets and challenges.

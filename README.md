# Zepto Inventory Analysis

A relational database project built using MySQL Workbench to manage and analyze product inventory, pricing, and stock availability.

## Project Structure
* zepto_object.sql: The main SQL script containing database creation, table schema setup, and exploratory queries.

## Database Schema (zepto_inventory)

The database consists of a single primary table named zepto with the following columns:

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| unique_id |serial primary key | Primary Key for each unique item |
| Category | VARCHAR(100) | Product category |
| name | VARCHAR(100) | Name of the product |
| mrp | NUMERIC(8,2) | Maximum Retail Price |
| discountPercent | NUMERIC(5,2) | Applied discount percentage |
| availableQuantity | INT | Current stock availability |
| discountedSellingPrice | NUMERIC(8,2) | Final selling price after discount |
| weightInGms | INT | Product weight in grams |
| outOfStock | VARCHAR(10) | Stock status flag |
| quantity | INT | Total quantity metric |

## How to Run
1. Open MySQL Workbench and connect to your local database server.
2. Open the zepto_object.sql file.
3. Execute the script to create the database, set up the table structure, and run data exploration queries#

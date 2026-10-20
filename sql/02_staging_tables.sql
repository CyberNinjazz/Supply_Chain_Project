-- DDL (Data Definition Language)
-- CREATE SCHEMA → DDL statement
-- CREATE TABLE → DDL statement
-- INSERT INTO → DML (Data Manipulation Language) statement
-- SELECT → Query (also a SQL (DML statement)

CREATE SCHEMA IF NOT EXISTS staging;

-- Staging customers table
CREATE TABLE staging.customers (
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    region VARCHAR(50)
);

-- Staging products table
CREATE TABLE IF NOT EXISTS staging.products (
    product_id VARCHAR(50),
    product_name VARCHAR(100),
    unit_price VARCHAR(50),
    stock_on_hand VARCHAR(50)
);

-- Staging orders table
CREATE TABLE IF NOT EXISTS staging.orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_date VARCHAR(50),
    status VARCHAR(50)
);

-- Staging order_items table
CREATE TABLE IF NOT EXISTS staging.order_items (
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity VARCHAR(50),
    amount VARCHAR(50)
);

-- Staging shipment table
CREATE TABLE IF NOT EXISTS staging.shipments (
    shipment_id TEXT,
    order_id TEXT,
    promised_date TEXT,
    delivered_date TEXT,
    carrier TEXT
);

SELECT COUNT(*)
FROM staging.customers;


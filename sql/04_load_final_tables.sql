-- Load validated customers from staging into the final table
INSERT INTO public.customers (
    customer_id,
    customer_name,
    region
)
SELECT
    customer_id::INT,
    customer_name,
    region
FROM staging.customers;

-- Identify regions exceeding the final table's character limit

SELECT DISTINCT region, LENGTH(region) AS character_count
FROM staging.customers
WHERE LENGTH(region) > 5;

-- Increase region column length to accommodate Central
ALTER TABLE public.customers
ALTER COLUMN region TYPE VARCHAR(20);


-- Load validated customers into the final table
INSERT INTO public.customers (
    customer_id,
    customer_name,
    region
)
SELECT
    customer_id::INT,
    customer_name,
    region
FROM staging.customers;

-- Load validated products into the final table
INSERT INTO public.products (
    product_id,
    product_name,
    unit_price,
    stock_on_hand
)
SELECT
    product_id::INT,
    product_name,
    unit_price::NUMERIC,
    stock_on_hand::INT
FROM staging.products;


-- Load valid orders, excluding records with missing order dates
INSERT INTO public.orders (
    order_id,
    customer_id,
    order_date,
    status
)
SELECT
    order_id::INT,
    customer_id::INT,
    order_date::DATE,
    status
FROM staging.orders
WHERE order_date IS NOT NULL;


-- Load valid order items with existing orders
INSERT INTO public.order_items (
    order_id,
    product_id,
    quantity,
    amount
)
SELECT
    oi.order_id::INT,
    oi.product_id::INT,
    oi.quantity::INT,
    oi.amount::NUMERIC
FROM staging.order_items AS oi
JOIN public.orders AS o
    ON oi.order_id::INT = o.order_id
WHERE oi.quantity::INT > 0
  AND oi.amount::NUMERIC >= 0;


-- Load shipments with valid order references
INSERT INTO public.shipments (
    shipment_id,
    order_id,
    promised_date,
    delivered_date,
    carrier
)
SELECT
    s.shipment_id::INT,
    s.order_id::INT,
    s.promised_date::DATE,
    s.delivered_date::DATE,
    s.carrier
FROM staging.shipments AS s
JOIN public.orders AS o
    ON s.order_id::INT = o.order_id;


-- Verify final table row counts
SELECT 'customers' AS table_name, COUNT(*) FROM public.customers
UNION ALL
SELECT 'products', COUNT(*) FROM public.products
UNION ALL
SELECT 'orders', COUNT(*) FROM public.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM public.order_items
UNION ALL
SELECT 'shipments', COUNT(*) FROM public.shipments;



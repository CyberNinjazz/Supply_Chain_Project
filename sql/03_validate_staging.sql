--Check for missing orders dates
SELECT *
FROM staging.orders
WHERE order_date IS NULL;


--Check for missing shipment dates
SELECT *
FROM staging.shipments
WHERE delivered_date IS NULL;


--Check for duplicate order IDs
SELECT order_id, COUNT(*)
FROM staging.orders
GROUP BY order_id
HAVING COUNT(*) > 1;

--Check for invalid customer references
SELECT o.order_id, o.customer_id
FROM staging.orders AS o
LEFT JOIN staging.customers AS c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Validate duplicate order IDs and unmatched customer references
SELECT
    (SELECT COUNT(*)
     FROM (
         SELECT order_id
         FROM staging.orders
         GROUP BY order_id
         HAVING COUNT(*) > 1
     ) AS duplicates) AS duplicate_order_ids,

    (SELECT COUNT(*)
     FROM staging.orders AS o
     LEFT JOIN staging.customers AS c
         ON o.customer_id = c.customer_id
     WHERE c.customer_id IS NULL) AS unmatched_customers;


-- Check for duplicate order-item combinations
SELECT order_id, product_id, COUNT(*)
FROM staging.order_items
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;

-- Check for order items referencing nonexistent products
SELECT oi.order_id, oi.product_id
FROM staging.order_items AS oi
LEFT JOIN staging.products AS p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- Check for invalid order-item quantities and amounts
SELECT *
FROM staging.order_items
WHERE quantity::INT <= 0
   OR amount::NUMERIC < 0
   OR quantity IS NULL
   OR amount IS NULL;

-- Check for invalid product prices and stock levels
SELECT *
FROM staging.products
WHERE unit_price::NUMERIC < 0
   OR stock_on_hand::INT < 0
   OR unit_price IS NULL
   OR stock_on_hand IS NULL;


-- Check shipments delivered before their promised dates
SELECT shipment_id, order_id, promised_date, delivered_date
FROM staging.shipments
WHERE delivered_date::DATE < promised_date::DATE;

-- Check for shipments delivered before the order date
SELECT s.shipment_id, s.order_id,
       o.order_date, s.delivered_date
FROM staging.shipments AS s
JOIN staging.orders AS o
    ON s.order_id = o.order_id
WHERE s.delivered_date::DATE < o.order_date::DATE;

-- Check for shipments referencing nonexistent orders
SELECT s.shipment_id, s.order_id
FROM staging.shipments AS s
LEFT JOIN staging.orders AS o
    ON s.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Check for order items referencing nonexistent orders
SELECT oi.order_id, oi.product_id
FROM staging.order_items AS oi
LEFT JOIN staging.orders AS o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Check for missing required customer information
SELECT *
FROM staging.customers
WHERE customer_id IS NULL
   OR customer_name IS NULL
   OR region IS NULL;


-- Check for missing required shipment information
SELECT *
FROM staging.shipments
WHERE shipment_id IS NULL
   OR order_id IS NULL
   OR promised_date IS NULL
   OR carrier IS NULL;

-- Check for duplicate shipment IDs
SELECT shipment_id, COUNT(*)
FROM staging.shipments
GROUP BY shipment_id
HAVING COUNT(*) > 1;


-- Check for duplicate customer IDs
SELECT customer_id, COUNT(*)
FROM staging.customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check for duplicate product IDs
SELECT product_id, COUNT(*)
FROM staging.products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- Investigate shipments associated with order 1045
SELECT *
FROM staging.shipments
WHERE order_id = '1045';


SELECT *
FROM staging.orders
WHERE order_id = '1045';

SELECT *
FROM public.orders
WHERE order_id = 1045;

-- Investigate the negative quantity for order 1091, product 4.
SELECT *
FROM staging.order_items
WHERE order_id = '1091'
  AND product_id = '4';

-- Check whether the negative-quantity record exists in the final table
SELECT *
FROM public.order_items
WHERE order_id = 1091
  AND product_id = 4;

--What would happen in a real company? We'd flag this record for investigation 
--and ask the source-system or business team whether -2 represents a return or 
--an incorrect quantity. (FOR ABOVE)


-- Identify all order items with negative quantities
SELECT *
FROM staging.order_items
WHERE quantity::INT < 0;

-- Identify order items with zero quantities
SELECT *
FROM staging.order_items
WHERE quantity::INT = 0;


-- Identify orders with missing order dates
SELECT *
FROM staging.orders
WHERE order_date IS NULL OR TRIM(order_date) = '';


-- Verify order 1054 was excluded from the final table
SELECT *
FROM public.orders
WHERE order_id = 1054;


-- Verify final order and order item counts
SELECT 'orders' AS table_name, COUNT(*) AS total
FROM public.orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM public.order_items;
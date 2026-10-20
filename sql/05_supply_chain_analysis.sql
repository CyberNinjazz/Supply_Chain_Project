-- Analyze order counts by status
SELECT
    status,
    COUNT(*) AS total_orders
FROM public.orders
GROUP BY status
ORDER BY total_orders DESC;

-- Investigate orders with unknown status
SELECT *
FROM public.orders
WHERE status = 'unknown';

-- Check original staging statuses for orders marked unknown
SELECT
    order_id,
    status
FROM staging.orders
WHERE order_id IN ('1029', '1058', '1070', '1087', '1116', '1145');

-- Calculate total order item value
SELECT
    SUM(amount) AS total_order_value
FROM public.order_items;

-- Calculate total order value by order status
SELECT
    o.status,
    COUNT(*) AS order_count,
    SUM(oi.amount) AS total_order_value
FROM public.orders o
JOIN public.order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.status
ORDER BY total_order_value DESC;


-- Find shipped orders without a matching valid order item
SELECT
    o.order_id,
    o.status
FROM public.orders o
LEFT JOIN public.order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'shipped'
  AND oi.order_id IS NULL;

-- Calculate average recorded order value for orders with valid items
SELECT
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT
        order_id,
        SUM(amount) AS order_total
    FROM public.order_items
    GROUP BY order_id
) AS order_totals;

-- Analyze shipment delivery performance
SELECT
    CASE
        WHEN delivered_date IS NULL THEN 'Not Delivered'
        WHEN delivered_date <= promised_date THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    COUNT(*) AS total_shipments
FROM public.shipments
GROUP BY delivery_status
ORDER BY total_shipments DESC;

-- Calculate on-time delivery rate for delivered shipments
SELECT
    COUNT(*) AS delivered_shipments,
    COUNT(*) FILTER (
        WHERE delivered_date <= promised_date
    ) AS on_time_shipments,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE delivered_date <= promised_date
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS on_time_delivery_pct
FROM public.shipments
WHERE delivered_date IS NOT NULL;


-- Analyze on-time delivery performance by carrier
SELECT
    carrier,
    COUNT(*) AS delivered_shipments,
    COUNT(*) FILTER (
        WHERE delivered_date <= promised_date
    ) AS on_time_shipments,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE delivered_date <= promised_date
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS on_time_delivery_pct
FROM public.shipments
WHERE delivered_date IS NOT NULL
GROUP BY carrier
ORDER BY on_time_delivery_pct DESC;

-- Calculate average days late by carrier
SELECT
    carrier,
    COUNT(*) AS late_shipments,
    ROUND(
        AVG(delivered_date - promised_date),
        2
    ) AS avg_days_late
FROM public.shipments
WHERE delivered_date > promised_date
GROUP BY carrier
ORDER BY avg_days_late DESC;

-- Analyze total recorded order value by customer region
SELECT
    c.region,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.amount) AS total_order_value
FROM public.customers c
JOIN public.orders o
    ON c.customer_id = o.customer_id
JOIN public.order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.region
ORDER BY total_order_value DESC;

-- Analyze total recorded order value by product
SELECT
    p.product_name,
    SUM(oi.quantity) AS units_ordered,
    SUM(oi.amount) AS total_order_value
FROM public.products p
JOIN public.order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_order_value DESC;


-- Compare units ordered with current stock on hand
SELECT
    p.product_name,
    p.stock_on_hand,
    SUM(oi.quantity) AS units_ordered
FROM public.products p
JOIN public.order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name, p.stock_on_hand
ORDER BY p.stock_on_hand ASC;


-- Calculate inventory-to-order ratio by product
SELECT
    p.product_name,
    p.stock_on_hand,
    SUM(oi.quantity) AS units_ordered,
    ROUND(
        p.stock_on_hand * 1.0 / NULLIF(SUM(oi.quantity), 0),
        2
    ) AS inventory_to_order_ratio
FROM public.products p
JOIN public.order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name, p.stock_on_hand
ORDER BY inventory_to_order_ratio ASC;


-- Analyze pending order quantities by product
SELECT
    p.product_name,
    p.stock_on_hand,
    SUM(oi.quantity) AS pending_units
FROM public.products p
JOIN public.order_items oi
    ON p.product_id = oi.product_id
JOIN public.orders o
    ON oi.order_id = o.order_id
WHERE o.status = 'pending'
GROUP BY p.product_name, p.stock_on_hand
ORDER BY pending_units DESC;

-- Compare available stock with pending order quantities
SELECT
    p.product_name,
    p.stock_on_hand,
    SUM(oi.quantity) AS pending_units,
    p.stock_on_hand - SUM(oi.quantity) AS stock_after_pending
FROM public.products p
JOIN public.order_items oi
    ON p.product_id = oi.product_id
JOIN public.orders o
    ON oi.order_id = o.order_id
WHERE o.status = 'pending'
GROUP BY p.product_name, p.stock_on_hand
ORDER BY stock_after_pending ASC;
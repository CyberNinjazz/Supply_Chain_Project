-- Create a reporting view for order status metrics
CREATE OR REPLACE VIEW public.vw_order_status AS
SELECT
    status,
    COUNT(*) AS total_orders
FROM public.orders
GROUP BY status;

-- Verify the order status reporting view
SELECT *
FROM public.vw_order_status
ORDER BY total_orders DESC;

-- Create a reporting view for delivery performance by carrier
CREATE OR REPLACE VIEW public.vw_carrier_performance AS
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
GROUP BY carrier;

-- Verify the carrier performance reporting view
SELECT *
FROM public.vw_carrier_performance
ORDER BY on_time_delivery_pct DESC;


-- Create a reporting view for order value by region
CREATE OR REPLACE VIEW public.vw_regional_sales AS
SELECT
    c.region,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.amount) AS total_order_value
FROM public.customers c
JOIN public.orders o
    ON c.customer_id = o.customer_id
JOIN public.order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.region;

-- Verify the regional order value reporting view
SELECT *
FROM public.vw_regional_sales
ORDER BY total_order_value DESC;


-- Create a reporting view for product performance
CREATE OR REPLACE VIEW public.vw_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS units_ordered,
    SUM(oi.amount) AS total_order_value
FROM public.products p
JOIN public.order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- Verify the product performance reporting view
SELECT *
FROM public.vw_product_performance
ORDER BY total_order_value DESC;


-- Create a reporting view for inventory and pending orders
CREATE OR REPLACE VIEW public.vw_inventory_status AS
SELECT
    p.product_id,
    p.product_name,
    p.stock_on_hand,
    COALESCE(SUM(oi.quantity) FILTER (
        WHERE o.status = 'pending'
    ), 0) AS pending_units,
    p.stock_on_hand - COALESCE(SUM(oi.quantity) FILTER (
        WHERE o.status = 'pending'
    ), 0) AS stock_after_pending
FROM public.products p
LEFT JOIN public.order_items oi
    ON p.product_id = oi.product_id
LEFT JOIN public.orders o
    ON oi.order_id = o.order_id
GROUP BY p.product_id, p.product_name, p.stock_on_hand;

-- Verify the inventory status reporting view
SELECT *
FROM public.vw_inventory_status
ORDER BY stock_after_pending ASC;

SHOW port;

SELECT current_user;
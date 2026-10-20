CREATE TABLE customers(
customer_id INT NOT NULL,
customer_name VARCHAR (40) NOT NULL,
region VARCHAR(20) NOT NULL,
PRIMARY KEY (customer_id)
);

SELECT * FROM customers;

CREATE TABLE products (
    product_id INT NOT NULL,
    product_name VARCHAR(40) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    stock_on_hand INT NOT NULL,

    PRIMARY KEY (product_id),
    CONSTRAINT chk_price CHECK (unit_price >= 0),
    CONSTRAINT chk_stock CHECK (stock_on_hand >= 0)
);

SELECT * FROM products;

CREATE TABLE orders(
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR (10),

    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

SELECT * FROM orders;

CREATE TABLE order_items(
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders (order_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id),
    CONSTRAINT chk_quantity CHECK (quantity > 0),
    CONSTRAINT chk_amount CHECK (amount >= 0)
);

SELECT * FROM order_items;

CREATE TABLE shipments(
    shipment_id	INT NOT NULL,
    order_id INT NOT NULL,
    promised_date DATE NOT NULL,
    delivered_date DATE,
    carrier VARCHAR(30) NOT NULL,

    PRIMARY KEY (shipment_id),
    FOREIGN KEY (order_id) REFERENCES orders (order_id)

);

SELECT * FROM shipments;
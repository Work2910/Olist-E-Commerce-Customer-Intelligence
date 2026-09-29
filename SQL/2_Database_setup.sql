
-- Day 3 - creates one table per cleaned CSV from Data/Processed/

USE olist_ecommerce;

DROP TABLE IF EXISTS reviews_by_order;
DROP TABLE IF EXISTS payments_by_order;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS geolocation_by_zip;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;


-- one row per customer_id (a new customer_id is created for every order)
CREATE TABLE customers (
    customer_id               VARCHAR(32) PRIMARY KEY,
    customer_unique_id        VARCHAR(32) NOT NULL,
    customer_zip_code_prefix  CHAR(5),
    customer_city             VARCHAR(100),
    customer_state            CHAR(2)
);

-- one row per product
CREATE TABLE products (
    product_id                     VARCHAR(32) PRIMARY KEY,
    product_category_name          VARCHAR(100),
    product_name_length            INT,
    product_description_length     INT,
    product_photos_qty             INT,
    product_weight_g               INT,
    product_length_cm              INT,
    product_height_cm              INT,
    product_width_cm               INT,
    product_category_name_english  VARCHAR(100)
);

-- one row per seller
CREATE TABLE sellers (
    seller_id               VARCHAR(32) PRIMARY KEY,
    seller_zip_code_prefix  CHAR(5),
    seller_city             VARCHAR(100),
    seller_state            CHAR(2)
);

-- one row per order, with the flags and columns added on Day 2
CREATE TABLE orders (
    order_id                        VARCHAR(32) PRIMARY KEY,
    customer_id                     VARCHAR(32) NOT NULL,
    customer_unique_id              VARCHAR(32) NOT NULL,
    order_status                    VARCHAR(20),
    order_purchase_timestamp        DATETIME,
    order_approved_at               DATETIME,
    order_delivered_carrier_date    DATETIME,
    order_delivered_customer_date   DATETIME,
    order_estimated_delivery_date   DATETIME,
    flag_delivered_no_date          BOOLEAN,
    flag_canceled_with_delivery     BOOLEAN,
    flag_delivered_before_purchase  BOOLEAN,
    has_items                       BOOLEAN,
    in_analysis_scope               BOOLEAN,
    purchase_month                  CHAR(7),
    delivery_days                   INT,
    is_late                         BOOLEAN,
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

-- one row per item in an order
CREATE TABLE order_items (
    order_id             VARCHAR(32),
    order_item_id        INT,
    product_id           VARCHAR(32),
    seller_id            VARCHAR(32),
    shipping_limit_date  DATETIME,
    price                DECIMAL(10, 2),
    freight_value        DECIMAL(10, 2),
    item_revenue         DECIMAL(10, 2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders (order_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers (seller_id)
);

-- one row per payment (for payment method analysis)
CREATE TABLE payments (
    order_id              VARCHAR(32),
    payment_sequential    INT,
    payment_type          VARCHAR(20),
    payment_installments  INT,
    payment_value         DECIMAL(10, 2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders (order_id)
);

-- one row per order (payments added up on Day 2)
CREATE TABLE payments_by_order (
    order_id              VARCHAR(32) PRIMARY KEY,
    payment_value         DECIMAL(10, 2),
    payment_installments  INT,
    FOREIGN KEY (order_id) REFERENCES orders (order_id)
);

-- one review per order (latest kept on Day 2); review_id isn't unique so order_id is the key
CREATE TABLE reviews_by_order (
    order_id                 VARCHAR(32) PRIMARY KEY,
    review_id                VARCHAR(32),
    review_score             INT,
    review_comment_title     VARCHAR(255),
    review_comment_message   TEXT,
    review_creation_date     DATETIME,
    review_answer_timestamp  DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders (order_id)
);

-- one row per ZIP prefix
CREATE TABLE geolocation_by_zip (
    geolocation_zip_code_prefix  CHAR(5) PRIMARY KEY,
    geolocation_lat              DECIMAL(10, 6),
    geolocation_lng              DECIMAL(10, 6),
    geolocation_city             VARCHAR(100),
    geolocation_state            CHAR(2)
);

-- indexes on columns used a lot in joins and filters
CREATE INDEX idx_orders_scope ON orders (in_analysis_scope);
CREATE INDEX idx_orders_unique_customer ON orders (customer_unique_id);
CREATE INDEX idx_items_product ON order_items (product_id);
CREATE INDEX idx_items_seller ON order_items (seller_id);
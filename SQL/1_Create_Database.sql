-- Olist E-Commerce Customer Intelligence
-- run as root: creates a dedicated database and user for this project

CREATE DATABASE IF NOT EXISTS olist_ecommerce
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- replace YOUR_PASSWORD before running, but don't save the real password in this file
DROP USER IF EXISTS 'olist_user'@'localhost';
CREATE USER 'olist_user'@'localhost' IDENTIFIED BY 'password';

-- this user can only see and change olist_ecommerce
GRANT ALL PRIVILEGES ON olist_ecommerce.* TO 'olist_user'@'localhost';
FLUSH PRIVILEGES;
-- ============================================================
-- Kathmandu Furniture House — Database Schema
-- Normalized to 3NF
-- ============================================================
-- Run this file FIRST to create the database and all tables.
-- Then run seed.sql to add categories and sample data.
-- ============================================================

CREATE DATABASE IF NOT EXISTS kathmandu_furniture;
USE kathmandu_furniture;

-- Drop in reverse FK order for a clean install
DROP TABLE IF EXISTS wishlist;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS feedback;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS allocations;
DROP TABLE IF EXISTS product_colors;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- ── 1. USERS ──────────────────────────────────────────────────────────────────
-- Stores both admin accounts and registered customers.
-- status='Pending' until admin approves; 'Active' = can log in.
-- password stores a BCrypt hash — never plaintext.
CREATE TABLE users (
    id          INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstName   VARCHAR(100) NOT NULL,
    lastName    VARCHAR(100) NOT NULL,
    email       VARCHAR(255) UNIQUE,
    phoneNumber VARCHAR(20)  UNIQUE,
    password    VARCHAR(255) NOT NULL,
    dob         DATE,
    gender      ENUM('Male','Female','Other'),
    status      ENUM('Pending','Active','Inactive') NOT NULL DEFAULT 'Pending',
    image       VARCHAR(500),
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ── 2. CATEGORIES ─────────────────────────────────────────────────────────────
-- Extracted from products to eliminate repeated strings (3NF).
CREATE TABLE categories (
    id   INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- ── 3. PRODUCTS ───────────────────────────────────────────────────────────────
-- category_id FK replaces the repeated VARCHAR category column.
-- price uses DECIMAL for financial precision (not double/float).
CREATE TABLE products (
    id             INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_name   VARCHAR(255)  NOT NULL,
    image          VARCHAR(500),
    price          DECIMAL(10,2) NOT NULL,
    availability   ENUM('In Stock','Out of Stock','Coming Soon') NOT NULL DEFAULT 'In Stock',
    description    TEXT,
    specifications TEXT,
    status         ENUM('Active','Inactive','New')               NOT NULL DEFAULT 'Active',
    category_id    INT           NOT NULL,
    rating               DECIMAL(3,1)  NOT NULL DEFAULT 0.0,
    seating_capacity     INT,
    design_style         VARCHAR(100),
    warranty_details     TEXT,
    return_policy        TEXT,
    installation_service ENUM('Yes','No','Optional') NOT NULL DEFAULT 'No',
    material             VARCHAR(100),
    frame_material       VARCHAR(100),
    dimensions           VARCHAR(100),
    weight_kg            DECIMAL(5,1),
    max_weight_capacity  INT,
    assembly_required    ENUM('Yes','No') NOT NULL DEFAULT 'No',
    care_instructions    TEXT,
    created_at           TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_rating CHECK (rating >= 0.0 AND rating <= 5.0),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- ── 4. PRODUCT COLORS ─────────────────────────────────────────────────────────
-- 1NF fix: replaces the comma-separated colors VARCHAR on the product row.
-- Each hex value is its own row, linked back to its product.
CREATE TABLE product_colors (
    id         INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_id INT         NOT NULL,
    color_hex  VARCHAR(30) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- ── 5. ORDERS ─────────────────────────────────────────────────────────────────
-- Single-table for both Normal and Customize orders.
-- Custom-specific columns are NULL for Normal orders.
CREATE TABLE orders (
    id                    INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_id           INT,
    product_id            INT,
    full_name             VARCHAR(200)  NOT NULL,
    phone_number          VARCHAR(20)   NOT NULL,
    order_type            ENUM('Normal','Customize') NOT NULL DEFAULT 'Normal',
    quantity              INT           NOT NULL DEFAULT 1,
    total_amount          DECIMAL(10,2),
    payment_method        VARCHAR(50),
    delivery_location     VARCHAR(500),
    -- Custom order fields (NULL for Normal orders)
    furniture_type        VARCHAR(100),
    design                VARCHAR(255),
    material              VARCHAR(100),
    size                  INT,
    height                DECIMAL(8,2),
    width                 DECIMAL(8,2),
    budget_range          VARCHAR(100),
    deadline              VARCHAR(100),
    installation_required ENUM('Yes','No') DEFAULT 'No',
    purpose               TEXT,
    description           TEXT,
    notes                 TEXT,
    recommendation        TEXT,
    reference_image       VARCHAR(500),
    status                ENUM('Pending','Confirmed','Processing','Shipped','Delivered','Cancelled')
                              NOT NULL DEFAULT 'Pending',
    order_date            TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id)    ON DELETE SET NULL,
    FOREIGN KEY (product_id)  REFERENCES products(id) ON DELETE SET NULL
);

-- ── 6. RETURN ORDERS ──────────────────────────────────────────────────────────
CREATE TABLE return_orders (
    id            INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id      INT,
    customer_name VARCHAR(200)  NOT NULL,
    phone_number  VARCHAR(20)   NOT NULL,
    product       VARCHAR(255)  NOT NULL,
    reason        TEXT          NOT NULL,
    status        ENUM('Pending','Approved','Rejected','Completed') NOT NULL DEFAULT 'Pending',
    return_date   DATE,
    refund_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL
);

-- ── 7. FEEDBACK ───────────────────────────────────────────────────────────────
-- Column names corrected from the original schema:
--   mail  → email  |  field → subject  |  cv → message
CREATE TABLE feedback (
    id         INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_name  VARCHAR(200) NOT NULL,
    email      VARCHAR(255) NOT NULL,
    subject    VARCHAR(255) NOT NULL,
    message    TEXT         NOT NULL,
    status     ENUM('Pending','Reviewed','Resolved') NOT NULL DEFAULT 'Pending',
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ── 8. STORAGE LOCATIONS ─────────────────────────────────────────────────────
-- Defines warehouse zones and rack numbers for organizing furniture inventory.
CREATE TABLE storage_locations (
    id          INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    zone        VARCHAR(100) NOT NULL,
    rack_number VARCHAR(50)  NOT NULL,
    description TEXT,
    capacity    INT          NOT NULL DEFAULT 0,
    status      ENUM('Available','Full','Inactive') NOT NULL DEFAULT 'Available',
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_zone_rack (zone, rack_number)
);

-- ── 9. STORAGE ASSIGNMENTS ────────────────────────────────────────────────────
-- Links products to specific storage locations with quantity tracking.
CREATE TABLE storage_assignments (
    id                  INT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_id          INT       NOT NULL,
    storage_location_id INT       NOT NULL,
    quantity            INT       NOT NULL DEFAULT 1,
    assigned_date       DATE      NOT NULL,
    notes               TEXT,
    created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id)          REFERENCES products(id)          ON DELETE CASCADE,
    FOREIGN KEY (storage_location_id) REFERENCES storage_locations(id) ON DELETE CASCADE
);

-- ── 10. SALES ─────────────────────────────────────────────────────────────────
-- selling_price records price at time of sale (products.price can change later).
CREATE TABLE sales (
    id            INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_id    INT,
    order_id      INT,
    quantity_sold INT           NOT NULL DEFAULT 1,
    selling_price DECIMAL(10,2) NOT NULL,
    sale_date     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(id)   ON DELETE SET NULL
);

-- ── 12. CART ──────────────────────────────────────────────────────────────────
-- Currently session-backed in the app; table is ready for DB persistence.
CREATE TABLE cart (
    id         INT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id    INT       NOT NULL,
    product_id INT       NOT NULL,
    quantity   INT       NOT NULL DEFAULT 1,
    added_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_cart_item (user_id, product_id),
    FOREIGN KEY (user_id)    REFERENCES users(id)    ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- ── 10. ALLOCATIONS ───────────────────────────────────────────────────────────
-- Tracks furniture issued to users or departments with issue/return dates.
CREATE TABLE allocations (
    id                    INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_id            INT           NOT NULL,
    allocated_to_user_id  INT,
    department            VARCHAR(200),
    quantity              INT           NOT NULL DEFAULT 1,
    issue_date            DATE          NOT NULL,
    expected_return_date  DATE,
    actual_return_date    DATE,
    status                ENUM('Issued','Returned','Overdue') NOT NULL DEFAULT 'Issued',
    notes                 TEXT,
    created_at            TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id)           REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (allocated_to_user_id) REFERENCES users(id)    ON DELETE SET NULL
);

-- ── 13. WISHLIST ──────────────────────────────────────────────────────────────
-- Currently session-backed in the app; table is ready for DB persistence.
CREATE TABLE wishlist (
    id         INT       NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id    INT       NOT NULL,
    product_id INT       NOT NULL,
    added_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_wishlist_item (user_id, product_id),
    FOREIGN KEY (user_id)    REFERENCES users(id)    ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

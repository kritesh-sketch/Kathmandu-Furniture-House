-- ============================================================
-- Kathmandu Furniture House — Sample Data
-- ============================================================
-- Run this file AFTER kathmandu_furniture.sql.
-- Clears existing data and inserts fresh sample records.
--
-- Test passwords are BCrypt hashes of "Test@123"
-- ============================================================

USE kathmandu_furniture;

-- Clear in reverse FK order before re-seeding
DELETE FROM wishlist;
DELETE FROM cart;
DELETE FROM sales;
DELETE FROM job_applications;
DELETE FROM job_vacancies;
DELETE FROM offers;
DELETE FROM feedback;
DELETE FROM return_orders;
DELETE FROM orders;
DELETE FROM product_colors;
DELETE FROM products;
DELETE FROM categories;
DELETE FROM users;

ALTER TABLE wishlist         AUTO_INCREMENT = 1;
ALTER TABLE cart             AUTO_INCREMENT = 1;
ALTER TABLE sales            AUTO_INCREMENT = 1;
ALTER TABLE job_applications AUTO_INCREMENT = 1;
ALTER TABLE job_vacancies    AUTO_INCREMENT = 1;
ALTER TABLE offers           AUTO_INCREMENT = 1;
ALTER TABLE feedback         AUTO_INCREMENT = 1;
ALTER TABLE return_orders    AUTO_INCREMENT = 1;
ALTER TABLE orders           AUTO_INCREMENT = 1;
ALTER TABLE product_colors   AUTO_INCREMENT = 1;
ALTER TABLE products         AUTO_INCREMENT = 1;
ALTER TABLE categories       AUTO_INCREMENT = 1;
ALTER TABLE users            AUTO_INCREMENT = 1;

-- ── USERS ─────────────────────────────────────────────────────────────────────
-- All passwords are BCrypt hash of "Test@123"
INSERT INTO users (firstName, lastName, email, phoneNumber, password, dob, gender, status) VALUES
('Admin',  'KFH',    'admin@kathmandufurniture.com',   '9800000001', '$2a$10$yUK8SPXB.NwRSviTxcIVHOxtfvwjGEe600j9g2H5xi3Y4l54A5jLa', '1990-01-01', 'Male',   'Active'),
('Ram',    'Sharma', 'ram.sharma@example.com',         '9800000002', '$2a$10$yUK8SPXB.NwRSviTxcIVHOxtfvwjGEe600j9g2H5xi3Y4l54A5jLa', '1995-06-15', 'Male',   'Active'),
('Sita',   'Thapa',  'sita.thapa@example.com',         '9800000003', '$2a$10$yUK8SPXB.NwRSviTxcIVHOxtfvwjGEe600j9g2H5xi3Y4l54A5jLa', '1998-03-22', 'Female', 'Active'),
('Bikash', 'Rai',    'bikash.rai@example.com',          '9800000004', '$2a$10$yUK8SPXB.NwRSviTxcIVHOxtfvwjGEe600j9g2H5xi3Y4l54A5jLa', '2000-11-10', 'Male',   'Pending');

-- ── CATEGORIES ────────────────────────────────────────────────────────────────
INSERT INTO categories (name) VALUES
('Sofas & Seating'),
('Beds & Mattresses'),
('Tables & Desks'),
('Chairs & Stools'),
('Decor & Rugs'),
('Storage & Cabinets');

-- ── PRODUCTS ──────────────────────────────────────────────────────────────────
-- category_id: 1=Sofas, 2=Beds, 3=Tables, 4=Chairs, 5=Decor, 6=Storage
INSERT INTO products (product_name, image, price, availability, specifications, status, category_id, rating) VALUES
-- Sofas & Seating (1)
('Oslo 3-Seater Sofa',         'oslo-sofa.jpg',         45000.00, 'In Stock',    'W:210cm H:85cm D:90cm | Fabric: Premium Linen | Legs: Solid Walnut',            'Active', 1, 4.5),
('Nordic Corner Sofa',         'nordic-corner.jpg',     72000.00, 'In Stock',    'W:280cm H:80cm D:160cm | Fabric: Velvet | Reversible Chaise',                   'New',    1, 4.8),
('Zen Loveseat',               'zen-loveseat.jpg',      28000.00, 'In Stock',    'W:145cm H:78cm D:85cm | Fabric: Cotton Blend | Removable Covers',               'Active', 1, 4.2),
('Recliner Armchair',          'recliner-chair.jpg',    18500.00, 'Coming Soon', 'W:90cm H:102cm D:95cm | Leather: Genuine | Manual Recline',                     'Active', 1, 0.0),
-- Beds & Mattresses (2)
('Himalayan King Bed',         'himalayan-king.jpg',    55000.00, 'In Stock',    'Size: King (180x200cm) | Material: Sheesham Wood | Headboard: Carved',          'Active', 2, 4.7),
('Maple Platform Bed',         'maple-platform.jpg',    38000.00, 'In Stock',    'Size: Queen (160x200cm) | Material: Maple Wood | Low-profile design',           'New',    2, 4.6),
('Cloud Ortho Mattress',       'cloud-mattress.jpg',    22000.00, 'In Stock',    'Size: Queen | Type: Memory Foam + Coil Hybrid | Thickness: 25cm',               'Active', 2, 4.9),
-- Tables & Desks (3)
('Kathmandu Dining Table',     'dining-table.jpg',      32000.00, 'In Stock',    'W:180cm H:76cm D:90cm | Material: Solid Teak | Seats 6',                       'Active', 3, 4.4),
('Executive Study Desk',       'study-desk.jpg',        19500.00, 'In Stock',    'W:140cm H:75cm D:60cm | Material: Engineered Wood | Built-in cable tray',      'Active', 3, 4.3),
('Marble Coffee Table',        'marble-coffee.jpg',     24000.00, 'In Stock',    'W:120cm H:42cm D:65cm | Top: Italian Marble | Base: Brushed Gold Metal',       'New',    3, 4.6),
-- Chairs & Stools (4)
('Ergonomic Office Chair',     'office-chair.jpg',      16000.00, 'In Stock',    'Adjustable height 45–55cm | Lumbar support | Mesh back | 360° swivel',         'Active', 4, 4.5),
('Rattan Bar Stool',           'rattan-stool.jpg',       5500.00, 'In Stock',    'H:75cm | Seat Ø:38cm | Material: Natural Rattan | Set of 2',                   'Active', 4, 4.1),
('Accent Velvet Chair',        'velvet-chair.jpg',      12000.00, 'In Stock',    'W:70cm H:85cm D:72cm | Upholstery: Velvet | Gold Tapered Legs',                'New',    4, 4.7),
-- Decor & Rugs (5)
('Bohemian Wool Rug 5x8',      'boho-rug.jpg',          14000.00, 'In Stock',    'Size: 150x240cm | Material: Hand-knotted Wool | Pattern: Geometric',            'Active', 5, 4.6),
('Himalayan Salt Lamp',        'salt-lamp.jpg',          2200.00, 'In Stock',    'Weight: ~3kg | Bulb: E14 15W | Cord: 1.5m | Natural Pink Salt',                'Active', 5, 4.8),
('Ceramic Vase Set',           'ceramic-vase.jpg',       3500.00, 'In Stock',    'Set of 3 | Heights: 15cm, 25cm, 35cm | Glazed Finish | Handcrafted',           'New',    5, 4.3),
-- Storage & Cabinets (6)
('5-Door Wardrobe',            'wardrobe-5door.jpg',    48000.00, 'In Stock',    'W:200cm H:210cm D:58cm | Material: Plywood + MDF | Mirror on center door',     'Active', 6, 4.5),
('Bedside Cabinet Pair',       'bedside-pair.jpg',       9500.00, 'In Stock',    'W:45cm H:55cm D:40cm | Material: Rubber Wood | 2 Drawers | Set of 2',          'Active', 6, 4.4),
('Floating Wall Shelf Set',    'wall-shelf.jpg',         6500.00, 'In Stock',    'Lengths: 60cm, 80cm, 100cm | Material: Solid Pine | Max load 15kg each',       'New',    6, 4.2);

-- ── PRODUCT COLORS ────────────────────────────────────────────────────────────
INSERT INTO product_colors (product_id, color_hex) VALUES
-- Oslo 3-Seater (id=1)
(1, '#C8B89A'), (1, '#6B7280'), (1, '#1F2937'),
-- Nordic Corner (id=2)
(2, '#4B5563'), (2, '#7C3AED'), (2, '#D97706'),
-- Zen Loveseat (id=3)
(3, '#F3F4F6'), (3, '#D1FAE5'),
-- Himalayan King Bed (id=5)
(5, '#92400E'), (5, '#1C1917'),
-- Maple Platform Bed (id=6)
(6, '#A16207'), (6, '#78350F'),
-- Cloud Mattress (id=7)
(7, '#F9FAFB'),
-- Kathmandu Dining Table (id=8)
(8, '#78350F'), (8, '#1C1917'),
-- Executive Desk (id=9)
(9, '#1C1917'), (9, '#F5F5F5'),
-- Marble Coffee Table (id=10)
(10, '#F9FAFB'),
-- Ergonomic Chair (id=11)
(11, '#111827'), (11, '#374151'),
-- Rattan Stool (id=12)
(12, '#D97706'),
-- Accent Velvet Chair (id=13)
(13, '#7C3AED'), (13, '#059669'), (13, '#DC2626'),
-- Boho Rug (id=14)
(14, '#B45309'), (14, '#065F46'), (14, '#1E3A5F'),
-- 5-Door Wardrobe (id=17)
(17, '#F5F5F5'), (17, '#1C1917'),
-- Bedside Pair (id=18)
(18, '#92400E'), (18, '#F5F5F5');

-- ── JOB VACANCIES ─────────────────────────────────────────────────────────────
INSERT INTO job_vacancies (title, department, location, type, description, requirements, salary_min, salary_max, status) VALUES
('Furniture Sales Executive',  'Sales',      'Kathmandu', 'Full-time',  'Drive in-store and online sales, assist customers in selecting furniture, meet monthly targets.', 'Minimum SLC passed. 1+ year sales experience. Strong communication skills.', 18000, 30000, 'Active'),
('Interior Design Consultant', 'Design',     'Kathmandu', 'Full-time',  'Provide design consultations, create room layout proposals, collaborate with sales team.',         'Bachelor in Interior Design or related. 2+ years experience. Proficient in AutoCAD.', 25000, 45000, 'Active'),
('Delivery & Assembly Staff',  'Operations', 'Kathmandu', 'Full-time',  'Deliver and assemble furniture at customer locations, ensure damage-free delivery.',              'SLC passed. Valid driving license. Physically fit. Experience preferred.',             15000, 22000, 'Active'),
('Social Media Manager',       'Marketing',  'Kathmandu', 'Part-time',  'Manage Instagram, Facebook, TikTok. Create content, run campaigns, track engagement.',           'Proven social media portfolio. Graphic design skills. Knowledge of Meta Ads.',        12000, 20000, 'Active');

-- ── OFFERS ────────────────────────────────────────────────────────────────────
INSERT INTO offers (title, event_name, discount_code, discount_type, discount_percent, discount_amount, description, status, start_date, end_date) VALUES
('Dashain Special',       'Dashain 2081',    'DASHAIN15', 'Percentage', 15.00,    0.00, 'Flat 15% off on all products during Dashain festival.',        'Active',   '2025-10-01', '2025-10-15'),
('New Year Offer',        'New Year 2082',   'NY2082',    'Percentage', 10.00,    0.00, '10% discount on orders above Rs. 20,000 for New Year.',        'Inactive', '2025-04-13', '2025-04-20'),
('Flat Rs. 2000 Off',     'Weekend Sale',    'WEEKEND2K', 'Fixed',       0.00, 2000.00, 'Rs. 2,000 off on any single product above Rs. 30,000.',        'Active',   '2025-05-10', '2025-05-31'),
('Clearance 20%',         'Stock Clearance', 'CLEAR20',   'Percentage', 20.00,    0.00, '20% off on selected Decor & Rugs items during clearance.',     'Expired',  '2025-01-01', '2025-02-28');

-- ── FEEDBACK ──────────────────────────────────────────────────────────────────
INSERT INTO feedback (user_name, email, subject, message, status) VALUES
('Ram Sharma',  'ram.sharma@example.com', 'Delivery Delay',         'My order was delayed by 3 days with no notification. Please improve communication.',        'Reviewed'),
('Sita Thapa',  'sita.thapa@example.com', 'Product Quality',        'The Oslo sofa is absolutely beautiful and well-made. Very happy with the quality!',         'Resolved'),
('Anil KC',     'anil.kc@gmail.com',      'Assembly Help Needed',   'I need assistance assembling the 5-door wardrobe. The manual is unclear on step 4.',        'Pending'),
('Meena Gurung','meena.g@example.com',    'Custom Order Query',     'Can I get the Himalayan King Bed in a different wood finish? Please advise.',               'Pending');

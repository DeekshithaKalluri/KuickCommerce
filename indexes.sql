CREATE UNIQUE INDEX cart_items_pkey ON cart_items (cart_id, product_id);
CREATE UNIQUE INDEX cart_pkey ON cart (cart_id);
CREATE UNIQUE INDEX categories_pkey ON categories (category_id);
CREATE UNIQUE INDEX givesfeedback_pkey ON givesfeedback (feedback_id);
CREATE UNIQUE INDEX hasorderitems_pkey ON hasorderitems (order_id, product_id);
CREATE UNIQUE INDEX orders_pkey ON orders (order_id);
CREATE UNIQUE INDEX products_pkey ON products (product_id);
CREATE UNIQUE INDEX users_pkey ON users (user_id);
CREATE INDEX idx_feedback_order ON givesfeedback (order_id);
CREATE INDEX idx_products_category ON products (category_id);
CREATE INDEX idx_users_lookup_id ON users (user_id); -- May be redundant if user_id is already the PK

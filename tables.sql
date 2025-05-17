-- Create Users Table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,  -- Primary Key for Users
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL, 
    password VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  
);

-- Create Categories Table
CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,  -- Primary Key for Categories
    category_name VARCHAR(100) NOT NULL  
);

-- Create Products Table
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,  -- Primary Key for Products
    product_name VARCHAR(255) NOT NULL,  
    price DECIMAL(10, 2) NOT NULL,  
    quantity INT NOT NULL,  
    category_id INT,  
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)  -- Foreign Key Constraint
);

-- Create Cart Table
CREATE TABLE Cart (
    cart_id SERIAL PRIMARY KEY,  -- Primary Key for Cart
    user_id INT,  
    FOREIGN KEY (user_id) REFERENCES Users(user_id)  -- Foreign Key Constraint
);

-- Create Cart_Items Table (Many-to-many relationship between Cart and Products)
CREATE TABLE Cart_Items (
    cart_id INT,  
    product_id INT,  
    quantity INT NOT NULL,  
    PRIMARY KEY (cart_id, product_id),  -- Composite Primary Key
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),  -- Foreign Key to Cart
    FOREIGN KEY (product_id) REFERENCES Products(product_id)  -- Foreign Key to Products
);

-- Create Orders Table
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,  -- Primary Key for Orders
    user_id INT,  
    cart_id INT,  
    total_price DECIMAL(10, 2) NOT NULL, 
    ordered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    status VARCHAR(50),  
    FOREIGN KEY (user_id) REFERENCES Users(user_id),  -- Foreign Key to Users
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id)  -- Foreign Key to Cart
);

-- Create givesfeedback Table (One-to-many relationship between Users and Orders)
CREATE TABLE givesfeedback (
    feedback_id SERIAL PRIMARY KEY,  -- Primary Key for Feedback
    user_id INT,  
    order_id INT,  
    comment TEXT,  
    rating INT CHECK (rating >= 1 AND rating <= 5),  
    FOREIGN KEY (user_id) REFERENCES Users(user_id),  -- Foreign Key to Users
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)  -- Foreign Key to Orders
);

-- Create hasorderitems Table (Many-to-many relationship between Orders and Products)
CREATE TABLE hasorderitems (
    order_id INT,  
    product_id INT,  
    quantity INT NOT NULL,  
    price DECIMAL(10, 2) NOT NULL,  
    PRIMARY KEY (order_id, product_id),  -- Composite Primary Key
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),  -- Foreign Key to Orders
    FOREIGN KEY (product_id) REFERENCES Products(product_id)  -- Foreign Key to Products
);

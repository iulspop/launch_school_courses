CREATE TABLE orders (
  id serial,
  customer_name varchar(100) NOT NULL,
  burger varchar(50),
  side varchar(50),
  drink varchar(50),
  order_total decimal(4, 2) NOT NULL
);

ALTER TABLE orders
  ADD COLUMN customer_email varchar(50),
  ADD COLUMN customer_loyalty_points integer DEFAULT 0;

ALTER TABLE orders
  ADD COLUMN burger_cost decimal(4, 2) DEFAULT 0,
  ADD COLUMN side_cost decimal(4, 2) DEFAULT 0,
  ADD COLUMN drink_cost decimal(4, 2) DEFAULT 0;

ALTER TABLE orders DROP COLUMN order_total;

INSERT INTO orders (customer_name, customer_email, customer_loyalty_points, burger, burger_cost, side, side_cost, drink, drink_cost)
  VALUES ('James Bergman', 'james1998@email.com', 28, 'LS Chicken Burger', 4.50, 'Fries', 0.99,'Cola', 1.50),
         ('Natasha O''Shea', 'natasha@osheafamily.com', 18, 'LS Chesseburger', 3.50, 'Fries', 0.99, NULL, DEFAULT),
         ('Natasha O''Shea', 'natasha@osheafamily.com', 42, 'LS Double Delux Burger', 6.00, 'Onion Rings', 1.50, 'Chocolate Shake', 2.00),
         ('Aaron Muller', NULL, 10, 'LS Burger', 3.00, NULL, DEFAULT, NULL, DEFAULT);
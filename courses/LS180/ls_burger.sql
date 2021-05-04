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

SELECT burger FROM orders WHERE burger_cost < 5 ORDER BY burger_cost ASC;

SELECT customer_name, customer_email, customer_loyalty_points FROM orders WHERE customer_loyalty_points >= 20 ORDER BY customer_loyalty_points DESC;

SELECT burger FROM orders WHERE customer_name = 'Natasha O''Shea';

SELECT customer_name FROM orders WHERE drink IS NULL;

SELECT burger, side, drink FROM orders WHERE side <> 'Fries' OR side IS NULL;

SELECT burger, side, drink FROM orders WHERE side IS NOT NULL AND drink IS NOT NULL;

SELECT avg(burger_cost) FROM orders WHERE side = 'Fries';

SELECT min(side_cost) FROM orders WHERE side IS NOT NULL;

SELECT DISTINCT(side), count(id) FROM orders WHERE side IS NOT NULL GROUP BY side;

UPDATE orders SET drink = 'Lemonade' WHERE customer_name = 'James Bergman';

UPDATE orders SET side = 'Fries', side_cost = 0.99, customer_loyalty_points = 13 WHERE customer_name = 'Aaron Muller';

UPDATE orders SET side_cost = 1.20 WHERE side = 'Fries';

SELECT customer_name, customer_loyalty_points, burger, side, drink, side_cost FROM orders;

CREATE TABLE customers (
  id serial PRIMARY KEY,
  name varchar(100)
);

CREATE TABLE email_addresses (
  customer_id serial PRIMARY KEY,
  email varchar(50) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

INSERT INTO customers (name)
  VALUES ('Natasha O''Shea'),
         ('Jame Bergman'),
         ('Aaron Muller');

INSERT INTO email_addresses (email)
  VALUES ('natasha@osheafamily.com'),
        ('james1998@email.com');

-- DELETE FROM customers WHERE name LIKE '%Natasha%';

SELECT * FROM customers;

SELECT * FROM email_addresses;

CREATE TABLE products (
  id serial PRIMARY KEY,
  name varchar(50) NOT NULL,
  cost decimal(4, 2) DEFAULT 0 NOT NULL,
  type varchar(20) NOT NULL,
  loyalty_points integer NOT NULL
);

INSERT INTO products (name, cost, type, loyalty_points)
  VALUES ('LS Burger', 3.00, 'Burger', 10),
         ('LS Cheeseburger', 3.50, 'Burger', 15 ),
         ('LS Chicken Burger', 4.50, 'Burger', 20 ),
         ('LS Double Deluxe Burger', 6.00, 'Burger', 30 ),
         ('Fries', 1.20, 'Side', 3 ),
         ('Onion Rings', 1.50, 'Side', 5 ),
         ('Cola', 1.50, 'Drink', 5 ),
         ('Lemonade', 1.50, 'Drink', 5 ),
         ('Vanilla Shake', 2.00, 'Drink', 7 ),
         ('Chocolate Shake', 2.00, 'Drink', 7 ),
         ('Strawberry Shake', 2.00, 'Drink', 7);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id serial PRIMARY KEY,
  customer_id integer REFERENCES customers(id) ON DELETE CASCADE,
  order_status varchar(20)
);

CREATE TABLE order_items(
  order_id integer REFERENCES orders(id) ON DELETE CASCADE,
  item_id integer REFERENCES products(id) ON DELETE CASCADE
);

INSERT INTO orders(customer_id, order_status)
  VALUES (2, 'In Progress'),
         (1, 'Placed'),
         (1, 'Complete'),
         (3, 'Placed');

INSERT INTO order_items(order_id, item_id)
  VALUES (1, 3),
         (1, 5),
         (1, 6),
         (1, 8),
         (2, 2),
         (2, 5),
         (2, 7),
         (3, 4),
         (3, 2),
         (3, 5),
         (3, 5),
         (3, 6),
         (3, 10),
         (3, 9),
         (4, 1),
         (4, 5);

SELECT * FROM orders;

SELECT * FROM order_items;

-- products,
-- orders
-- order_items

SELECT orders.id, products.name, products.cost, products.loyalty_points
  FROM orders
  JOIN order_items AS items ON (orders.id = items.order_id)
  JOIN products ON (items.item_id = products.id);

SELECT orders.id
  FROM orders
  JOIN order_items AS items ON (orders.id = items.order_id)
  JOIN products ON (items.item_id = products.id)
  WHERE products.name = 'Fries';

SELECT DISTINCT(customers.name) AS "Customers who like Fries"
  FROM customers
  JOIN orders ON (orders.customer_id = customers.id)
  JOIN order_items AS items ON (orders.id = items.order_id)
  JOIN products ON (items.item_id = products.id)
  WHERE products.name = 'Fries';

SELECT orders.id, sum(products.cost)
  FROM orders
    JOIN order_items ON (orders.id = order_items.order_id)
    JOIN products ON (order_items.item_id = products.id)
    JOIN customers ON (orders.customer_id = customers.id)
  WHERE customers.name = 'Natasha O''Shea'
  GROUP BY orders.id;

SELECT products.name, count(products.name)
  FROM order_items
    JOIN products ON (order_items.item_id = products.id)
    JOIN orders ON (order_items.order_id = orders.id)
  GROUP BY products.name
  ORDER BY products.name ASC;
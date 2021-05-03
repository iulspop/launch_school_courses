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
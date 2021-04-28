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
  ADD COLUMN burger_cost decimal(4, 2),
  ADD COLUMN side_cost decimal(4, 2),
  ADD COLUMN drink_cost decimal(4, 2);

ALTER TABLE orders DROP COLUMN order_total;
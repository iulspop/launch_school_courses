CREATE TABLE customers (
  id serial PRIMARY KEY,
  name text NOT NULL,
  payment_token char(8) NOT NULL UNIQUE CHECK (payment_token ~ '^[A-Z]{8}$')
);

CREATE TABLE services (
  id serial PRIMARY KEY,
  description text NOT NULL,
  price decimal(10, 2) NOT NULL CHECK (price >= 0.00)
);

CREATE TABLE customers_services (
  id serial PRIMARY KEY,
  customer_id integer REFERENCES customers(id) ON DELETE CASCADE NOT NULL,
  service_id integer REFERENCES services(id) NOT NULL,
  UNIQUE (customer_id, service_id)
);

INSERT INTO customers (name, payment_token)
VALUES
  ('Pat Johnson', 'XHGOAHEQ'),
  ('Nancy Monreal', 'JKWQPJKL'),
  ('Lynn Blake', 'KLZXWEEE'),
  ('Chen Ke-Hua', 'KWETYCVX'),
  ('Scott Lakso', 'UUEAPQPS'),
  ('Jim Pornot', 'XKJEYAZA');

INSERT INTO services (description, price)
VALUES
  ('Unix Hosting', 5.95),
  ('DNS', 4.95),
  ('Whois Registration', 1.95),
  ('High Bandwidth', 15.00),
  ('Business Support', 250.00),
  ('Dedicated Hosting', 50.00),
  ('Bulk Email', 250.00),
  ('One-to-one Training', 999.00);

INSERT INTO customers_services (customer_id, service_id)
VALUES
  (1, 1), -- Pat Johnson/Unix Hosting
  (1, 2), --            /DNS
  (1, 3), --            /Whois Registration
  (3, 1), -- Lynn Blake/Unix Hosting
  (3, 2), --           /DNS
  (3, 3), --           /Whois Registration
  (3, 4), --           /High Bandwidth
  (3, 5), --           /Business Support
  (4, 1), -- Chen Ke-Hua/Unix Hosting
  (4, 4), --            /High Bandwidth
  (5, 1), -- Scott Lakso/Unix Hosting
  (5, 2), --            /DNS
  (5, 6), --            /Dedicated Hosting
  (6, 1), -- Jim Pornot/Unix Hosting
  (6, 6), --           /Dedicated Hosting
  (6, 7); --           /Bulk Email

SELECT DISTINCT(customers.*)
  FROM customers
  JOIN customers_services
  ON customer_id = customers.id;

SELECT customers.*
  FROM customers
  LEFT JOIN customers_services
  ON customer_id = customers.id
  WHERE customer_id IS NULL;

SELECT customers.*, services.*
  FROM customers
  FULL JOIN customers_services
  ON customer_id = customers.id
  FULL JOIN services
  ON service_id = services.id
  WHERE service_id IS NULL;

SELECT services.description
  FROM customers_services
  RIGHT JOIN services
  ON service_id = services.id
  WHERE service_id IS NULL;

SELECT customers.name, string_agg(services.description, ', ')
  FROM customers
  LEFT JOIN customers_services
  ON customer_id = customers.id
  LEFT JOIN services
  ON service_id = services.id
  GROUP BY customers.name;

SELECT
  CASE
    WHEN (lag(customers.name) OVER (ORDER BY customers.name)) = customers.name THEN NULL
    ELSE customers.name
  END,
  services.description
  FROM customers
  LEFT OUTER JOIN customers_services
              ON customer_id = customers.id
  LEFT OUTER JOIN services
              ON services.id = service_id;

SELECT description, count(service_id)
  FROM customers_services
  JOIN services
    ON services.id = service_id
  GROUP BY description
  HAVING count(customers_services.customer_id) >= 3;

SELECT sum(price) AS gross
  FROM customers_services
  JOIN services
    ON services.id = service_id;

INSERT INTO customers (name, payment_token) VALUES ('John Doe', 'EYODHLCN');


INSERT INTO customers_services (customer_id, service_id)
  VALUES (
    (SELECT id FROM customers WHERE name = 'John Doe' AND payment_token = 'EYODHLCN'),
    (SELECT id FROM services WHERE description = 'Unix Hosting')
  ), (
    (SELECT id FROM customers WHERE name = 'John Doe' AND payment_token = 'EYODHLCN'),
    (SELECT id FROM services WHERE description = 'DNS')
  ), (
    (SELECT id FROM customers WHERE name = 'John Doe' AND payment_token = 'EYODHLCN'),
    (SELECT id FROM services WHERE description = 'Whois Registration')
  );

SELECT sum(price)
  FROM customers_services
  JOIN services
  ON service_id = services.id
  WHERE price > 100;

SELECT sum(price)
  FROM customers
  CROSS JOIN services
  WHERE price > 100;

-- SELECT * FROM customers WHERE name = 'Chen Ke-Hua';
DELETE FROM customers WHERE name = 'Chen Ke-Hua';

DELETE
  FROM customers_services
  USING services
  WHERE service_id = services.id AND description = 'Bulk Email';

-- SELECT * FROM services WHERE description = 'Bulk Email';
DELETE FROM services WHERE description = 'Bulk Email';


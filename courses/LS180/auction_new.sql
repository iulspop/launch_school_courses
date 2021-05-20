DROP TABLE IF EXISTS bidders CASCADE;
CREATE TABLE bidders (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

DROP TABLE IF EXISTS items CASCADE;
CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  initial_price DECIMAL(6,2) NOT NULL CHECK(initial_price BETWEEN 0.01 AND 1000.00),
  sales_price DECIMAL(6,2) CHECK(sales_price BETWEEN 0.01 AND 1000.00)
);

DROP TABLE IF EXISTS bids CASCADE;
CREATE TABLE bids (
  id SERIAL PRIMARY KEY,
  bidder_id integer NOT NULL REFERENCES bidders(id) ON DELETE CASCADE,
  item_id integer NOT NULL REFERENCES items(id) ON DELETE CASCADE,
  amount DECIMAL(6,2) NOT NULL CHECK(amount BETWEEN 0.01 AND 1000.00)
);

CREATE INDEX ON bids (bidder_id, item_id);
  
INSERT INTO bidders
  VALUES (1,'Alison Walker'),
         (2,'James Quinn'),
         (3,'Taylor Williams'),
         (4,'Alexis Jones'),
         (5,'Gwen Miller'),
         (6,'Alan Parker'),
         (7,'Sam Carter');

INSERT INTO items
  VALUES (1,'Video Game', 39.99, 70.87),
         (2,'Outdoor Grill', 51.00, 83.25),
         (3,'Painting', 100.00, 250.00),
         (4,'Tent', 220.00, 300.00),
         (5,'Vase', 20.00, 42.00),
         (6,'Television', 550.00, NULL);
  
INSERT INTO bids
  VALUES (1,1, 1, 40.00),
         (2,3, 1, 52.00),
         (3,1, 1, 53.00),
         (4,3, 1, 70.87),
         (5,5, 2, 83.25),
         (6,2, 3, 110.00),
         (7,4, 3, 140.00),
         (8,2, 3, 150.00),
         (9,6, 3, 175.00),
         (10,4, 3, 185.00),
         (11,2, 3, 200.00),
         (12,6, 3, 225.00),
         (13,4, 3, 250.00),
         (14,1, 4, 222.00),
         (15,2, 4, 262.00),
         (16,1, 4, 290.00),
         (17,1, 4, 300.00),
         (18,2, 5, 21.72),
         (19,6, 5, 23.00),
         (20,2, 5, 25.00),
         (21,6, 5, 30.00),
         (22,2, 5, 32.00),
         (23,6, 5, 33.00),
         (24,2, 5, 38.00),
         (25,6, 5, 40.00),
         (26,2, 5, 42.00);

SELECT * FROM items, bids WHERE bids.item_id *= items.id;

SELECT * FROM items
  LEFT JOIN bids
  ON bids.item_id = items.id;

-- SELECT * FROM items
--   LEFT JOIN bids
--   ON bids.item_id = items.id;

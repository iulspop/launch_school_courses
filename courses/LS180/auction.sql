CREATE TABLE bidders (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE items (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  initial_price DECIMAL(6,2) NOT NULL CHECK(initial_price BETWEEN 0.01 AND 1000.00),
  sales_price DECIMAL(6,2) CHECK(sales_price BETWEEN 0.01 AND 1000.00)
);

CREATE TABLE bids (
  id SERIAL PRIMARY KEY,
  bidder_id integer NOT NULL REFERENCES bidders(id) ON DELETE CASCADE,
  item_id integer NOT NULL REFERENCES items(id) ON DELETE CASCADE,
  amount DECIMAL(6,2) NOT NULL CHECK(amount BETWEEN 0.01 AND 1000.00)
);

CREATE INDEX ON bids (bidder_id, item_id);

COPY bidders FROM '/home/joy/Uber_Dev/learning_projects/launch_school_courses/courses/LS180/bidders.csv'
  WITH (FORMAT CSV, HEADER TRUE);

COPY items FROM '/home/joy/Uber_Dev/learning_projects/launch_school_courses/courses/LS180/items.csv'
  WITH (FORMAT CSV, HEADER TRUE);

COPY bids FROM '/home/joy/Uber_Dev/learning_projects/launch_school_courses/courses/LS180/bids.csv'
  WITH (FORMAT CSV, HEADER TRUE);

SELECT name AS "Bid on Items" FROM items
  WHERE id IN (SELECT item_id FROM bids);

SELECT name AS "Not Bid On" FROM items
  WHERE id NOT IN (SELECT item_id FROM bids);

SELECT name FROM bidders
  WHERE EXISTS (SELECT bidder_id FROM bids WHERE bidders.id = bidder_id);

SELECT DISTINCT(name)
  FROM bidders
  JOIN bids
  ON bidders.id = bids.bidder_id;

CREATE VIEW max_bids AS (
  SELECT count(id) AS "max"
  FROM bids
  GROUP BY bidder_id
  ORDER BY "max" DESC LIMIT 1
  );

SELECT * FROM max_bids;

SELECT name, (SELECT count(item_id) FROM bids WHERE item_id = items.id)
  FROM items;

SELECT name, count(item_id)
  FROM items
  LEFT JOIN bids
  ON items.id = bids.item_id
  GROUP BY name;

SELECT id FROM items WHERE ROW('Painting', 100.00, 250.00) = ROW(name, initial_price, sales_price);

EXPLAIN ANALYZE SELECT name FROM bidders
WHERE EXISTS (SELECT 1 FROM bids WHERE bids.bidder_id = bidders.id);

EXPLAIN ANALYZE SELECT COUNT(bidder_id) AS max_bid FROM bids
  GROUP BY bidder_id
  ORDER BY max_bid DESC
  LIMIT 1;

EXPLAIN ANALYZE SELECT MAX(bid_counts.count) FROM
  (SELECT COUNT(bidder_id) FROM bids GROUP BY bidder_id) AS bid_counts;


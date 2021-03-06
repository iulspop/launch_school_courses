CREATE TABLE temperatures (
  date date DEFAULT CURRENT_DATE NOT NULL,
  low integer NOT NULL,
  high integer NOT NULL
);

INSERT INTO temperatures VALUES ('2016-03-01', 34, 43);
INSERT INTO temperatures VALUES ('2016-03-02', 32, 44);
INSERT INTO temperatures VALUES ('2016-03-03', 31, 47);
INSERT INTO temperatures VALUES ('2016-03-04', 33, 42);
INSERT INTO temperatures VALUES ('2016-03-05', 39, 46);
INSERT INTO temperatures VALUES ('2016-03-06', 32, 43);
INSERT INTO temperatures VALUES ('2016-03-07', 29, 32);
INSERT INTO temperatures VALUES ('2016-03-08', 23, 31);
INSERT INTO temperatures VALUES ('2016-03-09', 17, 28);

SELECT date, round((low + high) / 2, 1) AS average FROM temperatures WHERE date BETWEEN '2016-03-02' AND '2016-03-08';

ALTER TABLE temperatures ADD rainfall integer DEFAULT 0 NOT NULL;

UPDATE temperatures SET rainfall = ((high + low) / 2 - 35) WHERE (high + low) / 2 > 35;

ALTER TABLE temperatures ALTER rainfall TYPE decimal(5, 3);

UPDATE temperatures SET rainfall = rainfall * 0.039;

ALTER TABLE temperatures RENAME TO weather;

SELECT * FROM weather;
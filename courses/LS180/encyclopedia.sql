CREATE TABLE countries (
  id serial,
  name varchar(50) UNIQUE NOT NULL,
  capital varchar(50) NOT NULL,
  population integer
);

CREATE TABLE famous_people (
  id serial,
  name varchar(100) NOT NULL,
  occupation varchar(150),
  date_of_birth varchar(50),
  deceased boolean DEFAULT false
);

CREATE TABLE animals (
  id serial,
  name varchar(100) NOT NULL,
  binomial_name varchar(100) NOT NULL,
  max_weight_kg decimal(8, 3),
  max_age_years integer,
  conservation_status char(2)
);

ALTER TABLE famous_people RENAME TO celebrities;

ALTER TABLE celebrities RENAME COLUMN name TO first_name;
ALTER TABLE celebrities ALTER COLUMN first_name TYPE varchar(80);

ALTER TABLE celebrities ADD COLUMN last_name varchar(100) NOT NULL;

ALTER TABLE celebrities ALTER COLUMN date_of_birth TYPE date USING date_of_birth::date;

ALTER TABLE animals ALTER COLUMN max_weight_kg TYPE decimal(10, 4);

ALTER TABLE animals ADD CONSTRAINT unique_binomial_name UNIQUE(binomial_name);

INSERT INTO countries (name, capital, population) VALUES ('France', 'Paris', 67158000);

INSERT INTO countries (name, capital, population)
  VALUES ('USA', 'Washington D.C.', 325365189),
         ('Germany', 'Berlin', 82349400),
         ('Japan', 'Tokyo', 126672000);

INSERT INTO celebrities (first_name, last_name, occupation, date_of_birth, deceased)
  VALUES ('Bruce', 'Springsteen', 'Singer, Songwriter', '1949-09-23', false),
         ('Scarlett', 'Johansson', 'Actress', '1984-11-22', DEFAULT),
         ('Frank', 'Sinatran', 'Singer', '1915-12-12', true),
         ('Tom', 'Cruise', 'Actor', '1962-07-03', DEFAULT);

ALTER TABLE celebrities ALTER COLUMN last_name DROP NOT NULL;

INSERT INTO celebrities (first_name, last_name, occupation, date_of_birth, deceased)
  VALUES ('Madonna', NULL, 'Singer, Actress', '1958-09-23', DEFAULT),
         ('Prince', NULL, 'Singer, Songwriter, Musician, Actor', '1958-11-22', true),
         ('Elvis', 'Presley', 'Singer, Musician, Actor', '1935-01-08', NULL);

ALTER TABLE animals DROP CONSTRAINT unique_binomial_name;

INSERT INTO animals (name, binomial_name, max_weight_kg, max_age_years, conservation_status)
  VALUES ('Dove', 'Columbidae Columbiformes', 2, 15, 'LC'),
         ('Golden Eagle', 'Aquila Chrysaetos', 6.35, 24, 'LC'),
         ('Peregrine Falcon', 'Falco Peregrinus', 1.5, 15, 'LC'),
         ('Pigeon', 'Columbidae Columbiformes', 2, 15, 'LC'),
         ('Kakapo', 'Strigops habroptila', 4, 60, 'CR');

SELECT population FROM countries WHERE name = 'USA';

SELECT population, capital FROM countries;

SELECT name FROM countries ORDER BY name;

SELECT name, capital FROM countries ORDER BY population;

SELECT name, capital FROM countries ORDER BY population ASC;

SELECT name, binomial_name, max_weight_kg, max_age_years FROM animals ORDER BY max_age_years;

SELECT name FROM countries WHERE population > 70000000 AND population < 200000000;

SELECT first_name, last_name FROM celebrities WHERE deceased != true OR deceased IS NULL;

SELECT first_name, last_name, occupation FROM celebrities WHERE occupation LIKE '%Singer%';

SELECT first_name, last_name, occupation FROM celebrities WHERE occupation LIKE '%Act%';

SELECT first_name, last_name, occupation FROM celebrities WHERE (occupation LIKE '%Actor%' OR occupation LIKE '%Actress%') AND occupation LIKE '%Singer%';

SELECT * FROM countries LIMIT 1;

SELECT name FROM countries ORDER BY population DESC LIMIT 1;

SELECT name FROM countries ORDER BY population DESC LIMIT 1 OFFSET 1;

SELECT DISTINCT(binomial_name) FROM animals;

SELECT binomial_name FROM animals ORDER BY length(binomial_name) DESC LIMIT 1;

SELECT first_name FROM celebrities WHERE date_part('year', date_of_birth) = 1958;

SELECT max(max_age_years) FROM animals;

SELECT avg(max_weight_kg) FROM animals;

SELECT count(id) FROM countries;

SELECT sum(population) FROM countries;

SELECT DISTINCT(conservation_status), count(id) FROM animals GROUP BY conservation_status;
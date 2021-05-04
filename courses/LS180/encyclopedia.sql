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

ALTER TABLE animals ADD COLUMN class varchar(100);

UPDATE animals SET class = 'Aves';

ALTER TABLE animals
  ADD phylum varchar(100),
  ADD kingdom varchar(100);

UPDATE animals
  SET phylum = 'Chordata',
      kingdom = 'Animalia';

ALTER TABLE countries ADD continent varchar(50);

UPDATE countries SET continent = 'Europe' WHERE name = 'France' OR name = 'Germany';
UPDATE countries SET continent = 'Asia' WHERE name = 'Japan';
UPDATE countries SET continent = 'North America' WHERE name = 'USA';

UPDATE celebrities SET deceased = true WHERE first_name = 'Elvis';
ALTER TABLE celebrities ALTER COLUMN deceased SET NOT NULL;

DELETE FROM celebrities WHERE first_name = 'Tom' AND last_name = 'Cruise';

-- CREATE TABLE singers AS SELECT * FROM celebrities WHERE occupation LIKE '%Singer%';

ALTER TABLE celebrities RENAME TO singers;

DELETE FROM singers WHERE occupation NOT LIKE '%Singer%';

CREATE TABLE continents (
  id serial PRIMARY KEY,
  name varchar(50)
);

DELETE FROM countries;

ALTER TABLE countries DROP continent;

ALTER TABLE countries ADD continent_id integer;

ALTER TABLE countries ADD FOREIGN KEY (continent_id) REFERENCES continents(id);

INSERT INTO continents (name)
  VALUES ('Africa'),
         ('Asia'),
         ('Europe'),
         ('North America'),
         ('South America');

INSERT INTO countries (name, capital, population, continent_id)
  VALUES ('Brazil', 'Brasilia', 67158000, 5),
         ('Egypt', 'Cairo', 96308900, 1),
         ('France', 'Paris', 67158000, 3),
         ('Germany', 'Berlin', 82349400, 3),
         ('Japan', 'Tokyo', 126672000, 2),
         ('USA', 'Washington D.C.', 325365189, 4);

DROP TABLE IF EXISTS singers;
CREATE TABLE singers(
  id serial PRIMARY KEY,
  name varchar(100) NOT NULL
);

CREATE TABLE albums (
  id serial PRIMARY KEY,
  album_name varchar(100) NOT NULL,
  released date NOT NULL,
  genre varchar(100) NOT NULL,
  label varchar(100) NOT NULL,
  singer_id integer REFERENCES singers(id)
);

INSERT INTO singers (name)
  VALUES ('Bruce Springsteen'),
         ('Turtle Master'),
         ('Orange Dragon'),
         ('Venomous Racoon'),
         ('Madonna'),
         ('Prince'),
         ('Elvis Presley');

INSERT INTO albums (album_name, released, genre, label, singer_id)
  VALUES ('Born to Run', '1975-08-25', 'Rock and roll', 'Columbia', 1),
         ('Purple Rain', '1984-06-25', 'Pop, R&B, Rock', 'Warner Bros', 6),
         ('Born in the USA', '1984-06-04', 'Rock and roll, pop', 'Columbia', 1),
         ('Madonna', '1983-07-27', 'Dance-pop, post-disco', 'Warner Bros', 5),
         ('True Blue', '1986-06-30', 'Dance-pop, Pop', 'Warner Bros', 5),
         ('Elvis', '1956-10-19', 'Rock and roll, Rhythm and Blues', 'RCA Victor', 7),
         ('Sign o'' the Times', '1987-03-30', 'Pop, R&B, Rock, Funk', 'Paisley Park, Warner Bros', 6),
         ('G.I. Blues', '1960-10-01', 'Rock and roll, Pop', 'RCA Victor', 7);

SELECT countries.name, continents.name AS continent FROM countries JOIN continents ON (countries.continent_id = continents.id);

SELECT countries.name, countries.capital FROM countries JOIN continents ON (countries.continent_id = continents.id) WHERE continents.name = 'Europe';

SELECT DISTINCT(singers.name) FROM singers JOIN albums ON (singers.id = albums.singer_id) WHERE albums.label = 'Warner Bros';

SELECT singers.name FROM singers LEFT JOIN albums ON (singers.id = albums.singer_id) WHERE albums.singer_id IS NULL;

SELECT name FROM singers WHERE id NOT IN (SELECT singer_id FROM albums);
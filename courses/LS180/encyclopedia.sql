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


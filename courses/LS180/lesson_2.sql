CREATE TABLE people (
  name       varchar(100),
  age        integer,
  occupation varchar(150)
);

INSERT INTO people (name, age, occupation) VALUES ('Abby', 34, 'biologist');
INSERT INTO people (name, age) VALUES ('Mu''nisah', 26);
INSERT INTO people (name, age, occupation) VALUES ('Mirabelle', 40, 'contractor');

SELECT * FROM people WHERE name = 'Mu''nisah';
SELECT * FROM people WHERE age = 26;
SELECT * FROM people WHERE occupation IS NULL;

CREATE TABLE birds (
  name varchar(100),
  length decimal(4, 1),
  wingspan decimal(4, 1),
  family varchar(100),
  exctinct boolean
);

INSERT INTO birds VALUES ('Spotted Towhee', 21.6, 26.7, 'Emberizidae', false);
INSERT INTO birds VALUES ('American Robin', 25.5, 36.0, 'Turdidae', false);
INSERT INTO birds VALUES ('Greater Koa Finch', 19.0, 24.0, 'Fringillidae', true);
INSERT INTO birds VALUES ('Carolina Parakeet', 33.0, 55.8, 'Psittacidae', true);
INSERT INTO birds VALUES ('Common Kestrel', 35.5, 73.5, 'Falconidae', false);

SELECT name, family FROM birds WHERE exctinct = false ORDER BY length DESC;

SELECT min(wingspan), round(avg(wingspan), 1), max(wingspan) FROM birds;

CREATE TABLE menu_items (
    item text,
    prep_time integer,
    ingredient_cost numeric(4,2),
    sales integer,
    menu_price numeric(4,2)
);

INSERT INTO menu_items VALUES ('omelette', 10, 1.50, 182, 7.99);
INSERT INTO menu_items VALUES ('tacos', 5, 2.00, 254, 8.99);
INSERT INTO menu_items VALUES ('oatmeal', 1, 0.50, 79, 5.99);

SELECT item, menu_price - ingredient_cost AS profit FROM menu_items ORDER BY profit DESC;

SELECT item, menu_price, ingredient_cost, round((prep_time / 60.0) * 13, 2) AS labour, round(menu_price - ingredient_cost - ((prep_time / 60.0) * 13), 2) AS profit FROM menu_items ORDER BY profit DESC;

DROP TABLE IF EXISTS public.films;
CREATE TABLE films (title varchar(255), "year" integer, genre varchar(100));

INSERT INTO films(title, "year", genre) VALUES ('Die Hard', 1988, 'action');
INSERT INTO films(title, "year", genre) VALUES ('Casablanca', 1942, 'drama');
INSERT INTO films(title, "year", genre) VALUES ('The Conversation', 1974, 'thriller');

SELECT * FROM films WHERE length(title) < 12;

ALTER TABLE films ADD director varchar(100), ADD duration integer;

UPDATE films
  SET director = 'John McTiernan',
      duration = 132
  WHERE title = 'Die Hard';

UPDATE films
  SET director = 'Michael Curtiz',
      duration = 102
  WHERE title = 'Casablanca';

UPDATE films
  SET director = 'Francis Ford Coppola',
      duration = 113
  WHERE title = 'The Conversation';

INSERT INTO films (title, year, genre, director, duration)
  VALUES ('1984', 1956, 'scifi', 'Michael Anderson', 90),
         ('Tinker Tailor Soldier Spy', 2011, 'espionage',
           'Tomas Alfredson', 127),
         ('The Birdcage', 1996, 'comedy', 'Mike Nichols', 118);

SELECT title, extract("year" from NOW()) - year AS age FROM films ORDER BY age;

SELECT title, duration FROM films WHERE duration > 120 ORDER BY duration DESC;

SELECT title FROM films ORDER BY duration DESC LIMIT 1;
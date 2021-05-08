CREATE TABLE stars (
  id serial PRIMARY KEY,
  name varchar(25) UNIQUE NOT NULL,
  distance integer NOT NULL CHECK (distance > 0),
  spectral_type char(1),
  companions integer NOT NULL CHECK (companions >= 0)
);

CREATE TABLE planets (
  id serial PRIMARY KEY,
  designation char(1),
  mass integer
);

ALTER TABLE planets ADD star_id integer NOT NULL REFERENCES stars(id);

ALTER TABLE stars ALTER COLUMN name TYPE varchar(50);

ALTER TABLE stars ALTER distance TYPE decimal;

ALTER TABLE stars ALTER spectral_type SET NOT NULL;

ALTER TABLE stars ADD CONSTRAINT stars_spectral_type_check CHECK(spectral_type IN ('O', 'B', 'A', 'F', 'G', 'K', 'M'));

ALTER TABLE stars DROP CONSTRAINT stars_spectral_type_check;

CREATE TYPE spectral_type_enum AS ENUM ('O', 'B', 'A', 'F', 'G', 'K', 'M');
ALTER TABLE stars ALTER spectral_type TYPE spectral_type_enum USING spectral_type::spectral_type_enum;

ALTER TABLE planets
  ALTER mass TYPE decimal,
  ALTER mass SET NOT NULL,
  ADD CHECK (mass > 0),
  ALTER designation SET NOT NULL;

ALTER TABLE planets ADD semi_major_axis decimal NOT NULL;

CREATE TABLE moons (
  id serial PRIMARY KEY,
  designation integer NOT NULL,
  semi_major_axis decimal CHECK (semi_major_axis > 0),
  mass decimal CHECK (mass > 0),
  planet_id integer NOT NULL REFERENCES planets(id)
);

-- SELECT * FROM stars;
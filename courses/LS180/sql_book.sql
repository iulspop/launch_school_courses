CREATE TABLE users (
  id serial,
  username varchar(25),
  enabled boolean DEFAULT true
);
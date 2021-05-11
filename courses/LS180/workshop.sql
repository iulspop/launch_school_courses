CREATE TABLE devices (
  id serial PRIMARY KEY,
  name varchar(100) NOT NULL,
  created_at timestamp DEFAULT NOW()
);

CREATE TABLE parts (
  id serial PRIMARY KEY,
  part_number integer UNIQUE NOT NULL,
  device_id integer REFERENCES devices(id)
);

INSERT INTO devices (name) VALUES ('Accelerometer'), ('Gyroscope');

INSERT INTO parts (part_number, device_id) VALUES (12, 1);
INSERT INTO parts (part_number, device_id) VALUES (14, 1);
INSERT INTO parts (part_number, device_id) VALUES (16, 1);

INSERT INTO parts (part_number, device_id) VALUES (31, 2);
INSERT INTO parts (part_number, device_id) VALUES (33, 2);
INSERT INTO parts (part_number, device_id) VALUES (35, 2);
INSERT INTO parts (part_number, device_id) VALUES (37, 2);
INSERT INTO parts (part_number, device_id) VALUES (39, 2);

INSERT INTO parts (part_number) VALUES (50);
INSERT INTO parts (part_number) VALUES (54);
INSERT INTO parts (part_number) VALUES (58);

SELECT devices.name, parts.part_number
  FROM devices
       JOIN parts
       ON devices.id = parts.device_id;

SELECT * FROM parts WHERE left(right(part_number::text, 2), 1) = '3';

SELECT devices.name, count(parts.part_number)
  FROM devices
       JOIN parts
       ON devices.id = parts.device_id
  GROUP BY devices.name
  ORDER BY devices.name DESC;

SELECT part_number, device_id FROM parts WHERE device_id IS NOT NULL;

SELECT part_number, device_id FROM parts WHERE device_id IS NULL;

INSERT INTO devices (name) VALUES ('Magnetometer');
INSERT INTO parts (part_number, device_id) VALUES (42, 3);

SELECT name FROM devices ORDER BY created_at ASC LIMIT 1;

DELETE FROM parts WHERE device_id = 1;
DELETE FROM devices WHERE name = 'Accelerometer';
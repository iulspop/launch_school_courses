SELECT count(id) FROM tickets;

SELECT count(DISTINCT(customer_id)) FROM tickets;

SELECT round( (SELECT count(DISTINCT(customer_id)) FROM tickets)::decimal
            / (SELECT count(customers.id) FROM customers)::decimal * 100,
            2)
       AS percent;

SELECT events.name, count(tickets.id) AS popularity
  FROM tickets
  RIGHT JOIN events
    ON tickets.event_id = events.id
  GROUP BY events.name
  ORDER BY popularity DESC;

SELECT customers.id, customers.email, count(DISTINCT(event_id))
  FROM customers
  JOIN tickets
    ON customers.id = tickets.customer_id
  GROUP BY customers.id
  HAVING count(DISTINCT(event_id)) = 3;

SELECT e.name, e.starts_at, sec.name, s.row, s.number AS seat
  FROM tickets AS t
  JOIN events AS e
    ON t.event_id = e.id
  JOIN seats AS s
    ON t.seat_id = s.id
  JOIN sections AS sec
    ON s.section_id = sec.id
  JOIN customers AS c
    ON t.customer_id = c.id
  WHERE c.email = 'gennaro.rath@mcdermott.co';
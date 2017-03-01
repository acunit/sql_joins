-- DVD Rental Database Challenges

-- Which customer placed the orders on the earliest date?
SELECT
  cust.*
FROM
  customers cust JOIN
  rentals rent ON (rent.customer_id = cust.customer_id)
ORDER BY
  rental_date ASC
LIMIT 1;

-- What did they order?
SELECT
  films.*
FROM
  customers cust JOIN
  rentals rent ON (rent.customer_id = cust.customer_id) JOIN
  inventory inv ON (inv.inventory_id = rent.inventory_id) JOIN
  films ON (films.film_id = inv.film_id)
ORDER BY
  rent.rental_date ASC
LIMIT 1;

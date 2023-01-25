
Use sakila;

-- 1 How many copies of the film Hunchback Impossible exist in the inventory system?
select count(title),f.film_id  from sakila.film f
join inventory i
on f.film_id = i.film_id
where title = 'Hunchback Impossible'
group by f.film_id;

select * from sakila.film
where title = 'Hunchback Impossible';

-- 2 List all films whose length is longer than the average of all the films.

select title, length from sakila.film
where length > (
	select avg(length) from sakila.film
    );
    
select * from film_actor;
-- 3 Use subqueries to display all actors who appear in the film Alone Trip..
select actor_id from film_actor fa
join film f
on fa.film_id = f.film_id
where f.title = 'Alone Trip';

-- 4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select * from category;

select film_id from film_category fc
join category c
on fc.category_id = c.category_id
where fc.category_id = '8';

-- 5 Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select * from country;

select first_name, last_name, email from customer c
join address a
on c.address_id = a.address_id
join city as cy
on a.city_id = cy.city_id
join country cry
on cy.country_id = cry.country_id
where cry.country = 'Canada'; 

-- 6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT film_id, count(actor_id) as count
FROM film_actor
GROUP BY film_id
ORDER BY count DESC
LIMIT 1;


-- 7 Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments


SELECT c.customer_id, SUM(p.amount) as total_spent FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;

SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) as total_spent, r.inventory_id,c.customer_id  FROM customer c
JOIN payment p 
ON c.customer_id = p.customer_id
JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING total_spent = (SELECT SUM(p.amount) as total_spent FROM customer c 
JOIN payment p 
ON c.customer_id = p.customer_id 
GROUP BY c.customer_id, c.first_name, c.last_name 
ORDER BY total_spent DESC LIMIT 1);

CREATE VIEW customer_total_payment AS (
select customer_id, sum(amount) as 'sum_payment' from payment group by customer_id);

select title from film where film_id in (
select film_id from inventory where inventory_id in (
select inventory_id from rental where customer_id in (
select customer_id from customer_total_payment where sum_payment in  
(select max(sum_payment) from customer_total_payment)
)
)
);

-- 8 Customers who spent more than the average payments.

select first_name, last_name from customer c
where customer_id in (
select customer_id from payment
	where amount > 
    (select avg(amount) from payment));
use sakila;

# 1a. 
select first_name, last_name
from actor;

# 1b. 
select (UPPER(CONCAT(first_name, ' ', last_name) as 'Actor_Name'))
from actor;

# 2a. 
select actor_id, first_name, last_name 
from actor
where first_name = "Joe";

# 2b. 
select actor_id, first_name, last_name
from actor
where last_name like '%GEN%';

# 2c. 
select actor_id, first_name, last_name
from actor
where last_name like '%LI%'
order by last_name, first_name Desc;

# 2d. 
select country_id, country
from country
where country IN ('Afghanistan', 'Bangladesh', 'China');

# 3a. 
alter table actor
add column middle_name VARCHAR(25) AFTER first_name;

# 3b. 
alter table actor 
add column description blob;

# 3c. 
alter table actor
drop description;

# 4a. 
select last_name "count(last_name)" as 'Number of Actors'
from actor group by last_name;

# 4b. 
select last_name "count(last_name)" as 'Number of Actors'
from actor group by last_name HAVING count(*) >=2;

# 4c. 
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = "Williams";

# 4d. 
update actor
set first_name = 'Groucho'
WHERE actor_id = 172;

# 5a. 
 describe sakila.address;
 
 # 6a 
 select first_name, last_name, address
 from staff s
 join address a
 on s.address_id = a.address_id;
 
 # 6b 
 select payment.staff_id, staff.first_name, staff.last_name, payment.amount, payment.payment_date
 from staff inner join payment on
 staff.staff_id = payment.staff_id and payment_date like '2005-08%';
 
 # 6c 
 select film.title as 'Film Title', count (film_actor.actor_id) as 'Number of actors'
 from film_actor fa
 inner join film f
 on film_actor.film_id = film.film_id
 group by film.title;
 
 # 6d 
 select title (
 select count(*) from inventory
 where film.film_id = inventory.film_id
 ) as 'Number of Copies'
 from film
 where title = 'Hunchback Impossible';
 
 # 6e. 
 select c.first_name, c.last_name, sum (p.amount) as 'Total Paid'
 from customer c
 join payment p
 on c.customer_id = p.customer_id
 group by c.last_name;
 
# 7a.  
select title
from film where title 
like 'K%' or title like 'Q%'
and title in 
(
select title 
from film 
where language_id = 1
);

# 7b.

select first_name, last_name
from actor
where actor_id IN
(
select actor_id
from film_actor
where film_id in
(
select film_id
from film
where title = 'Alone Trip'
));

# 7c.
select cus.first_name, cus.last_name, cus.email 
from customer cus
join address a 
on (cus.address_id = a.address_id)
join city cty
on (cty.city_id = a.city_id)
join country
on (country.country_id = cty.country_id)
where country.country= 'Canada';

# 7d.
select title, description from film
where film_id in
(
select film_id from film_category
where category_id in
(
select category_id in
(
select category_id from category
where name = 'Family'
	));

# 7e. Display the most frequently rented movies in descending order

select f.title, count (rental_id) as 'Times Rented'
from rental r
join inventory i
on (r.inventory_id = i.inventory_id)
join film f
on (i.film_id = f.film_id)
group by f.title
order by `Times Rented` desc;

# 7f.

select s.store_id, sum(amount) as 'Revenue'
from payment p
join rental r
on (p.rental_id = r.rental_id)
join inventory i
on (i.inventory_id = r.inventory_id)
join store s
on (s.store_id = i.store_id)
group by s.store_id;

# 7g.

select s.store_id, city.city, country.country 
from store s
join address a 
on (s.address_id = a.address_id)
join city city
on (city.city_id = a.city_id)
join country
on (country.country_id = cty.country_id);

# 7h.

select c.name as 'Genre', sum(p.amount) as 'Gross' 
from category c
join film_category fc 
on (c.category_id=fc.category_id)
join inventory i 
on (fc.film_id=i.film_id)
join rental r 
on (i.inventory_id=r.inventory_id)
join payment p 
on (r.rental_id=p.rental_id)
group by c.name order by Gross  limit 5;

# 8a.

create view genre_revenue as
select c.name as 'Genre', sum(p.amount) as 'Gross' 
from category c
join film_category fc 
on (c.category_id=fc.category_id)
join inventory i 
on (fc.film_id=i.film_id)
join rental r 
on (i.inventory_id=r.inventory_id)
join payment p 
on (r.rental_id=p.rental_id)
group by c.name order by Gross limit 5;

# 8b.
select * from genre_revenue;

# 8c.
drop view genre_revenue;
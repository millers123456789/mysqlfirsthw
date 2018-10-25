USE sakila;

##1a. Display the first and last names of all actors from the table actor.
SELECT first_name
FROM actor;

SELECT last_name
FROM actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT first_name, last_name,
CONCAT_WS(' ', first_name, last_name) As 'Actor Name'
FROM actor;

# 2a.You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor 
WHERE first_name = "Joe";


#2b. Find all actors whose last name contain the letters GEN
SELECT * FROM actor
WHERE last_name LIKE "%GEN%";

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order
SELECT * FROM actor 
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

SELECT * FROM 
country;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
SELECT country_id, country
FROM country
WHERE country
IN ('Afghanistan', 'Bangladesh', 'China');

SELECT * FROM actor;


SELECT first_name, last_name,
CONCAT_WS(' ', first_name, last_name) As 'Actor Name'
FROM actor;

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `description` BLOB NULL AFTER `last_update`;

ALTER TABLE actor
DROP description;

USE sakila;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS cnt
FROM actor
GROUP BY last_name
HAVING cnt >1;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE `sakila`.`actor` SET `first_name` = 'Harpo' WHERE (`actor_id` = '172');
#Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE `sakila`.`actor` SET `first_name` = 'Groucho' WHERE (`actor_id` = '172');

# You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address
mysql> SHOW CREATE TABLE t\G
*************************** 1. row ***************************
       Table: t
Create Table: CREATE TABLE `t` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `s` char(60) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1


SELECT * FROM 
staff;

SELECT * FROM 
address;

#Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT * FROM staff LEFT JOIN (address)
                                           ON (staff.address_id = address.address_id);



#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT * FROM staff LEFT JOIN (payment)
                                           ON (staff.staff_id = payment.payment_id);



#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
USE sakila;
SELECT COUNT(a.actor_id),a.title FROM(
SELECT  title, actor_id  FROM film_actor fa INNER JOIN (film f)
                                           ON (f.film_id = fa.film_id)) a
                                           GROUP BY a.title
                                           ;
 
 
 #6d. How many copies of the film Hunchback Impossible exist in the inventory system?
 SELECT COUNT(title), title FROM film f LEFT JOIN (inventory i)
                                           ON (f.film_id = i.film_id) 
                                           WHERE title = 'Hunchback Impossible'
                                           GROUP BY title
										; 
                                        
                                        

  #6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name                                         
SELECT SUM(amount) AS 'Total Paid', last_name FROM payment p
JOIN (customer c)
ON (p.customer_id = c.customer_id)
GROUP BY last_name;
								
										
#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.									
SELECT title FROM film
WHERE title LIKE "Q%" 
OR title LIKE "K%";              

#we have to join two tables one has the film the other has the actors
SELECT * FROM film;
#WHERE title = "Alone Trip";
       
 #7b. Use subqueries to display all actors who appear in the film Alone Trip. 
  SELECT first_name FROM actor a LEFT JOIN(film f)
											ON(a.actor_id = f.film_id)
                                            WHERE 
                                             title = "Alone Trip"
                                             ;
  
  
  
  
  SELECT COUNT(actor), title FROM film f LEFT JOIN (inventory i)
                                           ON (f.film_id = i.film_id) 
                                           WHERE title = 'Hunchback Impossible'
                                           GROUP BY title;
                                           
#7c get names and email addresses of anyone in canada
#combine country and customer. You have to do a bunch of joins to find something in common. Like connect the dots
SELECT c.first_name AS 'Customer First Name', c.last_name AS 'Customer Last Name', c.email AS 'Customer Email', y.country AS 'Customer Home Country'
FROM customer c
			INNER JOIN address a
					ON c.address_id = a.address_id
			INNER JOIN city i 
                    ON a.city_id = i.city_id
			INNER JOIN country y
					ON i.country_id = y.country_id
WHERE y.country = 'Canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT f.film_id AS 'Film ID', f.title AS 'Film Title', a.name AS 'Film Category', a.category_id AS 'Film Category ID'
FROM film f 
			INNER JOIN film_category c
					ON f.film_id = c.film_id
			INNER JOIN category a
					ON a.category_id = c.category_id
	WHERE a.name = 'Family';
    
    # 7eDisplay the most frequently rented movies in descending order
    
SELECT COUNT(jt.title), jt.title FROM (SELECT f.film_id , f.title 
    FROM film f
    INNER JOIN inventory i
					ON f.film_id = i.film_id
			INNER JOIN rental r
					ON r.inventory_id = i.inventory_id) jt
                    GROUP BY jt.title
                    ORDER BY COUNT(jt.title) DESC
                    ;
                    ###############################
                    
	#7f write a query to display how much business in dollars each store brought in
    
    SELECT SUM(p.amount), s.store_id 
    FROM payment p 
    INNER JOIN customer c 
				ON p.customer_id = c.customer_id
		INNER JOIN store s 
				ON c.store_id = s.store_id 
                GROUP BY s.store_id;
                
	#7g Write a query to display fore each store ID, city, and country
    SELECT *   
    FROM store s
    INNER JOIN address a
					ON s.address_id = a.address_id
			INNER JOIN city c
					ON a.city_id = c.city_id
			INNER JOIN country co
					ON c.country_id = co.country_id;
                    
#7h List the top five genres in gross revenue in descending order
    SELECT  SUM(w.amount), w.name FROM (SELECT p.amount, ca.name FROM category ca
    INNER JOIN film_category fc
					ON ca.category_id = fc.category_id
	INNER JOIN inventory i 
					ON fc.film_id = i.film_id
	INNER JOIN rental r
					ON i.inventory_id = r.inventory_id
	INNER JOIN payment p 
					ON r.customer_id = p.customer_id) w
                    GROUP BY w.name
                    ORDER BY SUM(w.amount) DESC
                    LIMIT 5;
                    
#8a I want to create a view for the top five genres
CREATE VIEW top_five_genres AS (
	SELECT  SUM(w.amount), w.name FROM (SELECT p.amount, ca.name FROM category ca
    INNER JOIN film_category fc
					ON ca.category_id = fc.category_id
	INNER JOIN inventory i 
					ON fc.film_id = i.film_id
	INNER JOIN rental r
					ON i.inventory_id = r.inventory_id
	INNER JOIN payment p 
					ON r.customer_id = p.customer_id) w
                    GROUP BY w.name
                    ORDER BY SUM(w.amount) DESC
                    LIMIT 5);
  
  #8b. Where do you see the view
  
  #to see the view refesh your schemas go to views 
  create view top_five_genres as select name, sum(amount) as "Gross Revenue" from film join film_category on film.film_id=film_category.film_id join category on film_category.category_id=category.category_id join inventory on film.film_id=inventory.film_id join rental on inventory.inventory_id=rental.inventory_id join payment on rental.rental_id=payment.rental_id group by name order by sum(amount) desc limit 5;
 #8c drop the view 
drop view top_five_genres;


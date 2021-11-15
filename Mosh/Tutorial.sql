USE sql_store;

-- CLAUSE SELECT

SELECT * 
FROM customers
-- WHERE customer_id = 1
ORDER BY first_name;

SELECT DISTINCT state
FROM customers;

-- EXERCISE 1
SELECT  name,
				unit_price,
                unit_price * 1.1 AS new_price
FROM products;


-- CLAUSE WHERE

SELECT * 
FROM customers
WHERE birth_date > '1990-01-01';

-- EXERCISE 2
SELECT *
FROM orders
WHERE order_date BETWEEN '2019-01-01' AND '2019-12-31';

SELECT *
FROM orders
WHERE order_date >= '2019-01-01';


-- OPERATOR AND, OR, NOT (ORDER: AND > OR > NOT)

SELECT * 
FROM customers
WHERE birth_date > '1990-01-01' OR
			  (points > 1000 AND state = 'VA');

SELECT * 
FROM customers
WHERE NOT (birth_date > '1990-01-01' OR points > 1000);

-- EXERCISE 3
SELECT *
FROM order_items
WHERE order_id = 6 AND (quantity * unit_price > 30);

-- OPERATOR IN
SELECT *
From customers
WHERE state NOT IN ('VA', 'FL', 'GA');

-- EXERCISE 4
SELECT *
FROM products
WHERE quantity_in_stock IN (49, 38, 72);

-- OPERATOR BETWEEN
SELECT *
FROM customers
WHERE points >= 1000 AND points <= 3000;

SELECT *
FROM customers
WHERE points BETWEEN 1000 AND 3000;

-- EXERCISE 5
SELECT *
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';

-- OPERATOR LIKE

SELECT *
FROM customers
WHERE last_name LIKE '%b%';

SELECT *
FROM customers
WHERE last_name LIKE 'b____y';  -- b+4+y

-- % any number of characters
-- _ single character

-- EXERCISE 6

SELECT *
FROM customers
WHERE address LIKE '%trail%' OR
			  address LIKE '%avenue%';

SELECT *
FROM customers
WHERE phone LIKE '%9';

-- OPERATOR REGEXP

SELECT *
FROM customers
-- WHERE last_name LIKE '%field%';
WHERE last_name REGEXP 'field$'; -- ^ the beginning of the string; $ the end of the string

SELECT *
FROM customers
WHERE last_name REGEXP 'field$|mac|rose'; 

SELECT *
FROM customers
WHERE last_name REGEXP '[gim]e'; -- ge/ie/me

SELECT *
FROM customers
WHERE last_name REGEXP 'e[f-q]'; 

-- ^ beginning
-- $ end
-- | logical or
-- [abcd] match any characters listed in the square brackets
-- [a-f] match any characters from a to f in the square brackets


-- EXERCISE 7

SELECT *
FROM customers
WHERE first_name IN ('ELKA', 'AMBUR');

SELECT *
FROM customers
WHERE first_name REGEXP '^elka$|^ambur$';

SELECT *
FROM customers
WHERE last_name REGEXP 'ey$|on$';

SELECT *
FROM customers
WHERE last_name REGEXP '^my|se';

SELECT * 
FROM customers
WHERE last_name REGEXP 'b[ru]';


-- OPERATOR IS NULL
SELECT * 
FROM customers 
WHERE phone IS NOT NULL;

-- EXERCISE 8

SELECT * 
FROM orders
WHERE shipped_date IS NULL;


-- CLAUSE ODER BY
SELECT *
FROM customers
ORDER BY first_name DESC;

SELECT *
FROM customers
ORDER BY state DESC, first_name;

SELECT first_name, last_name, 10 AS points
FROM customers
ORDER BY 1,2; -- Order by first_name, then last_name; should be avoided!

-- EXERCISE 9
SELECT * FROM sql_store.order_items;

SELECT *, quantity*unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY total_price DESC;


-- CLAUSE LIMIT
SELECT * 
FROM customers
LIMIT 6, 3; -- Skip 6 records and select the following 3 records;

-- EXERCISE 10
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;


-- INNER JOINS i.e. JOIN
SELECT order_id, orders.customer_id, first_name, last_name
FROM orders 
INNER JOIN customers 
		ON orders.customer_id = customers.customer_id;

SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
INNER JOIN customers c
		ON o.customer_id = c.customer_id;

-- EXERCISE 11
SELECT order_id, oi.product_id, p.name, quantity, oi.unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;


-- JOINING ACROSS DATABASES
SELECT *
FROM order_items oi
JOIN sql_inventory.products p
		ON oi.product_id = p.product_id; -- Prefix the table which is not in the current database;
        
-- SELF JOINS
USE sql_hr;

SELECT 
		e.employee_id,
        e.first_name,
        m.first_name AS manager
FROM employees e
JOIN employees m
		on e.reports_to = m.employee_id;
        
-- JOINING MULTIPLE TABLES
USE sql_store;

SELECT
		o.order_id,
		o.order_date,
		c.first_name,
		c.last_name,
		os.name AS 'status'
FROM orders o
JOIN customers c
		ON o.customer_id = c.customer_id
JOIN order_statuses os
		ON o.status = os.order_status_id
ORDER BY status, o.order_id;

-- EXERCISE 12
USE sql_invoicing;

SELECT 
		p.date,
        p.invoice_id,
        p.amount,
        c.name,
        pm.name
FROM payments p
JOIN clients c
		ON p.client_id = c.client_id
JOIN payment_methods pm
		ON p.payment_method = pm.payment_method_id;
        
-- COMPOUND JOIN CONDITIONS
USE sql_store;
SELECT *
FROM order_items oi
JOIN order_item_notes oin
		ON oi.order_id = oin.order_id
        AND oi.product_id = oin.product_id;
        
        
-- IMPLICIT JOIN SYNTAX
SELECT *
FROM orders o
JOIN customers c
		ON o.customer_id = c.customer_id;

SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id; -- Remember to add a WHERE condition!


-- OUTER JOINS: LEFT JOIN / RIGHT JOIN
SELECT 
		c.customer_id,
        c.first_name,
        o.order_id
FROM customers c
LEFT JOIN orders o
		ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- EXERCISE 13
SELECT 
		p.product_id,
        p.name,
        oi.quantity
FROM products p
LEFT JOIN order_items oi
		ON p.product_id = oi.product_id;
        
/*
SELECT 
		p.product_id,
        SUM(oi.quantity)
FROM products p
LEFT JOIN order_items oi
		ON p.product_id = oi.product_id
GROUP BY p.product_id;
*/


-- OUTER JOINS BETWEEN MULTIPLE TABLES
SELECT 
		c.customer_id,
        c.first_name,
        o.order_id,
        sh.name AS shipper
FROM customers c
LEFT JOIN orders o
		ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
		ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id;

-- EXERCISE 14

SELECT 
		o.order_date,
        o.order_id,
        c.first_name,
        sh.name AS shipper,
        os.name AS status
FROM orders o
JOIN customers c
		ON o.customer_id = c.customer_id -- Every order has a customer;
LEFT JOIN shippers sh
		ON o.shipper_id = sh.shipper_id
JOIN order_statuses os
		ON o.status = os.order_status_id -- Every order has order status;
ORDER BY status;


-- SELF OUTER JOINS
USE sql_hr;

SELECT 
		e.employee_id,
        e.first_name,
        m.first_name AS manager
FROM employees e
LEFT JOIN employees m
		ON e.reports_to = m.employee_id;


-- CLAUSE USING
USE sql_store;

SELECT 
		o.order_id,
        c.first_name,
        sh.name AS shipper
FROM orders o
JOIN customers c
		-- ON o.customer_id = c.customer_id;
		USING (customer_id)
LEFT JOIN shippers sh
		USING (shipper_id);
        
        
SELECT *
FROM order_items oi
LEFT JOIN order_item_notes oin
		/*ON oi.order_id = oin.order_id AND
				oi.product_id = oin.product_id;*/
		USING (order_id, product_id);

-- EXERCISE 15
USE sql_invoicing;

SELECT 
		p.date,
        c.name AS client,
        p.amount,
        pm.name AS payment_method
FROM payments p
JOIN clients c USING (client_id)
JOIN payment_methods pm
		ON p.payment_method = pm.payment_method_id;
        

-- NATURAL JOINS (NOT RECOMMENDED)
USE sql_store;

SELECT 
		o.order_id,
        c.first_name
FROM orders o
NATURAL JOIN customers c;


-- CROSS JOINS
SELECT 
		c.first_name AS customer,
        p.name AS product
FROM customers c
CROSS JOIN products p
ORDER BY c.first_name;

SELECT 
		c.first_name AS customer,
        p.name AS product
FROM customers c, orders o
ORDER BY c.first_name;

-- EXERCISE 16
SELECT *
FROM shippers, products;

SELECT *
FROM shippers
CROSS JOIN products;


-- UNIONS
SELECT 
		order_id,
        order_date,
        'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT 
		order_id,
        order_date,
        'Archived' AS status
FROM orders
WHERE order_date < '2019-01-01';

SELECT first_name AS full_name -- Determine the name of returned columns
FROM customers
UNION 
SELECT name
FROM shippers;


-- EXERCISE 17
USE sql_store;

SELECT 
		customer_id,
		first_name,
        points,
        'Bronze' AS type
FROM customers
WHERE points < 2000
UNION
SELECT 
		customer_id,
		first_name,
        points,
        'Silver' AS type
FROM customers
WHERE points >= 2000 AND points < 3000
UNION
SELECT 
		customer_id,
		first_name,
        points,
        'Gold' AS type
FROM customers
WHERE points >= 3000
ORDER BY first_name;


-- COLUMN ATTRIBUTES
-- OMITTED

-- INSERTING A SINGLE ROW
INSERT INTO customers
VALUES (
		DEFAULT,
		'John', 
        'Smith', 
        '1990-01-01',
        NULL,
        'address',
        'city',
        'CA',
        DEFAULT);
        
INSERT INTO customers (
		first_name,
        last_name,
        birth_date,
        address,
        city,
        state
) -- The order does not matter;
VALUES (
		'John', 
        'Smith', 
        '1990-01-01',
        'address',
        'city',
        'CA');
        

-- INSERTING MULTIPLE ROWS
INSERT INTO shippers (name)
VALUES ('Shipper 1'),
			 ('Shipper 2'),
             ('Shipper 3');
             

-- EXERCISE 18
INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES ('Product 1', 20, 2.88),
			 ('Product 2', 30, 1.88),
             ('Product 3', 40, 0.88);
             

-- INSERTING HIERARCHICAL ROWS
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

INSERT INTO order_items
VALUES 
		(LAST_INSERT_ID(), 1, 1, 2.95),
        (LAST_INSERT_ID(), 2, 1, 3.95);
        
        
-- CREATING A COPY OF A TABLE
CREATE TABLE orders_archived AS
SELECT * FROM orders; -- Ignored PK and AI attributes;

INSERT INTO orders_archived 
SELECT * 
FROM orders
WHERE order_date < '2019-01-01';

-- EXERCISE 19












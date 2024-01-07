/*Exercise 1:
Goal: Here we use users table to pull a list of user email addresses. Edit the query to pull email
addresses, but only for non-deleted users.
Starter Code:
SELECT *
FROM dsv1069.users

*/
SELECT email_address
FROM dsv1069.users
WHERE deleted_at IS NULL;

/*Exercise 2:
--Goal: Use the items table to count the number of items for sale in each category
*/
SELECT item_category, COUNT(*) AS NumberOfItems
FROM dsv1069.orders
GROUP BY item_category;

/*Exercise 3:
--Goal: Select all of the columns from the result when you JOIN the users table to the orders
table
Starter Code: (none)*/
SELECT *

FROM dsv1069.users u

JOIN dsv1069.orders o 
  ON u.id = o.user_id
  
ORDER BY u.id ASC;

/*Exercise 4:
--Goal: Check out the query below. This is not the right way to count the number of viewed_item
events. Determine what is wrong and correct the error.
*/
SELECT
COUNT(event_id) AS events
FROM dsv1069.events
WHERE event_name = ‘view_item’;


SELECT COUNT(DISTINCT event_id) AS events
FROM dsv1069.events
WHERE event_name = 'view_item';
/*Events 262786 */

/*Exercise 5:
--Goal:Compute the number of items in the items table which have been ordered. The query
below runs, but it isn’t right. Determine what is wrong and correct the error or start from scratch.
*/
SELECT COUNT(DISTINCT o.item_id) AS item_count
FROM dsv1069.orders o;

/*Exercise 6:
--Goal: For each user figure out IF a user has ordered something, and when their first purchase
was. The query below doesn’t return info for any of the users who haven’t ordered anything.
*/
SELECT users.id as user_id,
  MIN(orders.paid_at) AS min_paid_at
  
FROM dsv1069.users

LEFT JOIN dsv1069.orders
  ON users.id = orders.user_id
  
GROUP BY users.id

ORDER BY min_paid_at DESC;


/*Exercise 7:
--Goal: Figure out what percent of users have ever viewed the user profile page, but this query
isn’t right. Check to make sure the number of users adds up, and if not, fix the query.
*/

SELECT 100 * (SELECT COUNT(DISTINCT user_id) 
FROM dsv1069.events
WHERE event_name = 'view_user_profile') / (SELECT COUNT(*) FROM dsv1069.users) AS percentage;

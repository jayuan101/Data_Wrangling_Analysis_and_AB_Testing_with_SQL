-- Exercise 1: Create the right subtable for recently viewed events using the view_item_events table.
SELECT
  dsv1069.users.id AS user_id,
  dsv1069.users.email_address AS user_email,
  dsv1069.items.id AS item_id,
  dsv1069.items.name AS item_name,
  dsv1069.items.category AS item_category
FROM
  (SELECT 
    view_item_events.user_id AS user_id,
    view_item_events.item_id AS item_id,
    event_time,
    RANK () OVER (PARTITION BY user_id ORDER BY event_time DESC) AS view_rank 
  FROM 
    dsv1069.view_item_events) AS recent_views
JOIN
  dsv1069.users
ON 
  recent_views.user_id = dsv1069.users.id
JOIN
  dsv1069.items
ON
  recent_views.item_id = dsv1069.items.id
WHERE 
  view_rank = 1;

-- Exercise 2: Check your joins. Join your tables together recent_views, users, items
SELECT view_item_events, users.email_address, items.name, items.category
FROM dsv1069.view_item_events
JOIN dsv1069.users ON dsv1069.view_item_events.user_id = dsv1069.users.id
JOIN dsv1069.items ON dsv1069.view_item_events.item_id = dsv1069.items.id;

-- Exercise 3: Clean up your columns. The goal of all this is to return all of the information we’ll
-- need to send users an email about the item they viewed more recently. Clean up this query
-- outline from the outline in EX2 and pull only the columns you need. Make sure they are named appropriately so that another human can read and understand their contents.
SELECT users.email_address AS "User Email", items.name AS "Item Name", items.category AS "Item Category"
FROM dsv1069.view_item_events
JOIN dsv1069.users ON dsv1069.view_item_events.user_id = dsv1069.users.id
JOIN dsv1069.items ON dsv1069.view_item_events.item_id = dsv1069.items.id;

-- Exercise 4: Consider any edge cases. If we sent an email to everyone in the results of this
-- query, what would we want to filter out. Add in any extra filtering that you think would make this
-- email better. For example should we include deleted users? Should we send this email to users who already ordered the item they viewed most recently?

SELECT COALESCE(users.parent_user_id, users.id) AS user_id,
       users.email_address,
       items.id AS item_id,
       items.name AS item_name,
       items.category AS item_category
FROM
    ( SELECT user_id,
             item_id,
             event_time,
             ROW_NUMBER() OVER (PARTITION BY user_id
                                ORDER BY event_time DESC) AS view_number
   FROM dsv1069.view_item_events
   WHERE event_time > '2017-01-01' ) recent_views
JOIN dsv1069.users
  ON user_id = recent_views.user_id
JOIN dsv1069.items
  ON items.id = recent_views.item_id
LEFT OUTER JOIN dsv1069.orders
  ON orders.item_id = recent_views.item_id
  AND orders.user_id = recent_views.user_id
WHERE view_number = 1
  AND users.deleted_at IS NOT NULL
  AND orders.item_id IS NULL

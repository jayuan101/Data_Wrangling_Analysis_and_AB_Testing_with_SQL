-- Exercise 1: 
-- We’ll be using the users table to answer the question “How many new users are added each day?“.  Start by making sure you understand the columns in the table
SELECT DATE(created_at) AS day,
  COUNT(*) AS users
FROM dsv1069.users
GROUP BY day
ORDER BY day ASC;


-- Exercise 2: 
-- WIthout worrying about deleted user or merged users,  count the number of users added each day.
SELECT DATE(created_at) AS Date, COUNT(*) AS NewUsers
FROM dsv1069.users
GROUP BY DATE(created_at);

-- Exercise 3: 
-- Consider the following query. Is this the right way to count merged or deleted users? 
-- If all of our users were deleted tomorrow what would the result look like?
SELECT COUNT(*) AS deleted_users
FROM users
WHERE deleted_at IS NOT NULL;

-- Exercise 4: 
-- Count the number of users deleted each day. Then count the number of users removed due to merging in a similar way.
SELECT DATE(merged_at) AS Date, COUNT(*) AS MergedUsers
FROM dsv1069.users
WHERE merged_at IS NOT NULL
GROUP BY DATE(merged_at);

-- Exercise 5: 
-- Use the pieces you’ve built as subtables and create a table that has a column for
-- the date, the number of users created, the number of users deleted and the number of users merged that day.

CREATE TABLE daily_user_activity AS
SELECT created.day,
       created.new_users,
       COALESCE(deleted.deleted_users, 0) AS deleted_users,
       COALESCE(merged.merged_users, 0) AS merged_users
FROM
  (SELECT DATE(created_at) AS day, COUNT(*) AS new_users
   FROM dsv1069.users
   GROUP BY DATE(created_at)) AS created
LEFT JOIN
  (SELECT DATE(deleted_at) AS day, COUNT(*) AS deleted_users
   FROM dsv1069.users
   WHERE deleted_at IS NOT NULL
   GROUP BY DATE(deleted_at)) AS deleted
ON created.day = deleted.day
LEFT JOIN
  (SELECT DATE(merged_at) AS day, COUNT(*) AS merged_users
   FROM dsv1069.users
   WHERE merged_at IS NOT NULL
   GROUP BY DATE(merged_at)) AS merged
ON created.day = merged.day;
-- Exercise 6: Refine your query from #5 to have informative column names and so that null columns return 0.
CREATE TABLE daily_user_activity AS
SELECT created.day,
       created.new_users,
       COALESCE(deleted.deleted_users, 0) AS deleted_users,
       COALESCE(merged.merged_users, 0) AS merged_users
FROM
  (SELECT DATE(created_at) AS day, COUNT(*) AS new_users
   FROM users
   GROUP BY DATE(created_at)) AS created
LEFT JOIN
  (SELECT DATE(deleted_at) AS day, COUNT(*) AS deleted_users
   FROM users
   WHERE deleted_at IS NOT NULL
   GROUP BY DATE(deleted_at)) AS deleted
ON created.day = deleted.day
LEFT JOIN
  (SELECT DATE(merged_at) AS day, COUNT(*) AS merged_users
   FROM users
   WHERE merged_at IS NOT NULL
   GROUP BY DATE(merged_at)) AS merged
ON created.day = merged.day;


-- Exercise 7:
-- What if there were days where no users were created, but some users were deleted or merged.
-- Does the previous query still work? No, it doesn’t. Use the dates_rollup as a backbone for this query, so that we won’t miss any dates.
/* Yes . If there were days where no users were created, but some users were deleted or merged, the previous query would not include those dates because it’s based on the created_at column of the users table.
To ensure that all dates are included, even if no users were created on those dates, you can use the dates_rollup table as a backbone for your query*/
-- Exercise 1:
-- Figure out how many tests we have running right now

SELECT COUNT (*) 
FROM dsv1069.events
WHERE event_name = 'test_assignment'

-- Exercise 2:
-- Check for potential problems with test assignments. For example Make sure there is no data obviously missing (This is an open ended question)
SELECT *
FROM dsv1069.item_test_assignments
WHERE item_id IS NULL OR test_assignment IS NULL;

-- Exercise 3:
-- Write a query that returns a table of assignment events.
-- Please include all of the relevant parameters as columns
-- (Hint: A previous exercise as a template) 
-- Select * From dsv1069.events Where event_name = 'test_assignment'
SELECT event_name, platform, parameter_name, parameter_value
FROM dsv1069.events
WHERE event_name = 'test_assignment';

-- Exercise 4:
-- Check for potential assignment problems with test_id 5.
-- Specifically, make sure users are assigned only one treatment group.
SELECT test_id,
       user_id,
       COUNT(DISTINCT test_assignment) AS assignments
FROM
  (SELECT event_id,
          event_time,
          user_id,
          platform,
          MAX(CASE
                  WHEN parameter_name = 'test_id' THEN CAST(parameter_value AS INT)
                  ELSE NULL
              END) AS test_id,
          MAX(CASE
                  WHEN parameter_name = 'test_assignment' THEN parameter_value
                  ELSE NULL
              END) AS test_assignment
   FROM dsv1069.events
   WHERE event_name = 'test_assignment'
   GROUP BY event_id,
            event_time,
            user_id,
            platform
   ORDER BY event_id) test_events
GROUP BY test_id,
         user_id
ORDER BY assignments DESC;
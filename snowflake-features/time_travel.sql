-- Step 1: Check current row count
SELECT COUNT(*) FROM orders;
-- Should be 10

-- Step 2: Note current time
SELECT CURRENT_TIMESTAMP;
-- current time stamp 2026-04-23 06:49:04.964 -0700 

-- Step 3: Delete rows
DELETE FROM orders WHERE orderid IN (9, 10);

-- Step 4: Verify deletion
SELECT COUNT(*) FROM orders;
-- Should be 8
-- yes it is 8 verified

-- Step 5: Recover using Time Travel
SELECT * FROM orders AT (OFFSET => -60*3);
-- Goes back 3 minutes

-- Step 6: Restore
INSERT INTO orders
SELECT * FROM orders AT (OFFSET => -60*3)
WHERE orderid IN (9, 10);

-- Step 7: Verify restoration
SELECT COUNT(*) FROM orders;
-- Should be 10 again
-- yes it is 10again

-- Step 8: Check retention period
SHOW PARAMETERS LIKE 'DATA_RETENTION_TIME_IN_DAYS' 
IN TABLE orders;
-- RESULT
    -- key                      | value| default |	level                                                          |	description	type|
-- DATA_RETENTION_TIME_IN_DAYS	| 1	  |   1		  | number of days to retain the old version of deleted/updated data |	NUMBER          |


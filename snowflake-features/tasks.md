-- Step 1: Create a simple task
CREATE OR REPLACE TASK my_first_task
    WAREHOUSE = compute_wh
    SCHEDULE = 'USING CRON 0 9 * * 1 UTC'
AS
SELECT CURRENT_TIMESTAMP;

-- Step 2: Resume it
ALTER TASK my_first_task RESUME;

-- Step 3: Check status
SHOW TASKS;

-- Step 4: Check history
SELECT * FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
ORDER BY SCHEDULED_TIME DESC
LIMIT 5;

-- Step 5: Suspend it
ALTER TASK my_first_task SUSPEND;

-- Step 6: Try a task with 1 minute schedule
CREATE OR REPLACE TASK my_minute_task
    WAREHOUSE = compute_wh
    SCHEDULE = '1 minute'
AS
INSERT INTO orders_audit
SELECT COUNT(*), CURRENT_TIMESTAMP 
FROM orders;

ALTER TASK my_minute_task RESUME;

-- Waited 2 minutes then checked
SELECT * FROM TABLE(salesdb.INFORMATION_SCHEMA.TASK_HISTORY())
ORDER BY SCHEDULED_TIME DESC;

ALTER TASK my_minute_task SUSPEND;

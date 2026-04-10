# SQL Interview Questions & Answers

Personal notes from real recruiter screening calls and interview prep.
Last updated: April 2026

---

## Question 1 — Difference between RANK and DENSE_RANK

**Answer:**
Both RANK and DENSE_RANK assign the same rank number to tied rows.
The difference is what happens to the next rank after a tie.

- **RANK** — skips the next rank number after a tie
- **DENSE_RANK** — does not skip, stays consecutive

**Example:**

| Employee | Salary | RANK | DENSE_RANK |
|----------|--------|------|------------|
| Michael  | 90000  | 1    | 1          |
| Mary     | 75000  | 2    | 2          |
| Kevin    | 65000  | 3    | 3          |
| Frank    | 55000  | 4    | 4          |
| Carol    | 55000  | 4    | 4          |
| —        | —      | 6    | 5          |

After the tie at rank 4, RANK jumps to 6 (skips 5).
DENSE_RANK goes to 5 (no skip).

**When to use which:**
- Use RANK when gaps in ranking are acceptable and meaningful
- Use DENSE_RANK when you want no gaps in the sequence
- Use ROW_NUMBER when you need a unique number for every row regardless of ties

---

## Question 2 — Difference between CTE and Subquery

**Answer:**

| | CTE | Subquery |
|---|---|---|
| Readability | High — named and defined at the top | Lower — embedded inline |
| Reusability | Can be referenced multiple times in same query | Cannot be reused |
| Debugging | Easy — can test each CTE independently | Harder — nested logic |
| Performance | Similar in most cases | Similar in most cases |

**CTE syntax:**
```sql
WITH high_earners AS (
    SELECT * FROM employees WHERE salary > 60000
)
SELECT * FROM high_earners;
```

**Subquery syntax:**
```sql
SELECT * FROM (
    SELECT * FROM employees WHERE salary > 60000
) AS high_earners;
```

**Rule of thumb:**
- Use CTE when the same logic is referenced more than once
- Use CTE when the query is complex and readability matters
- Use subquery for simple one-off inline filtering

---

## Question 3 — CTE Scope — Can you reference a CTE after the query ends?

**Answer:** No.

A CTE only exists within the single query it is defined in.
Once that query finishes executing the CTE is completely gone.
You cannot reference it in a separate query below — even in the same session.

```sql
-- This works
WITH my_cte AS (SELECT * FROM employees)
SELECT * FROM my_cte;

-- This FAILS -- my_cte no longer exists
SELECT * FROM my_cte;
-- Error: object MY_CTE does not exist
```

---

## Question 4 — Difference between CTE and Temp Table

**Answer:**

| | CTE | Temp Table |
|---|---|---|
| Lifespan | Single query only | Entire session |
| Storage | No physical storage | Physically created in DB |
| Reusability | Only within one query | Across multiple queries in session |
| Indexing | Cannot be indexed | Can be indexed |
| Overhead | Zero storage cost | Uses actual storage |
| Syntax | WITH name AS (...) | CREATE TEMPORARY TABLE |

**CTE — gone after one query:**
```sql
WITH summary AS (
    SELECT customerid, SUM(sales) AS total
    FROM orders
    GROUP BY customerid
)
SELECT * FROM summary;
-- summary is gone after this
```

**Temp Table — persists across queries in same session:**
```sql
-- Create once
CREATE TEMPORARY TABLE summary AS
SELECT customerid, SUM(sales) AS total
FROM orders
GROUP BY customerid;

-- Use in first query
SELECT * FROM summary WHERE total > 50;

-- Use again in second query -- still works
SELECT customerid FROM summary ORDER BY total DESC;

-- Clean up when done
DROP TABLE IF EXISTS summary;
```

**When to use which:**
- Use CTE for readability within a single query
- Use Temp Table when you need to reuse intermediate results
  across multiple separate queries in the same session
- Use Temp Table when the intermediate result set is very large
  and you want to avoid recalculating it multiple times

---

## Question 5 — ROW_NUMBER vs RANK vs DENSE_RANK Summary

**Quick reference:**

```sql
SELECT
    firstname,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
    RANK()       OVER (ORDER BY salary DESC) AS rnk,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rnk
FROM employees;
```

| Function | Duplicates get same number? | Gaps after tie? |
|---|---|---|
| ROW_NUMBER | No — always unique | N/A |
| RANK | Yes | Yes — skips |
| DENSE_RANK | Yes | No — consecutive |

---

## Lessons Learned From This Interview

- Always attempt a comparison question even if not fully studied
  — use logic to reason through it rather than saying I don't know
- Temp tables are a commonly tested topic — must know cold
- Python weakness was exposed — needs to be addressed in Month 4
- EY is a consulting firm, not primary target — treat this as free practice

---

*Source: EY recruiter screening call — April 2026*

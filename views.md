# 📊 SQL Views

## 1. What is a View?

A View in SQL is a **virtual table** based on the result of a SQL query.  
It does not store data physically — it stores only the query definition.

### 📌 Key Concept
- View = Saved SQL Query
- Always shows **latest data** from underlying tables

---

## 2. Syntax

```sql
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
WHERE condition;

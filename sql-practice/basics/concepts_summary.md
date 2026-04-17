# This weeks summary solved 20~ problems and consumed  90 % of datawith barra  sql tutorial video on sql and practicced those problems on snowflake from next week snowflake theory will be started 

# SQL Concepts — When to Use What

## Views
- Virtual table based on a SELECT query
- No data stored physically
- Use when: logic is reused across teams or multiple queries
- Snowflake specific: secure views for data masking

## CTE
- Temporary named result set within one query
- Gone after query executes
- Use when: same subquery needed multiple times in one query

## CTAS (Create Table As Select)
- Physically creates a new table from a query result
- Data is stored permanently
- Use when: you need a permanent copy of transformed data

## Temp Table
- Physically created, persists for session duration
- Gone when session ends
- Use when: intermediate results needed across multiple queries

## When to Use What — Decision Rule
One query, readability matters    → CTE
Reuse across multiple queries     → Temp Table
Permanent transformed data        → CTAS
Shared logic across teams         → View

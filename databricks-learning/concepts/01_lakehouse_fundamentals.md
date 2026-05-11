# Databricks Lakehouse Fundamentals

## Date: May 11 2026

## Key concepts learned today

### What is a Lakehouse
- Combination of data lake (cheap file storage like S3) 
  and data warehouse (structured, queryable like Snowflake)
- Databricks created this concept
- Store data cheaply, query it efficiently

### Apache Spark
- Distributed computing engine
- Processes data across multiple machines simultaneously
- Like Pandas but for massive datasets that don't fit one computer

### Delta Lake
- Storage format that adds database features to files
- Has Time Travel — similar to Snowflake Time Travel
- Has ACID transactions — no corrupt or partial data
- Sits on top of cloud storage like S3

### How this connects to what I already know
- Delta Lake Time Travel = Snowflake Time Travel
- Databricks Workflows = Airflow (scheduling)
- Unity Catalog = Snowflake roles and governance

## Questions I still have
- should reiterate the unified governance in databricks 

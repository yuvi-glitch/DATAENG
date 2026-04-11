# ❄️ Snowflake Core Features

## 1. Time Travel

### 📌 Definition
Time Travel in Snowflake allows you to access historical data (data from the past) for a specific period.

### ⏱ Retention Period
- Standard: 1 day (default)
- Enterprise: Up to 90 days

### 🔧 Use Cases
- Recover deleted data
- Undo accidental updates
- Audit historical changes

### 💡 Example
```sql
SELECT * FROM my_table AT (OFFSET => -60*60); -- 1 hour ago

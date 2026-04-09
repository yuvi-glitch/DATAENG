# Recursive CTE Practice

## 📌 Topics Covered

* Parent-Child Relationships
* Employee Hierarchy using Recursive CTE
* Building Hierarchy Levels
* Generating Full Management Chain (Path)
* Generating Number Sequences using Recursive CTE

---

## 🧠 Key Concepts

### 1. Parent-Child Relationship

* `employeeid` → unique identifier
* `managerid` → references another employee
* Used to build hierarchical structures

---

### 2. Recursive CTE Structure

* **Anchor Query** → starting point (top-level manager / base case)
* **Recursive Query** → joins back to CTE to expand results

---

### 3. Hierarchy Levels

* Track depth using:

```sql
level + 1
```

---

### 4. Path / Chain Building

* Build full hierarchy using string concatenation

```sql
parent_path || ' > ' || child_name
```

---

### 5. Sequence Generation

* Generate numbers without tables
* Use recursion with increment logic

---

## 🚀 Problems Practiced

### ✅ Employee Hierarchy with Levels

* Built hierarchy from top-level manager
* Used recursion to assign levels

---

### ✅ Full Management Chain

* Generated full path like:

```
Frank Lee > Mary > Carol Baker
```

---

### ✅ Number Sequence (1–10)

* Generated numbers using only recursive CTE

---

## 💡 Key Learnings

* Always join:

```sql
child.managerid = parent.employeeid
```

* Recursive queries must:

  * Progress (`+1`, append string)
  * Have a stopping condition

---

## 🔥 Summary

Recursive CTEs are powerful for:

* Hierarchical data
* Tree structures
* Sequence generation

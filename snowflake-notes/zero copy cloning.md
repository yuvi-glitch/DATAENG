Zero-Copy Cloning
📌 Definition

Zero-copy cloning creates a copy of a table, schema, or database without duplicating the data.

⚡ Key Concept
Uses metadata pointers
No extra storage initially
Changes are tracked separately
🔧 Use Cases
Testing environments
Backup before changes
Data experimentation

#EXAMPLE
CREATE TABLE clone_table CLONE original_table;

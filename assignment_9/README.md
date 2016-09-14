# Assignment 9

This is SQL assignment. There are 2 tables:
*assignment (id, product_id, participant_id, ts, action)
*product (id, current_owner_id)

assignment stores a “Chain of Custody” of products, ts is timestamp of an action, action is “c” (create) or “m” (move), so a first record of a product’s history always has action=“c” and each product_id has only one record with action = “c”. It’s possible that a second record with action=“m” has identical timestamp with a first record of a product.

product table (in our case) stores the current product’s owner, so it’s a participant_id from the last record of a product from assignment.

Tasks:
a) Create a stored procedure which returns “Chain of Custody” in a correct order, “c” is a first record, next “m” records are sorted by ts.
b) There are broken product records where current_owner_id is not correct. Please create a SQL db patch that fixes the issue.
UPDATE
    test.product
SET
    current_owner_id = (
        SELECT
            participant_id
        FROM
            test.assignment
        WHERE
            test.assignment.product_id = test.product.id
        ORDER BY
            ts DESC
        LIMIT 1
    );



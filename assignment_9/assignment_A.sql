DELIMITER //
CREATE PROCEDURE chain_of_custody (IN _pid INT)
BEGIN
    SELECT
        participant_id,
        action,
        ts
    FROM
        test.assignment
    WHERE
        product_id = _pid
    ORDER BY
        FIELD(action, 'c', 'm'),
        ts;
END//
DELIMITER ;
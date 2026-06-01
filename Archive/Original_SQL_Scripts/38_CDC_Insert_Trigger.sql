CREATE TRIGGER trg_CDC_Insert
ON dbo.CBS_Transactions

AFTER INSERT
AS
BEGIN

    INSERT INTO Transaction_Change_Log
    (
        TransactionID,
        ChangeType
    )

    SELECT
        TransactionID,
        'INSERT'

    FROM inserted;

END;
GO

--Test Trigger--
SELECT TOP 20 *
FROM Transaction_Change_Log
ORDER BY ChangeID DESC;
GO
CREATE TRIGGER trg_CDC_Delete
ON dbo.CBS_Transactions

AFTER DELETE
AS
BEGIN

    INSERT INTO Transaction_Change_Log
    (
        TransactionID,
        ChangeType
    )

    SELECT
        TransactionID,
        'DELETE'

    FROM deleted;

END;
GO

--Test Trigger--
DELETE TOP (1)
FROM dbo.CBS_Transactions;
GO

--Verify CDC Log--
SELECT TOP 20 *
FROM Transaction_Change_Log
ORDER BY ChangeID DESC;
GO
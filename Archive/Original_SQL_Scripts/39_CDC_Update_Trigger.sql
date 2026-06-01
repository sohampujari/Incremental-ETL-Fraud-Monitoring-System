CREATE TRIGGER trg_CDC_Update
ON dbo.CBS_Transactions

AFTER UPDATE
AS
BEGIN

    INSERT INTO Transaction_Change_Log
    (
        TransactionID,
        ChangeType
    )

    SELECT
        TransactionID,
        'UPDATE'

    FROM inserted;

END;
GO

--Test Trigger--
UPDATE TOP (1) dbo.CBS_Transactions
SET TransactionStatus = 'FAILED';
GO

--Verify CDC Log--
SELECT TOP 20 *
FROM Transaction_Change_Log
ORDER BY ChangeID DESC;
GO
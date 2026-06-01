INSERT INTO Rejected_Transactions
(
    TransactionID,
    AccountNumber,
    CustomerName,
    TransactionType,
    TransactionAmount,
    TransactionStatus,
    RejectReason
)

SELECT
    TransactionID,
    AccountNumber,
    CustomerName,
    TransactionType,
    TransactionAmount,
    TransactionStatus,

    CASE
        WHEN CustomerName IS NULL THEN 'Customer Name Missing'
        WHEN TransactionAmount < 0 THEN 'Negative Transaction Amount'
        WHEN TransactionStatus NOT IN ('SUCCESS', 'FAILED') THEN 'Invalid Transaction Status'
    END AS RejectReason

FROM Staging_Transactions

WHERE
    CustomerName IS NULL
    OR TransactionAmount < 0
    OR TransactionStatus NOT IN ('SUCCESS', 'FAILED');
GO

--Verification Query-
SELECT *
FROM Rejected_Transactions
ORDER BY RejectTime DESC;
GO
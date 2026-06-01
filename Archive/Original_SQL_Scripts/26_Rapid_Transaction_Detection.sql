SELECT
    AccountNumber,
    COUNT(*) AS TransactionCount,
    MIN(TransactionTime) AS FirstTransaction,
    MAX(TransactionTime) AS LastTransaction

FROM Fact_Transactions

GROUP BY AccountNumber,
         CAST(TransactionTime AS DATE),
         DATEPART(HOUR, TransactionTime),
         DATEPART(MINUTE, TransactionTime)

HAVING COUNT(*) >= 3

ORDER BY TransactionCount DESC;
GO
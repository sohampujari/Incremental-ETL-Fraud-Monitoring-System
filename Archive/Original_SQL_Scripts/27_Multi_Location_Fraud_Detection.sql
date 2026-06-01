SELECT
    AccountNumber,

    COUNT(DISTINCT TransactionLocation) AS LocationCount,

    STRING_AGG(TransactionLocation, ', ') AS LocationsUsed

FROM Fact_Transactions

GROUP BY AccountNumber

HAVING COUNT(DISTINCT TransactionLocation) > 1

ORDER BY LocationCount DESC;
GO
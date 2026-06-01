SELECT
    CAST(TransactionTime AS DATE) AS TransactionDate,

    COUNT(*) AS FraudTransactionCount

FROM Fact_Transactions

WHERE FraudFlag = 'YES'

GROUP BY CAST(TransactionTime AS DATE)

ORDER BY TransactionDate;
GO
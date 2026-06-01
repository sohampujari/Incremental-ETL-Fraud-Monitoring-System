-- Total Transactions

SELECT COUNT(*) AS TotalTransactions
FROM Fact_Transactions;
GO



-- Total Fraud Transactions

SELECT COUNT(*) AS FraudTransactions
FROM Fact_Transactions
WHERE FraudFlag = 'YES';
GO



-- Fraud Percentage

SELECT
(
    CAST(
        SUM(CASE WHEN FraudFlag = 'YES' THEN 1 ELSE 0 END)
        AS FLOAT
    )
    /
    COUNT(*)
) * 100 AS FraudPercentage
FROM Fact_Transactions;
GO



-- Fraud Transactions by Location

SELECT
    TransactionLocation,
    COUNT(*) AS FraudCount

FROM Fact_Transactions

WHERE FraudFlag = 'YES'

GROUP BY TransactionLocation

ORDER BY FraudCount DESC;
GO



-- Fraud Transactions by Transaction Type

SELECT
    TransactionType,
    COUNT(*) AS FraudCount

FROM Fact_Transactions

WHERE FraudFlag = 'YES'

GROUP BY TransactionType

ORDER BY FraudCount DESC;
GO



-- Top High Value Transactions

SELECT TOP 20
    TransactionID,
    CustomerName,
    TransactionAmount,
    TransactionLocation,
    TransactionType

FROM Fact_Transactions

ORDER BY TransactionAmount DESC;
GO
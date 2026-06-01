SELECT
    FraudSeverity,
    COUNT(*) AS FraudCount

FROM dbo.CBS_Transactions

GROUP BY FraudSeverity

ORDER BY FraudCount DESC;
GO
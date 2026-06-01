ALTER TABLE dbo.CBS_Transactions
ADD FraudSeverity VARCHAR(20);
GO

UPDATE dbo.CBS_Transactions
SET FraudSeverity =
    CASE
        WHEN RiskScore >= 70 THEN 'HIGH'
        WHEN RiskScore >= 30 THEN 'MEDIUM'
        ELSE 'LOW'
    END;
GO

--Verification Query--
SELECT TOP 20
    TransactionID,
    RiskScore,
    FraudFlag,
    FraudSeverity
FROM dbo.CBS_Transactions
ORDER BY RiskScore DESC;
GO
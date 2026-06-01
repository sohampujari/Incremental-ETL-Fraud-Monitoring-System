INSERT INTO Fraud_Alerts (
    TransactionID,
    AccountNumber,
    CustomerName,
    TransactionAmount,
    RiskScore,
    FraudSeverity
)
SELECT
    TransactionID,
    AccountNumber,
    CustomerName,
    TransactionAmount,
    RiskScore,
    FraudSeverity
FROM dbo.CBS_Transactions
WHERE FraudSeverity = 'HIGH';
GO

--Verification Query-
SELECT *
FROM Fraud_Alerts
ORDER BY AlertTime DESC;
GO
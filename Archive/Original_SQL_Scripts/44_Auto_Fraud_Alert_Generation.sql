INSERT INTO Fraud_Alerts
(
    TransactionID,
    AccountNumber,
    RiskScore,
    FraudSeverity
)

SELECT
    TransactionID,
    AccountNumber,
    RiskScore,

    CASE
        WHEN RiskScore >= 90 THEN 'CRITICAL'
        WHEN RiskScore >= 70 THEN 'HIGH'
        WHEN RiskScore >= 50 THEN 'MEDIUM'
        ELSE 'LOW'
    END

FROM Fact_Transactions

WHERE RiskScore >= 50;
GO

--Verification Query--
SELECT TOP 20 *
FROM Fraud_Alerts
ORDER BY AlertID DESC;
GO
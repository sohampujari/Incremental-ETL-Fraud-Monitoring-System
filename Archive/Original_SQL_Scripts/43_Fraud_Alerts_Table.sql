CREATE TABLE Fraud_Alerts
(
    AlertID INT IDENTITY(1,1) PRIMARY KEY,

    TransactionID BIGINT,

    AccountNumber VARCHAR(20),

    RiskScore INT,

    FraudSeverity VARCHAR(50),

    AlertTime DATETIME DEFAULT GETDATE(),

    AlertStatus VARCHAR(50) DEFAULT 'OPEN'
);
GO

--Verification Query--
SELECT *
FROM Fraud_Alerts;
GO
CREATE TABLE Fraud_Alerts (
    AlertID INT IDENTITY(1,1) PRIMARY KEY,
    TransactionID INT,
    AccountNumber VARCHAR(50),
    CustomerName VARCHAR(100),
    TransactionAmount DECIMAL(18,2),
    RiskScore INT,
    FraudSeverity VARCHAR(20),
    AlertTime DATETIME DEFAULT GETDATE()
);
GO
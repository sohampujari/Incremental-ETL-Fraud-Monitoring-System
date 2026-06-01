CREATE TRIGGER trg_RealTime_Fraud_Alert
ON Fact_Transactions

AFTER INSERT
AS
BEGIN

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

    FROM inserted

    WHERE RiskScore >= 50;

END;
GO

--Test Trigger--
INSERT INTO Fact_Transactions
(
    TransactionID,
    AccountNumber,
    CustomerName,
    TransactionType,
    TransactionAmount,
    TransactionTime,
    MerchantCategory,
    TransactionLocation,
    DeviceID,
    IPAddress,
    TransactionStatus,
    FraudFlag,
    DW_Load_Time,
    RiskScore
)

VALUES
(
    999999,
    'ACC9999',
    'Test Fraud User',
    'UPI',
    250000,
    GETDATE(),
    'Electronics',
    'Mumbai',
    'DEV999',
    '10.10.10.10',
    'FAILED',
    'YES',
    GETDATE(),
    95
);
GO

--Verify Alert Auto-Created--
SELECT TOP 10 *
FROM Fraud_Alerts
ORDER BY AlertID DESC;
GO
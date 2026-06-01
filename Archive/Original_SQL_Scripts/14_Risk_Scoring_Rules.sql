--Real Fraud Scoring Logic--

--Adding RiskScore--
ALTER TABLE [dbo].[CBS_Transactions]
ADD RiskScore INT DEFAULT 0;
GO

--Rule-Based Fraud Detection-
UPDATE [dbo].[CBS_Transactions]
SET RiskScore =
    CASE
        WHEN TransactionAmount > 150000 THEN 50
        ELSE 0
    END
    +
    CASE
        WHEN TransactionStatus = 'FAILED' THEN 30
        ELSE 0
    END
    +
    CASE
        WHEN TransactionType = 'ATM' THEN 10
        WHEN TransactionType = 'UPI' THEN 5
        ELSE 0
    END;
GO

--verification query--
SELECT TOP 20
    TransactionID,
    TransactionAmount,
    TransactionType,
    TransactionStatus,
    RiskScore
FROM [dbo].[CBS_Transactions]
ORDER BY RiskScore DESC;
GO
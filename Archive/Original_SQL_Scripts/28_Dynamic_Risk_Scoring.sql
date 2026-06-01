UPDATE dbo.CBS_Transactions
SET RiskScore =

    -- High Amount
    CASE
        WHEN TransactionAmount > 150000 THEN 50
        ELSE 0
    END

    +

    -- Failed Transaction
    CASE
        WHEN TransactionStatus = 'FAILED' THEN 30
        ELSE 0
    END

    +

    -- Transaction Type Risk
    CASE
        WHEN TransactionType = 'ATM' THEN 10
        WHEN TransactionType = 'UPI' THEN 5
        ELSE 0
    END;
GO

--Verification Query-
SELECT TOP 20
    TransactionID,
    TransactionAmount,
    TransactionStatus,
    TransactionType,
    RiskScore,
    FraudSeverity
FROM dbo.CBS_Transactions
ORDER BY RiskScore DESC;
GO
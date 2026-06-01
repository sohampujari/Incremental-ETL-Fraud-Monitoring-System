--Add FraudFlag Column--
ALTER TABLE dbo.CBS_Transactions
ADD FraudFlag VARCHAR(10);
GO


UPDATE [dbo].[CBS_Transactions]
SET FraudFlag =
    CASE
        WHEN RiskScore >= 50 THEN 'YES'
        ELSE 'NO'
    END;
GO


--Verification Query--
SELECT TOP 20
    TransactionID,
    TransactionAmount,
    TransactionType,
    TransactionStatus,
    RiskScore,
    FraudFlag
FROM [dbo].[CBS_Transactions]
ORDER BY RiskScore DESC;
GO

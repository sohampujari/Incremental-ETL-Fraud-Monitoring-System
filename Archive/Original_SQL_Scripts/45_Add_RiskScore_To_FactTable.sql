--Step 1 — Add RiskScore To Fact Table--
ALTER TABLE Fact_Transactions
ADD RiskScore INT;
GO

--Step 2 — Populate RiskScore--
UPDATE FT
SET FT.RiskScore = CBS.RiskScore

FROM Fact_Transactions FT
INNER JOIN CBS_Source_DB.dbo.CBS_Transactions CBS
ON FT.TransactionID = CBS.TransactionID;
GO

--Step 3 — Verify--
SELECT TOP 20
    TransactionID,
    RiskScore
FROM Fact_Transactions
ORDER BY RiskScore DESC;
GO
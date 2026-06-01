CREATE TABLE Dim_TransactionType
(
    TransactionTypeKey INT IDENTITY(1,1) PRIMARY KEY,

    TransactionType VARCHAR(50)
);
GO

--Populate Dimension--
INSERT INTO Dim_TransactionType
(
    TransactionType
)

SELECT DISTINCT
    TransactionType

FROM Fact_Transactions;
GO

--Verification Query--
SELECT *
FROM Dim_TransactionType;
GO
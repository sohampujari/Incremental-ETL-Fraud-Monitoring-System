CREATE TABLE Dim_Customer
(
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,

    AccountNumber VARCHAR(20),

    CustomerName VARCHAR(100)
);
GO

--Populate Dimension--
INSERT INTO Dim_Customer
(
    AccountNumber,
    CustomerName
)

SELECT DISTINCT
    AccountNumber,
    CustomerName

FROM Fact_Transactions;
GO

--Verification Query--
SELECT *
FROM Dim_Customer;
GO
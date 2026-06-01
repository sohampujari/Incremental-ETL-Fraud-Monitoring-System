CREATE TABLE Dim_Location
(
    LocationKey INT IDENTITY(1,1) PRIMARY KEY,

    TransactionLocation VARCHAR(100)
);
GO

--Populate Dimension--
INSERT INTO Dim_Location
(
    TransactionLocation
)

SELECT DISTINCT
    TransactionLocation

FROM Fact_Transactions;
GO

--Verification Query--
SELECT *
FROM Dim_Location;
GO
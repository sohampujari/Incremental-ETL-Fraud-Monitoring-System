ALTER TABLE Dim_Customer
ADD
    EffectiveDate DATETIME DEFAULT GETDATE(),

    EndDate DATETIME NULL,

    IsCurrent BIT DEFAULT 1;
GO

--Verification Query--
SELECT *
FROM Dim_Customer;
GO
--Simulate Customer Change History--

-- Step 1 — Find Existing Customer--
SELECT TOP 1 *
FROM Dim_Customer;
GO

--Step 2 — Expire Existing Record--
UPDATE Dim_Customer
SET
    EndDate = GETDATE(),
    IsCurrent = 0

WHERE AccountNumber = 'ACC1001'
AND IsCurrent = 1;
GO

--Step 3 — Insert New Current Version-
INSERT INTO Dim_Customer
(
    AccountNumber,
    CustomerName,
    EffectiveDate,
    EndDate,
    IsCurrent
)

VALUES
(
    'ACC1001',
    'Updated Customer Name',
    GETDATE(),
    NULL,
    1
);
GO

--Step 4 — Verify SCD History--
SELECT *
FROM Dim_Customer
WHERE AccountNumber = 'ACC1001';
GO
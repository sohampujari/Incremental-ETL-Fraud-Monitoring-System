USE FraudMonitoringDW;
GO

CREATE PROCEDURE usp_Load_Fact_Transactions
AS
BEGIN

    SET NOCOUNT ON;

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
        FraudFlag
    )

    SELECT
        s.TransactionID,
        s.AccountNumber,
        s.CustomerName,
        s.TransactionType,
        s.TransactionAmount,
        s.TransactionTime,
        s.MerchantCategory,
        s.TransactionLocation,
        s.DeviceID,
        s.IPAddress,
        s.TransactionStatus,

        CASE
            WHEN s.TransactionAmount > 100000 THEN 'YES'
            WHEN s.TransactionStatus = 'FAILED' THEN 'YES'
            ELSE 'NO'
        END AS FraudFlag

    FROM Staging_Transactions s

    WHERE NOT EXISTS
    (
        SELECT 1
        FROM Fact_Transactions f
        WHERE f.TransactionID = s.TransactionID
    );

END;
GO
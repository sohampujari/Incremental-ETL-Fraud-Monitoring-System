USE FraudMonitoringDW;
GO

CREATE PROCEDURE usp_Incremental_Load_Staging
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @LastLoadedID BIGINT;

    SELECT @LastLoadedID = LastLoadedTransactionID
    FROM ETL_Control_Table
    WHERE ProcessName = 'Incremental_ETL_Process';

    INSERT INTO Staging_Transactions
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
        TransactionStatus
    )

    SELECT
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
        TransactionStatus

    FROM CBS_Source_DB.dbo.CBS_Transactions

    WHERE TransactionID > @LastLoadedID;

    DECLARE @NewMaxID BIGINT;

    SELECT @NewMaxID = MAX(TransactionID)
    FROM Staging_Transactions;

    UPDATE ETL_Control_Table
    SET
        LastLoadedTransactionID = @NewMaxID,
        LastLoadDate = GETDATE()
    WHERE ProcessName = 'Incremental_ETL_Process';

END;
GO
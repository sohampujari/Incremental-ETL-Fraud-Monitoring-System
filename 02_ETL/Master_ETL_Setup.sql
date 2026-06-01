/*
============================================================
MASTER_ETL_SETUP.SQL
Incremental ETL Fraud Monitoring System
============================================================
*/

USE FraudMonitoringDW;
GO

/*----------------------------------------------------------
1. INCREMENTAL LOAD PROCEDURE
----------------------------------------------------------*/
CREATE OR ALTER PROCEDURE dbo.usp_Incremental_Load_Staging
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LastLoadedID BIGINT;

    SELECT @LastLoadedID = LastLoadedTransactionID
    FROM dbo.ETL_Control_Table
    WHERE ProcessName='Incremental_ETL_Process';

    INSERT INTO dbo.Staging_Transactions
    (
        TransactionID,AccountNumber,CustomerName,TransactionType,
        TransactionAmount,TransactionTime,MerchantCategory,
        TransactionLocation,DeviceID,IPAddress,TransactionStatus
    )
    SELECT
        TransactionID,AccountNumber,CustomerName,TransactionType,
        TransactionAmount,TransactionTime,MerchantCategory,
        TransactionLocation,DeviceID,IPAddress,TransactionStatus
    FROM CBS_Source_DB.dbo.CBS_Transactions
    WHERE TransactionID > ISNULL(@LastLoadedID,0);

    UPDATE dbo.ETL_Control_Table
    SET LastLoadedTransactionID =
        (SELECT ISNULL(MAX(TransactionID),0) FROM CBS_Source_DB.dbo.CBS_Transactions),
        LastLoadDate = GETDATE()
    WHERE ProcessName='Incremental_ETL_Process';
END;
GO

/*----------------------------------------------------------
2. FACT LOAD PROCEDURE
----------------------------------------------------------*/
CREATE OR ALTER PROCEDURE dbo.usp_Load_Fact_Transactions
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Fact_Transactions
    (
        TransactionID,AccountNumber,CustomerName,TransactionType,
        TransactionAmount,TransactionTime,MerchantCategory,
        TransactionLocation,DeviceID,IPAddress,TransactionStatus,
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
        END
    FROM dbo.Staging_Transactions s
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.Fact_Transactions f
        WHERE f.TransactionID=s.TransactionID
    );
END;
GO

/*----------------------------------------------------------
3. SCD TYPE 2 PREPARATION
----------------------------------------------------------*/
IF COL_LENGTH('dbo.Dim_Customer','EffectiveDate') IS NULL
BEGIN
    ALTER TABLE dbo.Dim_Customer
    ADD EffectiveDate DATETIME DEFAULT GETDATE(),
        EndDate DATETIME NULL,
        IsCurrent BIT DEFAULT 1;
END;
GO

/*----------------------------------------------------------
4. WATERMARK SUPPORT
----------------------------------------------------------*/
CREATE OR ALTER VIEW dbo.vw_Incremental_Transactions
AS
SELECT *
FROM CBS_Source_DB.dbo.CBS_Transactions
WHERE TransactionTime >
(
    SELECT LastLoadTime
    FROM dbo.ETL_Watermark
    WHERE ProcessName='Incremental_ETL'
);
GO

CREATE OR ALTER PROCEDURE dbo.usp_Update_Watermark
AS
BEGIN
    UPDATE dbo.ETL_Watermark
    SET LastLoadTime =
    (
        SELECT MAX(TransactionTime)
        FROM CBS_Source_DB.dbo.CBS_Transactions
    )
    WHERE ProcessName='Incremental_ETL';
END;
GO

/*----------------------------------------------------------
5. CDC CHANGE LOG
----------------------------------------------------------*/
IF OBJECT_ID('dbo.Transaction_Change_Log','U') IS NULL
CREATE TABLE dbo.Transaction_Change_Log
(
    ChangeID INT IDENTITY(1,1) PRIMARY KEY,
    TransactionID BIGINT,
    ChangeType VARCHAR(20),
    ChangeTime DATETIME DEFAULT GETDATE()
);
GO

PRINT 'Create CDC triggers in CBS_Source_DB';
GO

/*----------------------------------------------------------
6. CDC TRIGGERS (RUN IN SOURCE DB)
----------------------------------------------------------*/
USE CBS_Source_DB;
GO

CREATE OR ALTER TRIGGER dbo.trg_CDC_Insert
ON dbo.CBS_Transactions
AFTER INSERT
AS
BEGIN
    INSERT INTO FraudMonitoringDW.dbo.Transaction_Change_Log
    (TransactionID,ChangeType)
    SELECT TransactionID,'INSERT'
    FROM inserted;
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_CDC_Update
ON dbo.CBS_Transactions
AFTER UPDATE
AS
BEGIN
    INSERT INTO FraudMonitoringDW.dbo.Transaction_Change_Log
    (TransactionID,ChangeType)
    SELECT TransactionID,'UPDATE'
    FROM inserted;
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_CDC_Delete
ON dbo.CBS_Transactions
AFTER DELETE
AS
BEGIN
    INSERT INTO FraudMonitoringDW.dbo.Transaction_Change_Log
    (TransactionID,ChangeType)
    SELECT TransactionID,'DELETE'
    FROM deleted;
END;
GO

PRINT 'Master ETL Setup Completed Successfully';
GO

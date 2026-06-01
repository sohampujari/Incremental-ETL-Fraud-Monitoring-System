/*
============================================================
MASTER_DATABASE_SETUP.SQL
Incremental ETL Fraud Monitoring System
Run on a fresh SQL Server instance.
============================================================
*/

/*----------------------------------------------------------
1. CREATE SOURCE DATABASE
----------------------------------------------------------*/
IF DB_ID('CBS_Source_DB') IS NULL
    CREATE DATABASE CBS_Source_DB;
GO

USE CBS_Source_DB;
GO

IF OBJECT_ID('dbo.CBS_Transactions','U') IS NULL
CREATE TABLE dbo.CBS_Transactions
(
    TransactionID BIGINT IDENTITY(1,1) PRIMARY KEY,
    AccountNumber VARCHAR(20),
    CustomerName VARCHAR(100),
    TransactionType VARCHAR(20),
    TransactionAmount DECIMAL(18,2),
    TransactionTime DATETIME DEFAULT GETDATE(),
    MerchantCategory VARCHAR(50),
    TransactionLocation VARCHAR(100),
    DeviceID VARCHAR(50),
    IPAddress VARCHAR(50),
    TransactionStatus VARCHAR(20)
);
GO

/*----------------------------------------------------------
2. CREATE DATA WAREHOUSE DATABASE
----------------------------------------------------------*/
IF DB_ID('FraudMonitoringDW') IS NULL
    CREATE DATABASE FraudMonitoringDW;
GO

USE FraudMonitoringDW;
GO

/*----------------------------------------------------------
3. FACT TABLES
----------------------------------------------------------*/
IF OBJECT_ID('dbo.Fact_Transactions','U') IS NULL
CREATE TABLE dbo.Fact_Transactions
(
    TransactionID BIGINT PRIMARY KEY,
    AccountNumber VARCHAR(20),
    CustomerName VARCHAR(100),
    TransactionType VARCHAR(20),
    TransactionAmount DECIMAL(18,2),
    TransactionTime DATETIME,
    MerchantCategory VARCHAR(50),
    TransactionLocation VARCHAR(100),
    DeviceID VARCHAR(50),
    IPAddress VARCHAR(50),
    TransactionStatus VARCHAR(20),
    FraudFlag VARCHAR(10),
    DW_Load_Time DATETIME DEFAULT GETDATE()
);
GO

IF OBJECT_ID('dbo.Staging_Transactions','U') IS NULL
CREATE TABLE dbo.Staging_Transactions
(
    TransactionID BIGINT,
    AccountNumber VARCHAR(20),
    CustomerName VARCHAR(100),
    TransactionType VARCHAR(20),
    TransactionAmount DECIMAL(18,2),
    TransactionTime DATETIME,
    MerchantCategory VARCHAR(50),
    TransactionLocation VARCHAR(100),
    DeviceID VARCHAR(50),
    IPAddress VARCHAR(50),
    TransactionStatus VARCHAR(20),
    ETL_Load_Time DATETIME DEFAULT GETDATE()
);
GO

/*----------------------------------------------------------
4. ETL CONTROL TABLES
----------------------------------------------------------*/
IF OBJECT_ID('dbo.ETL_Control_Table','U') IS NULL
CREATE TABLE dbo.ETL_Control_Table
(
    ProcessName VARCHAR(100),
    LastLoadedTransactionID BIGINT,
    LastLoadDate DATETIME
);
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.ETL_Control_Table
    WHERE ProcessName = 'Incremental_ETL_Process'
)
INSERT INTO dbo.ETL_Control_Table
VALUES ('Incremental_ETL_Process',0,GETDATE());
GO

IF OBJECT_ID('dbo.ETL_Execution_Log','U') IS NULL
CREATE TABLE dbo.ETL_Execution_Log
(
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    PackageName VARCHAR(200),
    ExecutionTime DATETIME DEFAULT GETDATE(),
    ExecutionStatus VARCHAR(50),
    RecordsProcessed INT,
    ErrorMessage VARCHAR(MAX)
);
GO

IF OBJECT_ID('dbo.ETL_Watermark','U') IS NULL
CREATE TABLE dbo.ETL_Watermark
(
    ProcessName VARCHAR(100) PRIMARY KEY,
    LastLoadTime DATETIME
);
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.ETL_Watermark
    WHERE ProcessName = 'Incremental_ETL'
)
INSERT INTO dbo.ETL_Watermark
VALUES ('Incremental_ETL','2000-01-01');
GO

/*----------------------------------------------------------
5. FRAUD TABLES
----------------------------------------------------------*/
IF OBJECT_ID('dbo.Fraud_Alerts','U') IS NULL
CREATE TABLE dbo.Fraud_Alerts
(
    AlertID INT IDENTITY(1,1) PRIMARY KEY,
    TransactionID INT,
    AccountNumber VARCHAR(50),
    CustomerName VARCHAR(100),
    TransactionAmount DECIMAL(18,2),
    RiskScore INT,
    FraudSeverity VARCHAR(20),
    AlertTime DATETIME DEFAULT GETDATE()
);
GO

IF OBJECT_ID('dbo.Rejected_Transactions','U') IS NULL
CREATE TABLE dbo.Rejected_Transactions
(
    RejectID INT IDENTITY(1,1) PRIMARY KEY,
    TransactionID BIGINT,
    AccountNumber VARCHAR(20),
    CustomerName VARCHAR(100),
    TransactionType VARCHAR(20),
    TransactionAmount DECIMAL(18,2),
    TransactionStatus VARCHAR(20),
    RejectReason VARCHAR(200),
    RejectTime DATETIME DEFAULT GETDATE()
);
GO

/*----------------------------------------------------------
6. DIMENSION TABLES
----------------------------------------------------------*/
IF OBJECT_ID('dbo.Dim_Customer','U') IS NULL
CREATE TABLE dbo.Dim_Customer
(
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    AccountNumber VARCHAR(20),
    CustomerName VARCHAR(100)
);
GO

IF OBJECT_ID('dbo.Dim_Location','U') IS NULL
CREATE TABLE dbo.Dim_Location
(
    LocationKey INT IDENTITY(1,1) PRIMARY KEY,
    TransactionLocation VARCHAR(100)
);
GO

IF OBJECT_ID('dbo.Dim_TransactionType','U') IS NULL
CREATE TABLE dbo.Dim_TransactionType
(
    TransactionTypeKey INT IDENTITY(1,1) PRIMARY KEY,
    TransactionType VARCHAR(50)
);
GO

PRINT 'Master Database Setup Completed Successfully';
GO

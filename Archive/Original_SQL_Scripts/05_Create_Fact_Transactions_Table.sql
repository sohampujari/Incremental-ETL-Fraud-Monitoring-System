--Step 6 — Create Staging Table--

CREATE TABLE Fact_Transactions
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


CREATE TABLE Staging_Transactions
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
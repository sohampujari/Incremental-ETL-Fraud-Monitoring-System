USE CBS_Source_DB;
GO

CREATE TABLE CBS_Transactions
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
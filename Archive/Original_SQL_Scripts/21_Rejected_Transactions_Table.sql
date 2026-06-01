CREATE TABLE Rejected_Transactions
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
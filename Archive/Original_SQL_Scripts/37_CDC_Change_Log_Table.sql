CREATE TABLE Transaction_Change_Log
(
    ChangeID INT IDENTITY(1,1) PRIMARY KEY,

    TransactionID BIGINT,

    ChangeType VARCHAR(20),

    ChangeTime DATETIME DEFAULT GETDATE()
);
GO
CREATE TABLE ETL_Audit_Log (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    PackageName VARCHAR(100),
    ExecutionStartTime DATETIME,
    ExecutionEndTime DATETIME,
    RowsProcessed INT,
    ExecutionStatus VARCHAR(20),
    ErrorMessage VARCHAR(500)
);
GO
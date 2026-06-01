CREATE TABLE ETL_Audit_Log
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,

    PackageName VARCHAR(200),

    ExecutionStartTime DATETIME,

    ExecutionEndTime DATETIME,

    RowsProcessed INT,

    ExecutionStatus VARCHAR(50)
);
GO

--Verification Query--
SELECT *
FROM ETL_Audit_Log;
GO
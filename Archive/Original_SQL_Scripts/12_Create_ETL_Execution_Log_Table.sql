USE FraudMonitoringDW;
GO

CREATE TABLE ETL_Execution_Log
(
    LogID INT IDENTITY(1,1) PRIMARY KEY,

    PackageName VARCHAR(200),

    ExecutionTime DATETIME DEFAULT GETDATE(),

    ExecutionStatus VARCHAR(50),

    RecordsProcessed INT,

    ErrorMessage VARCHAR(MAX)
);
GO

--Verify Logging Table--
SELECT *
FROM ETL_Execution_Log
ORDER BY LogID DESC;
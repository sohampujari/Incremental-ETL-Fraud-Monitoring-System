INSERT INTO ETL_Audit_Log
(
    PackageName,
    ExecutionStartTime,
    ExecutionEndTime,
    RowsProcessed,
    ExecutionStatus
)

VALUES
(
    'Master_ETL.dtsx',
    GETDATE(),
    GETDATE(),
    0,
    'FAILED'
);
GO

--Verification Query--
SELECT TOP 10 *
FROM ETL_Audit_Log
ORDER BY AuditID DESC;
GO
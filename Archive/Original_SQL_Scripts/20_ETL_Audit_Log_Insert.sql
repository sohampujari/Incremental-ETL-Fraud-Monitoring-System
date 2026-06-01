INSERT INTO ETL_Audit_Log
(
    PackageName,
    ExecutionStartTime,
    ExecutionEndTime,
    RowsProcessed,
    ExecutionStatus,
    ErrorMessage
)
VALUES
(
    'Master_ETL.dtsx',
    GETDATE(),
    GETDATE(),
    (SELECT COUNT(*) FROM Fact_Transactions),
    'SUCCESS',
    NULL
);
GO

--Verification Query--
SELECT *
FROM ETL_Audit_Log
ORDER BY AuditID DESC;
GO
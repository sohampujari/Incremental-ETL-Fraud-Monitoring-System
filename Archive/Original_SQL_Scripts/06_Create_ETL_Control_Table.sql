USE FraudMonitoringDW;
GO

CREATE TABLE ETL_Control_Table
(
    ProcessName VARCHAR(100),
    
    LastLoadedTransactionID BIGINT,
    
    LastLoadDate DATETIME
);
GO

INSERT INTO ETL_Control_Table
VALUES
(
    'Incremental_ETL_Process',
    0,
    GETDATE()
);
GO

--Verify--
SELECT * FROM ETL_Control_Table;
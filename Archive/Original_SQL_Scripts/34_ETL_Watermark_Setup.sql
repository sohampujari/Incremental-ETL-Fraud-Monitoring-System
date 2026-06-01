CREATE TABLE ETL_Watermark
(
    ProcessName VARCHAR(100) PRIMARY KEY,

    LastLoadTime DATETIME
);
GO

--Insert Initial Watermark--
INSERT INTO ETL_Watermark
(
    ProcessName,
    LastLoadTime
)

VALUES
(
    'Incremental_ETL',
    '2000-01-01'
);
GO

--Verification Query-
SELECT *
FROM ETL_Watermark;
GO
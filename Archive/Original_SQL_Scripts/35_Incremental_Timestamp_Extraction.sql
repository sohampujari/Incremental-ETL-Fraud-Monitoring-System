SELECT *
FROM CBS_Source_DB.dbo.CBS_Transactions

WHERE TransactionTime >
(
    SELECT LastLoadTime
    FROM ETL_Watermark
    WHERE ProcessName = 'Incremental_ETL'
);
GO
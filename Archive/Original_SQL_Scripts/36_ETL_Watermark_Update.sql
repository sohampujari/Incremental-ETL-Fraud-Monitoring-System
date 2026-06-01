UPDATE ETL_Watermark
SET LastLoadTime =
(
    SELECT MAX(TransactionTime)
    FROM CBS_Source_DB.dbo.CBS_Transactions
)

WHERE ProcessName = 'Incremental_ETL';
GO


--Verification Query-
SELECT *
FROM ETL_Watermark;
GO
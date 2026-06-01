EXEC usp_Incremental_Load_Staging;
GO

--Verify Staging Table Data--
SELECT TOP 20 *
FROM Staging_Transactions
ORDER BY TransactionID DESC;

--Verify ETL Control Table Updated--
SELECT *
FROM ETL_Control_Table;

--Verify Incremental Behavior--
SELECT COUNT(*) 
FROM Staging_Transactions;

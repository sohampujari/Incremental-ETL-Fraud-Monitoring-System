--Verify Automation--
SELECT TOP 20 *
FROM ETL_Execution_Log
ORDER BY LogID DESC;


SELECT COUNT(*)
FROM Fact_Transactions;
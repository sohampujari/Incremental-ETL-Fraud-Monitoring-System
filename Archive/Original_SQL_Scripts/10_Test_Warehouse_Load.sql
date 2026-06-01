EXEC usp_Load_Fact_Transactions;
GO

SELECT TOP 20 *
FROM Fact_Transactions
ORDER BY TransactionID DESC;
GO
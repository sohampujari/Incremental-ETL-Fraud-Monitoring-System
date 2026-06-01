SELECT
    DeviceID,
    COUNT(*) AS FraudCount

FROM Fact_Transactions

WHERE FraudFlag = 'YES'

GROUP BY DeviceID

ORDER BY FraudCount DESC;
GO

--IP Risk Analysis--
SELECT
    IPAddress,
    COUNT(*) AS FraudCount

FROM Fact_Transactions

WHERE FraudFlag = 'YES'

GROUP BY IPAddress

ORDER BY FraudCount DESC;
GO
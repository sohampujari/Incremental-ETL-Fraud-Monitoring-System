/*
============================================================
ANALYTICS_QUERIES.SQL
Incremental ETL Fraud Monitoring System
Dashboard & Investigation Analytics
============================================================
*/

USE FraudMonitoringDW;
GO

/*===========================================================
1. KPI METRICS
===========================================================*/

-- Total Transactions
SELECT COUNT(*) AS TotalTransactions
FROM dbo.Fact_Transactions;
GO

-- Total Fraud Transactions
SELECT COUNT(*) AS FraudTransactions
FROM dbo.Fact_Transactions
WHERE FraudFlag = 'YES';
GO

-- Fraud Percentage
SELECT
(
    CAST(SUM(CASE WHEN FraudFlag='YES' THEN 1 ELSE 0 END) AS FLOAT)
    / COUNT(*)
) * 100 AS FraudPercentage
FROM dbo.Fact_Transactions;
GO


/*===========================================================
2. FRAUD TREND ANALYSIS
===========================================================*/

SELECT
    CAST(TransactionTime AS DATE) AS TransactionDate,
    COUNT(*) AS FraudTransactionCount
FROM dbo.Fact_Transactions
WHERE FraudFlag='YES'
GROUP BY CAST(TransactionTime AS DATE)
ORDER BY TransactionDate;
GO


/*===========================================================
3. FRAUD BY LOCATION
===========================================================*/

SELECT
    TransactionLocation,
    COUNT(*) AS FraudCount
FROM dbo.Fact_Transactions
WHERE FraudFlag='YES'
GROUP BY TransactionLocation
ORDER BY FraudCount DESC;
GO


/*===========================================================
4. FRAUD BY TRANSACTION TYPE
===========================================================*/

SELECT
    TransactionType,
    COUNT(*) AS FraudCount
FROM dbo.Fact_Transactions
WHERE FraudFlag='YES'
GROUP BY TransactionType
ORDER BY FraudCount DESC;
GO


/*===========================================================
5. FRAUD SEVERITY DISTRIBUTION
===========================================================*/

SELECT
    FraudSeverity,
    COUNT(*) AS FraudCount
FROM dbo.Fraud_Alerts
GROUP BY FraudSeverity
ORDER BY FraudCount DESC;
GO


/*===========================================================
6. DEVICE RISK ANALYSIS
===========================================================*/

SELECT
    DeviceID,
    COUNT(*) AS FraudCount
FROM dbo.Fact_Transactions
WHERE FraudFlag='YES'
GROUP BY DeviceID
ORDER BY FraudCount DESC;
GO


/*===========================================================
7. IP RISK ANALYSIS
===========================================================*/

SELECT
    IPAddress,
    COUNT(*) AS FraudCount
FROM dbo.Fact_Transactions
WHERE FraudFlag='YES'
GROUP BY IPAddress
ORDER BY FraudCount DESC;
GO


/*===========================================================
8. ANALYST WORKLOAD DISTRIBUTION
===========================================================*/

SELECT
    AssignedAnalyst,
    COUNT(*) AS TotalCases,

    SUM(
        CASE
            WHEN CaseStatus='OPEN' THEN 1
            ELSE 0
        END
    ) AS OpenCases,

    SUM(
        CASE
            WHEN EscalationStatus='ESCALATED' THEN 1
            ELSE 0
        END
    ) AS EscalatedCases

FROM dbo.Fraud_Cases
GROUP BY AssignedAnalyst
ORDER BY EscalatedCases DESC, OpenCases DESC;
GO


/*===========================================================
9. CASE STATUS DISTRIBUTION
===========================================================*/

SELECT
    CaseStatus,
    COUNT(*) AS TotalCases
FROM dbo.Fraud_Cases
GROUP BY CaseStatus
ORDER BY TotalCases DESC;
GO


/*===========================================================
10. ACTIVE FRAUD ALERTS
===========================================================*/

SELECT
    AlertStatus,
    COUNT(*) AS AlertCount
FROM dbo.Fraud_Alerts
GROUP BY AlertStatus;
GO


/*===========================================================
11. TOP HIGH RISK TRANSACTIONS
===========================================================*/

SELECT TOP 20
    TransactionID,
    CustomerName,
    TransactionAmount,
    TransactionLocation,
    TransactionType,
    RiskScore
FROM dbo.Fact_Transactions
ORDER BY RiskScore DESC, TransactionAmount DESC;
GO

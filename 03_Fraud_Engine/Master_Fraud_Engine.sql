/*
============================================================
MASTER_FRAUD_ENGINE.SQL
Incremental ETL Fraud Monitoring System
============================================================
*/

USE FraudMonitoringDW;
GO

/*----------------------------------------------------------
1. ADD FRAUD COLUMNS TO FACT TABLE
----------------------------------------------------------*/
IF COL_LENGTH('dbo.Fact_Transactions','RiskScore') IS NULL
    ALTER TABLE dbo.Fact_Transactions ADD RiskScore INT;
GO

IF COL_LENGTH('dbo.Fact_Transactions','FraudSeverity') IS NULL
    ALTER TABLE dbo.Fact_Transactions ADD FraudSeverity VARCHAR(20);
GO

/*----------------------------------------------------------
2. RISK SCORING ENGINE
----------------------------------------------------------*/
UPDATE dbo.Fact_Transactions
SET RiskScore =
      CASE WHEN TransactionAmount > 150000 THEN 50 ELSE 0 END
    + CASE WHEN TransactionStatus = 'FAILED' THEN 30 ELSE 0 END
    + CASE
        WHEN TransactionType = 'ATM' THEN 10
        WHEN TransactionType = 'UPI' THEN 5
        ELSE 0
      END;
GO

/*----------------------------------------------------------
3. FRAUD FLAG GENERATION
----------------------------------------------------------*/
UPDATE dbo.Fact_Transactions
SET FraudFlag =
    CASE
        WHEN RiskScore >= 50 THEN 'YES'
        ELSE 'NO'
    END;
GO

/*----------------------------------------------------------
4. FRAUD SEVERITY CLASSIFICATION
----------------------------------------------------------*/
UPDATE dbo.Fact_Transactions
SET FraudSeverity =
    CASE
        WHEN RiskScore >= 70 THEN 'HIGH'
        WHEN RiskScore >= 30 THEN 'MEDIUM'
        ELSE 'LOW'
    END;
GO

/*----------------------------------------------------------
5. FRAUD CASE TABLE
----------------------------------------------------------*/
IF OBJECT_ID('dbo.Fraud_Cases','U') IS NULL
CREATE TABLE dbo.Fraud_Cases
(
    CaseID INT IDENTITY(1,1) PRIMARY KEY,
    AlertID INT,
    AssignedAnalyst VARCHAR(100),
    CaseStatus VARCHAR(50) DEFAULT 'OPEN',
    InvestigationNotes VARCHAR(500),
    CreatedTime DATETIME DEFAULT GETDATE(),
    ClosedTime DATETIME NULL,
    SLA_Hours INT DEFAULT 24,
    EscalationStatus VARCHAR(50) DEFAULT 'NORMAL'
);
GO

/*----------------------------------------------------------
6. FRAUD ALERT GENERATION
----------------------------------------------------------*/
INSERT INTO dbo.Fraud_Alerts
(
    TransactionID,
    AccountNumber,
    RiskScore,
    FraudSeverity
)
SELECT
    f.TransactionID,
    f.AccountNumber,
    f.RiskScore,
    CASE
        WHEN f.RiskScore >= 90 THEN 'CRITICAL'
        WHEN f.RiskScore >= 70 THEN 'HIGH'
        WHEN f.RiskScore >= 50 THEN 'MEDIUM'
        ELSE 'LOW'
    END
FROM dbo.Fact_Transactions f
WHERE f.RiskScore >= 50
AND NOT EXISTS
(
    SELECT 1
    FROM dbo.Fraud_Alerts a
    WHERE a.TransactionID = f.TransactionID
);
GO

/*----------------------------------------------------------
7. AUTO FRAUD CASE CREATION
----------------------------------------------------------*/
CREATE OR ALTER TRIGGER dbo.trg_Auto_Create_Fraud_Case
ON dbo.Fraud_Alerts
AFTER INSERT
AS
BEGIN
    INSERT INTO dbo.Fraud_Cases
    (
        AlertID,
        AssignedAnalyst,
        CaseStatus,
        InvestigationNotes
    )
    SELECT
        AlertID,
        CASE
            WHEN FraudSeverity='CRITICAL' THEN 'Senior Analyst'
            WHEN FraudSeverity='HIGH' THEN 'Fraud Analyst'
            ELSE 'Junior Analyst'
        END,
        'OPEN',
        'Auto-generated fraud investigation case'
    FROM inserted;
END;
GO

/*----------------------------------------------------------
8. CASE ESCALATION LOGIC
----------------------------------------------------------*/
UPDATE dbo.Fraud_Cases
SET EscalationStatus='ESCALATED'
WHERE CaseStatus='OPEN'
AND DATEDIFF(HOUR,CreatedTime,GETDATE()) > SLA_Hours;
GO

PRINT 'Master Fraud Engine Setup Completed Successfully';
GO

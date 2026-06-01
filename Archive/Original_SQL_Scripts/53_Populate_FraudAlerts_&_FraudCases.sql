--Step 1: Populate Fraud_Alerts--
INSERT INTO Fraud_Alerts
(
    TransactionID,
    AccountNumber,
    RiskScore,
    FraudSeverity
)
SELECT
    TransactionID,
    AccountNumber,
    CASE
        WHEN TransactionAmount > 150000 THEN 95
        WHEN TransactionAmount > 100000 THEN 80
        ELSE 60
    END AS RiskScore,
    CASE
        WHEN TransactionAmount > 150000 THEN 'Critical'
        WHEN TransactionAmount > 100000 THEN 'High'
        ELSE 'Medium'
    END AS FraudSeverity
FROM Fact_Transactions
WHERE FraudFlag = 'YES';

--Verify--
SELECT COUNT(*) FROM Fraud_Alerts;


--Step 2: Populate Fraud_Cases--
INSERT INTO Fraud_Cases
(
    AlertID,
    AssignedAnalyst,
    CaseStatus,
    InvestigationNotes,
    EscalationStatus
)
SELECT
    AlertID,

    CASE AlertID % 4
        WHEN 0 THEN 'Rahul Sharma'
        WHEN 1 THEN 'Priya Patel'
        WHEN 2 THEN 'Amit Kumar'
        ELSE 'Neha Singh'
    END,

    CASE AlertID % 3
        WHEN 0 THEN 'Open'
        WHEN 1 THEN 'In Progress'
        ELSE 'Closed'
    END,

    'Auto-generated investigation case',

    CASE
        WHEN RiskScore >= 90 THEN 'Escalated'
        ELSE 'Normal'
    END
FROM Fraud_Alerts;

--Verify--
SELECT COUNT(*) FROM Fraud_Cases;

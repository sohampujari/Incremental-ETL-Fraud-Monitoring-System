CREATE TRIGGER trg_Auto_Create_Fraud_Case
ON Fraud_Alerts

AFTER INSERT
AS
BEGIN

    INSERT INTO Fraud_Cases
    (
        AlertID,
        AssignedAnalyst,
        CaseStatus,
        InvestigationNotes
    )

    SELECT
        AlertID,

        CASE
            WHEN FraudSeverity = 'CRITICAL'
                THEN 'Senior Analyst'

            WHEN FraudSeverity = 'HIGH'
                THEN 'Fraud Analyst'

            ELSE 'Junior Analyst'
        END,

        'OPEN',

        'Auto-generated fraud investigation case'

    FROM inserted;

END;
GO

--Test The Trigger--
INSERT INTO Fraud_Alerts
(
    TransactionID,
    AccountNumber,
    RiskScore,
    FraudSeverity
)

VALUES
(
    888888,
    'ACC8888',
    95,
    'CRITICAL'
);
GO

--Verify Case Auto-Created--
SELECT TOP 10 *
FROM Fraud_Cases
ORDER BY CaseID DESC;
GO
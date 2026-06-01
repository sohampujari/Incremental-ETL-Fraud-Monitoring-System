UPDATE Fraud_Cases
SET EscalationStatus = 'ESCALATED'

WHERE
    CaseStatus = 'OPEN'

    AND DATEDIFF
    (
        HOUR,
        CreatedTime,
        GETDATE()
    ) > SLA_Hours;
GO

--Test Escalation Logic--
INSERT INTO Fraud_Cases
(
    AlertID,
    AssignedAnalyst,
    CaseStatus,
    InvestigationNotes,
    CreatedTime,
    SLA_Hours
)

VALUES
(
    9999,
    'Junior Analyst',
    'OPEN',
    'Test overdue fraud case',

    DATEADD(HOUR, -30, GETDATE()),

    24
);
GO

--Verify Escalation--
SELECT TOP 20
    CaseID,
    AssignedAnalyst,
    CaseStatus,
    SLA_Hours,
    EscalationStatus,
    CreatedTime

FROM Fraud_Cases
ORDER BY CaseID DESC;
GO
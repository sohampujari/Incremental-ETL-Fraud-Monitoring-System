SELECT
    AssignedAnalyst,

    COUNT(*) AS TotalCases,

    SUM
    (
        CASE
            WHEN CaseStatus = 'OPEN'
                THEN 1
            ELSE 0
        END
    ) AS OpenCases,

    SUM
    (
        CASE
            WHEN EscalationStatus = 'ESCALATED'
                THEN 1
            ELSE 0
        END
    ) AS EscalatedCases

FROM Fraud_Cases

GROUP BY AssignedAnalyst

ORDER BY EscalatedCases DESC,
         OpenCases DESC;
GO
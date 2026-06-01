ALTER TABLE Fraud_Cases
ADD
    SLA_Hours INT DEFAULT 24,

    EscalationStatus VARCHAR(50) DEFAULT 'NORMAL';
GO

--Verification Query--
SELECT TOP 10 *
FROM Fraud_Cases;
GO
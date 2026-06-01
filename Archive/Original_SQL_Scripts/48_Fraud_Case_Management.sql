CREATE TABLE Fraud_Cases
(
    CaseID INT IDENTITY(1,1) PRIMARY KEY,

    AlertID INT,

    AssignedAnalyst VARCHAR(100),

    CaseStatus VARCHAR(50) DEFAULT 'OPEN',

    InvestigationNotes VARCHAR(500),

    CreatedTime DATETIME DEFAULT GETDATE(),

    ClosedTime DATETIME NULL
);
GO

--Verification Query--
SELECT *
FROM Fraud_Cases;
GO
INSERT INTO CBS_Transactions
(
    AccountNumber,
    CustomerName,
    TransactionType,
    TransactionAmount,
    MerchantCategory,
    TransactionLocation,
    DeviceID,
    IPAddress,
    TransactionStatus
)
VALUES
('ACC1001', 'Rahul Sharma', 'UPI', 2500.00, 'Groceries', 'Mumbai', 'DEV1001', '192.168.1.1', 'SUCCESS'),

('ACC1002', 'Priya Verma', 'ATM', 10000.00, 'Cash Withdrawal', 'Pune', 'DEV1002', '192.168.1.2', 'SUCCESS'),

('ACC1003', 'Amit Joshi', 'Card', 75000.00, 'Electronics', 'Delhi', 'DEV1003', '192.168.1.3', 'SUCCESS'),

('ACC1004', 'Sneha Patil', 'UPI', 500.00, 'Food', 'Bangalore', 'DEV1004', '192.168.1.4', 'FAILED'),

('ACC1005', 'Karan Mehta', 'NetBanking', 120000.00, 'Travel', 'Hyderabad', 'DEV1005', '192.168.1.5', 'SUCCESS');
GO

--Verify Data--
SELECT * FROM CBS_Transactions;
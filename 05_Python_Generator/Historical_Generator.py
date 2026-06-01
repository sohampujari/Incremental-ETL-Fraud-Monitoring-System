import pyodbc
import random
from faker import Faker
from datetime import datetime, timedelta

fake = Faker()

conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=localhost;'
    'DATABASE=CBS_Source_DB;'
    'Trusted_Connection=yes;'
)

cursor = conn.cursor()

rows_to_generate = 20000

transaction_types = (
    ['UPI'] * 40 +
    ['Card'] * 30 +
    ['ATM'] * 15 +
    ['NetBanking'] * 15
)

locations = (
    ['Mumbai'] * 22 +
    ['Delhi'] * 18 +
    ['Bangalore'] * 17 +
    ['Hyderabad'] * 15 +
    ['Pune'] * 15 +
    ['Chennai'] * 13
)

merchant_categories = [
    'Groceries',
    'Travel',
    'Electronics',
    'Food',
    'Fuel',
    'Shopping'
]

statuses = (
    ['SUCCESS'] * 95 +
    ['FAILED'] * 5
)

start_date = datetime(2025, 1, 1)
end_date = datetime(2025, 12, 31)

print("Generating historical data...")

for i in range(rows_to_generate):

    account_number = f"ACC{random.randint(1000,9999)}"

    customer_name = fake.name()

    transaction_type = random.choice(transaction_types)

    transaction_amount = round(
        random.triangular(100, 200000, 5000),
        2
    )

    merchant_category = random.choice(
        merchant_categories
    )

    transaction_location = random.choice(
        locations
    )

    device_id = f"DEV{random.randint(1000,9999)}"

    ip_address = fake.ipv4()

    transaction_status = random.choice(
        statuses
    )

    transaction_time = start_date + timedelta(
        seconds=random.randint(
            0,
            int((end_date - start_date).total_seconds())
        )
    )

    cursor.execute(
        """
        INSERT INTO CBS_Transactions
        (
            AccountNumber,
            CustomerName,
            TransactionType,
            TransactionAmount,
            TransactionTime,
            MerchantCategory,
            TransactionLocation,
            DeviceID,
            IPAddress,
            TransactionStatus
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            account_number,
            customer_name,
            transaction_type,
            transaction_amount,
            transaction_time,
            merchant_category,
            transaction_location,
            device_id,
            ip_address,
            transaction_status
        )
    )

    if i % 1000 == 0:
        conn.commit()
        print(f"{i} rows inserted")

conn.commit()

print("Historical load complete.")

cursor.close()
conn.close()
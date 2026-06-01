import pyodbc
import random
import time
from faker import Faker

fake = Faker()

# SQL Server Connection
conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=localhost;'
    'DATABASE=CBS_Source_DB;'
    'Trusted_Connection=yes;'
)

cursor = conn.cursor()

transaction_types = ['UPI', 'ATM', 'Card', 'NetBanking']
merchant_categories = ['Groceries', 'Travel', 'Electronics', 'Food', 'Fuel', 'Shopping']
locations = ['Mumbai', 'Delhi', 'Pune', 'Hyderabad', 'Bangalore', 'Chennai']
statuses = ['SUCCESS', 'FAILED']

print("Live Transaction Generator Started...")

while True:

    account_number = f"ACC{random.randint(1000,9999)}"

    customer_name = fake.name()

    transaction_type = random.choice(transaction_types)

    transaction_amount = round(random.uniform(100, 200000), 2)

    merchant_category = random.choice(merchant_categories)

    transaction_location = random.choice(locations)

    device_id = f"DEV{random.randint(1000,9999)}"

    ip_address = fake.ipv4()

    transaction_status = random.choice(statuses)

    insert_query = """
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
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    """

    values = (
        account_number,
        customer_name,
        transaction_type,
        transaction_amount,
        merchant_category,
        transaction_location,
        device_id,
        ip_address,
        transaction_status
    )

    cursor.execute(insert_query, values)

    conn.commit()

    print(f"Inserted Transaction: {account_number} | Amount: {transaction_amount}")

    time.sleep(3)
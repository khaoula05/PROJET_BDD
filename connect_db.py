import mysql.connector

# Read your SQL file content
with open('PROJET.sql', 'r', encoding='utf-8') as f:
    sql_script = f.read()

# Connect to your MySQL server
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='Assia@200579',
    # no database here because your script creates it
    autocommit=True
)
cursor = conn.cursor()

# The SQL script includes DROP DATABASE and CREATE DATABASE commands,
# so you don't need to specify a database here

try:
    for result in cursor.execute(sql_script, multi=True):
        # This loop executes each statement in the script
        if result.with_rows:
            print(f"Rows produced by statement: {result.statement}")
            print(result.fetchall())
        else:
            print(f"Statement executed: {result.statement}")
    print("Database initialized successfully.")
except mysql.connector.Error as err:
    print(f"Error: {err}")

cursor.close()
conn.close()


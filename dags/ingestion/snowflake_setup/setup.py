import os
import snowflake.connector

user = os.getenv("SNOWFLAKE_USER")
password = os.getenv("SNOWFLAKE_PASSWORD")
account = os.getenv("SNOWFLAKE_ACCOUNT")
warehouse = os.getenv("SNOWFLAKE_WAREHOUSE")
database = os.getenv("SNOWFLAKE_DATABASE")
schema = os.getenv("SNOWFLAKE_SCHEMA")

conn = snowflake.connector.connect(
    user=user,
    password=password,
    account=account,
    warehouse=warehouse,
    database=database,
    schema=schema
)

cursor = conn.cursor()

def execute_sql_file(file_path):
    with open(file_path, 'r') as file:
        queries = file.read().split(';')  # Split queries by semicolon
        for query in queries:
            if query.strip():
                print(f"Executing query: {query.strip().format(user_name=user)}")
                cursor.execute(query.strip().format(user_name=user))  # Execute each query

sql_file_path = "./dags/ingestion/snowflake_setup/setup_queries.sql"
execute_sql_file(sql_file_path)

cursor.close()
conn.close()

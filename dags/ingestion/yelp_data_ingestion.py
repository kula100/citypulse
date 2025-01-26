import os
import snowflake.connector

# Retrieve environment variables
user = os.getenv("SNOWFLAKE_USER")
password = os.getenv("SNOWFLAKE_PASSWORD")
account = os.getenv("SNOWFLAKE_ACCOUNT")
warehouse = os.getenv("SNOWFLAKE_WAREHOUSE")
database = os.getenv("SNOWFLAKE_DATABASE")
schema = os.getenv("SNOWFLAKE_SCHEMA")
stage = os.getenv("SNOWFLAKE_STAGE")
target_dir = os.getenv("TARGET_DIR")

# Connect to Snowflake
conn = snowflake.connector.connect(
    user=user,
    password=password,
    account=account,
    warehouse=warehouse,
    database=database,
    schema=schema
)

cursor = conn.cursor()

# Function to upload files to Snowflake stage
def upload_file_to_stage(file_path, stage):
    try:
        print(f"Uploading {file_path} to Snowflake stage {stage}...")
        cursor.execute(f"PUT file://{file_path} @{stage}")
        print(f"Uploaded {file_path} successfully.")
    except Exception as e:
        print(f"Error uploading {file_path}: {str(e)}")

# Function to perform the COPY INTO operation
def copy_into_table(stage, table):
    try:
        print(f"Copying data from stage {stage} into table {table}...")
        cursor.execute(f"COPY INTO {table} FROM @{stage} FILE_FORMAT = (TYPE = 'CSV')")
        print("Data copied successfully.")
    except Exception as e:
        print(f"Error during COPY INTO: {str(e)}")

# Upload dataset files to Snowflake stage
dataset_dir = target_dir
for file_name in os.listdir(dataset_dir):
    file_path = os.path.join(dataset_dir, file_name)
    if file_name.endswith('.csv'):  # Assuming dataset files are in CSV format
        upload_file_to_stage(file_path, stage)

# Perform COPY INTO operation (adjust table name accordingly)
copy_into_table(stage, "your_table_name")

# Close connection
cursor.close()
conn.close()

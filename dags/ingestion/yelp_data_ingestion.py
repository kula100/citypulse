import os
import glob
import snowflake.connector
from utils import logger

logger = logger()

SNOWFLAKE_ACCOUNT = os.getenv("SNOWFLAKE_ACCOUNT")
SNOWFLAKE_USER = os.getenv("SNOWFLAKE_USER")
SNOWFLAKE_PASSWORD = os.getenv("SNOWFLAKE_PASSWORD")
SNOWFLAKE_WAREHOUSE = os.getenv("SNOWFLAKE_WAREHOUSE")
SNOWFLAKE_ROLE = "prod_role"
SNOWFLAKE_DATABASE = "raw"
SNOWFLAKE_SCHEMA = "yelp"
SNOWFLAKE_STAGE = os.getenv("SNOWFLAKE_STAGE")
TARGET_DIR = os.getenv("TARGET_DIR")

tables = {"tip", "business", "checkin", "user", "review"}

def upload_files_to_stage(cursor, table_name, files):
    """
        Uploads files to the Snowflake stage
        Args:
            cursor: Snowflake connection cursor
            table_name: Name of the table
            files: List of files
    """
    for file in files:
        logger.info("Uploading %s to %s stage...", file, SNOWFLAKE_STAGE)
        put_query = f"PUT file://{file} @{SNOWFLAKE_STAGE}/{table_name}/"
        cursor.execute(put_query)
        logger.info("File %s uploaded to %s stage", file, SNOWFLAKE_STAGE)

def copy_files_to_table(cursor, table_name):
    """
        Executes COPY INTO command to load data into the table.
        Args:
            cursor: Snowflake connection cursor
            table_name: Name of the table
    """
    logger.info("Copying files into %s ...", table_name)
    copy_query = f"""
        COPY INTO {table_name}
        FROM (SELECT PARSE_JSON($1), CURRENT_TIMESTAMP
            FROM @{SNOWFLAKE_STAGE}/{table_name})
        FILE_FORMAT = (TYPE = PARQUET)
    """
    cursor.execute(copy_query)
    logger.info("Files copied into the table %s", table_name)

def main():
    conn = snowflake.connector.connect(
        user=SNOWFLAKE_USER,
        password=SNOWFLAKE_PASSWORD,
        account=SNOWFLAKE_ACCOUNT,
        warehouse=SNOWFLAKE_WAREHOUSE,
        database=SNOWFLAKE_DATABASE,
        schema=SNOWFLAKE_SCHEMA,
        disable_ocsp_checkssss=True,
    )

    cursor = conn.cursor()

    try:
        cursor.execute(f"CREATE OR REPLACE STAGE {SNOWFLAKE_STAGE}")
        for table in tables:
            table_name = f"raw_{table}"
            create_table_query = f"""
                CREATE TABLE IF NOT EXISTS {table_name} (
                    raw_data VARIANT,
                    ingestion_datetime TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP
                )
            """
            logger.info("Creating %s table: %s", table_name, create_table_query)
            cursor.execute(create_table_query)
            logger.info("%s table Created", table_name)
            files = glob.glob(os.path.join(TARGET_DIR, f"{table}_*.parquet"))
            if files:
                logger.info("Files found for %s: %s", table, files)
                upload_files_to_stage(cursor, table_name, files)
                copy_files_to_table(cursor, table_name)
            else:
                logger.info("No files found for %s", table)
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    main()

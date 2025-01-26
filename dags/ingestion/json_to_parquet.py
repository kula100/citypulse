import pandas as pd
from utils import logger

logger = logger()

CHUNK_SIZE = 1000000

datasets = {"tip", "business", "checkin", "user", "review"}

FILE_PATH = "path/to/yelp/dataset/yelp_academic_dataset_{}.json"
TARGET_PATH = "./data/"

for dataset in datasets:
    file_path = FILE_PATH.format(dataset)

    # Read the JSON file in chunks
    chunks = pd.read_json(
        file_path,
        lines=True,
        chunksize=CHUNK_SIZE,
    )

    logger.info("Converting %s to Parquet", file_path)

    # Convert each chunk to Parquet and append to a Parquet file
    for i, chunk in enumerate(chunks):
        file_name = f"{dataset}_{i}.parquet"
        target_file_path = f"{TARGET_PATH}{file_name}"
        chunk.to_parquet(target_file_path, engine="pyarrow", compression="gzip")
        logger.info("Chunk %s converted and stored at %s", i, target_file_path)

import os
from supabase import create_client

url = os.environ["SUPABASE_URL"]
key = os.environ["SUPABASE_SERVICE_KEY"]
supabase = create_client(url, key)

artifacts = ["manifest.json",]
bucket = "dbt-artifacts"
project = "citypulse"
version = "latest"

download_folder = os.environ.get("DBT_ARTIFACT_DIR", "target-deferred")

for artifact in artifacts:
    storage_path = f"{project}/{version}/{artifact}"
    res = supabase.storage.from_(bucket).download(storage_path)
    with open(f"../../dbt/{download_folder}/{artifact}", "wb") as f:
        f.write(res)

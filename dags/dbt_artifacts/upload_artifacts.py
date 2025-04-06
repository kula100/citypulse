import os
from supabase import create_client

url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_SERVICE_KEY")
supabase = create_client(url, key)

artifacts = ["manifest.json",]
bucket = "dbt-artifacts"
project = "citypulse"
version = "latest"

for artifact in artifacts:
    path = f"../../dbt/target/{artifact}"
    storage_path = f"{project}/{version}/{artifact}"
    with open(path, "rb") as f:
        supabase.storage.from_(bucket).upload(storage_path, f, {"upsert": True})

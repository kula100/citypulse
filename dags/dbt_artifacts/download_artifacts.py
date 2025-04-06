import os
from supabase import create_client

url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_SERVICE_KEY")
supabase = create_client(url, key)

artifacts = ["manifest.json",]
bucket = "dbt-artifacts"
project = "citypulse"
version = "latest"

download_folder = os.environ.get("DBT_ARTIFACT_DIR", "target-deferred")
target_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "dbt", download_folder))


for artifact in artifacts:
    storage_path = f"{project}/{version}/{artifact}"
    res = supabase.storage.from_(bucket).download(storage_path)
    path = os.path.join(target_dir, artifact)
    with open(path, "wb") as f:
        f.write(res)

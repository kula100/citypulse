import os
from supabase import create_client

url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_SERVICE_KEY")
supabase = create_client(url, key)

artifacts = ["manifest.json",]
bucket = "dbt-artifacts"
project = "citypulse"
version = "latest"
target_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "target"))
print(f"Looking for artifacts in: {target_dir}")


for artifact in artifacts:
    path = os.path.join(target_dir, artifact)
    storage_path = f"{project}/{version}/{artifact}"
    print(f"ℹ Uploading {storage_path} to Supabase...")
    with open(path, "rb") as f:
        supabase.storage.from_(bucket).upload(storage_path, f, {"upsert": True})
    print(f"✅ Uploaded {artifact}")

import boto3

def check_unencrypted_rds():
    rds = boto3.client("rds")
    instances = rds.describe_db_instances()["DBInstances"]

    print("🔎 Checking RDS instances for encryption at rest...\n")

    for db in instances:
        if not db.get("StorageEncrypted"):
            print(f"🔴 RDS Instance '{db['DBInstanceIdentifier']}' is NOT encrypted!")

if __name__ == "__main__":
    check_unencrypted_rds()

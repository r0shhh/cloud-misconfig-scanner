import boto3

def check_cloudtrail_config():
    ct = boto3.client("cloudtrail")
    trails = ct.describe_trails()['trailList']

    print("🔎 Checking CloudTrail configuration...\n")

    if not trails:
        print("🔴 No CloudTrails found in this account!")
        return

    for trail in trails:
        trail_name = trail['Name']
        print(f"🔍 Inspecting trail: {trail_name}")

        if not trail.get("IsMultiRegionTrail"):
            print(f"  ⚠️  Trail '{trail_name}' is NOT multi-region")

        if not trail.get("IncludeGlobalServiceEvents"):
            print(f"  ⚠️  Trail '{trail_name}' does NOT log global events")

        if not trail.get("LogFileValidationEnabled"):
            print(f"  ⚠️  Trail '{trail_name}' does NOT have log validation enabled")

        # Check logging status
        status = ct.get_trail_status(Name=trail_name)
        if not status.get("IsLogging"):
            print(f"  🔴 Logging is DISABLED on trail '{trail_name}'")

if __name__ == "__main__":
    check_cloudtrail_config()

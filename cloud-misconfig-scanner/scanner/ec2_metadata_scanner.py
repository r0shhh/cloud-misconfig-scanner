import boto3

def check_imdsv1_instances():
    ec2 = boto3.client("ec2")
    print("🔎 Checking EC2 instances for IMDSv1 access...\n")

    reservations = ec2.describe_instances()["Reservations"]

    for res in reservations:
        for inst in res["Instances"]:
            instance_id = inst["InstanceId"]
            metadata = inst.get("MetadataOptions", {})

            http_tokens = metadata.get("HttpTokens", "optional")
            http_endpoint = metadata.get("HttpEndpoint", "enabled")

            if http_tokens != "required":
                print(f"🔴 Instance '{instance_id}' ALLOWS IMDSv1 (HttpTokens = {http_tokens})")
            else:
                print(f"✅ Instance '{instance_id}' requires IMDSv2")

if __name__ == "__main__":
    check_imdsv1_instances()

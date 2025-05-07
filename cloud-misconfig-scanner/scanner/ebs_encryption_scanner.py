import boto3

def check_unencrypted_ebs_volumes():
    ec2 = boto3.client("ec2")
    volumes = ec2.describe_volumes()["Volumes"]

    print("🔎 Checking EBS volumes for encryption...\n")

    for vol in volumes:
        if not vol.get("Encrypted"):
            print(f"🔴 EBS Volume '{vol['VolumeId']}' is NOT encrypted!")

if __name__ == "__main__":
    check_unencrypted_ebs_volumes()

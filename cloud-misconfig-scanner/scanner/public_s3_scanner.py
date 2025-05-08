'''import boto3
import json


def is_public_acl(grants):
    for grant in grants:
        grantee = grant.get('Grantee', {})
        permission = grant.get('Permission', '')

        if grantee.get('URI') == 'http://acs.amazonaws.com/groups/global/AllUsers':
            return f"ACL Public ({permission})"
    return None

def is_public_policy(policy):
    try:
        policy_json = json.loads(policy)
        for statement in policy_json.get('Statement', []):
            principal = statement.get('Principal')
            effect = statement.get('Effect', '')
            condition = statement.get('Condition', {})

            if effect == "Allow" and principal == "*" and not condition:
                return f"Policy Public (Allows * access)"
    except Exception:
        pass
    return None

def check_public_s3_buckets():
    s3 = boto3.client('s3')
    response = s3.list_buckets()

    print("🔎 Checking S3 buckets for public access...\n")
    for bucket in response['Buckets']:
        bucket_name = bucket['Name']
        print(f"🔍 Analyzing '{bucket_name}'...")

        try:
            acl = s3.get_bucket_acl(Bucket=bucket_name)
            acl_status = is_public_acl(acl['Grants'])

            try:
                policy_str = s3.get_bucket_policy(Bucket=bucket_name)['Policy']
                policy_status = is_public_policy(policy_str)
            except s3.exceptions.from_code('NoSuchBucketPolicy'):
                policy_status = None

            if acl_status or policy_status:
                print(f"🔴 Bucket '{bucket_name}' is PUBLIC!")
                if acl_status:
                    print(f"   ➤ {acl_status}")
                if policy_status:
                    print(f"   ➤ {policy_status}")

            else:
                print(f"✅ Bucket '{bucket_name}' is private")

        except Exception as e:
            print(f"⚠️ Could not check bucket '{bucket_name}': {e}")

if __name__ == "__main__":
    check_public_s3_buckets()'''


import boto3
import json

def check_public_s3_buckets():
    s3 = boto3.client("s3")
    buckets = s3.list_buckets()["Buckets"]

    print("🔎 Checking S3 buckets for public access...\n")

    for bucket in buckets:
        bucket_name = bucket["Name"]
        print(f"🔍 Analyzing '{bucket_name}'...")

        try:
            acl = s3.get_bucket_acl(Bucket=bucket_name)
            policy_status = s3.get_bucket_policy_status(Bucket=bucket_name)
            is_public = policy_status.get("PolicyStatus", {}).get("IsPublic", False)

            if is_public:
                print(f"🔴 Bucket '{bucket_name}' is PUBLIC!")
                print("   ➤ Policy Public (Allows * access)")
            

            else:
                print(f"✅ Bucket '{bucket_name}' is private")

        except Exception as e:
            print(f"⚠️  Could not check bucket '{bucket_name}': {e}")

if __name__ == "__main__":
    check_public_s3_buckets()

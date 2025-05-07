import boto3
import json

def is_wildcard_policy(policy_document):
    statements = policy_document.get("Statement", [])
    if not isinstance(statements, list):
        statements = [statements]

    for statement in statements:
        if (
            statement.get("Effect") == "Allow" and
            statement.get("Action") in ["*", ["*"]] and
            statement.get("Resource") == "*"
        ):
            return True
    return False

def check_over_permissive_roles():
    iam = boto3.client('iam')
    roles = iam.list_roles()['Roles']

    print("🔎 Checking IAM roles for over-permissive policies...\n")

    for role in roles:
        role_name = role['RoleName']
        print(f"🔍 Inspecting role: {role_name}")

        # Check inline policies
        inline_policies = iam.list_role_policies(RoleName=role_name)['PolicyNames']
        for policy_name in inline_policies:
            policy = iam.get_role_policy(RoleName=role_name, PolicyName=policy_name)
            if is_wildcard_policy(policy['PolicyDocument']):
                print(f"🔴 Role '{role_name}' has an INLINE wildcard policy: {policy_name}")

        # Check attached managed policies
        attached_policies = iam.list_attached_role_policies(RoleName=role_name)['AttachedPolicies']
        for attached in attached_policies:
            policy_arn = attached['PolicyArn']
            version = iam.get_policy(PolicyArn=policy_arn)['Policy']['DefaultVersionId']
            policy = iam.get_policy_version(PolicyArn=policy_arn, VersionId=version)
            if is_wildcard_policy(policy['PolicyVersion']['Document']):
                print(f"🔴 Role '{role_name}' has an ATTACHED wildcard policy: {attached['PolicyName']}")

if __name__ == "__main__":
    check_over_permissive_roles()

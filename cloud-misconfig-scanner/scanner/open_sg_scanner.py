import boto3

DANGEROUS_PORTS = [22, 3389]

def check_open_security_groups():
    ec2 = boto3.client('ec2')
    response = ec2.describe_security_groups()

    print("🔎 Checking Security Groups for open access on sensitive ports...\n")

    for sg in response['SecurityGroups']:
        sg_name = sg.get('GroupName', 'Unnamed')
        sg_id = sg.get('GroupId')

        for rule in sg.get('IpPermissions', []):
            from_port = rule.get('FromPort')
            to_port = rule.get('ToPort')

            for ip_range in rule.get('IpRanges', []):
                cidr = ip_range.get('CidrIp')
                if cidr == '0.0.0.0/0':
                    # Match any open dangerous port
                    if from_port in DANGEROUS_PORTS or (from_port == 0 and to_port == 65535):
                        print(f"🔴 Security Group '{sg_name}' ({sg_id}) allows {from_port}-{to_port} from 0.0.0.0/0")
                        break

if __name__ == "__main__":
    check_open_security_groups()

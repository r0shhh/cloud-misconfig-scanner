# Cloud Misconfiguration Scanner 🔍☁️

A DevSecOps project that simulates and scans for common AWS security misconfigurations, with both insecure and secure Terraform examples.

## 🎯 Objective

This project simulates real-world cloud security misconfigurations in AWS and builds an automated scanner system to detect them. The goal is to align with DevSecOps and cloud security best practices, strengthening our skills and portfolio for cybersecurity job roles.

## 👥 Team Roles

### 👤 Cloud Engineer – Misconfiguration Creator
- Created insecure AWS resources using Terraform
- Created secure versions of each misconfiguration for remediation reference

### 👤 Security Engineer – Misconfiguration Scanner Developer
- Developed Python-based scanners using boto3
- Used ScoutSuite and Prowler for cross-checks
- Integrated alerting mechanisms (Slack/print-based alerts)

## ☁️ Misconfigurations Covered

| Misconfiguration            | Description                              | Risk                          |
|-----------------------------|------------------------------------------|-------------------------------|
| S3 Bucket (ACL)             | Public-read or public-write buckets      | Data leakage                  |
| IAM Role (Policy)           | Wildcard `"Action": "*"` permissions     | Privilege escalation          |
| Security Group              | Ports 22/3389 open to 0.0.0.0/0          | Brute-force entry             |
| RDS / EBS                   | Unencrypted at rest                      | Compliance violations         |
| CloudTrail                  | Logging disabled or missing in regions   | No audit trail                |
| EC2 Instance Metadata       | IMDSv1 enabled                           | SSRF → credential theft       |

## 🧪 Scanner Features (Python-based)

Each script uses `boto3` to scan for a specific issue:

| Scanner                          | Checks For                              |
|----------------------------------|-----------------------------------------|
| `public_s3_scanner.py`           | Public access to buckets                |
| `iam_wildcard_scanner.py`        | Wildcard permissions in IAM             |
| `open_sg_scanner.py`             | Open ports (22, 3389) in security groups|
| `rds_encryption_scanner.py`      | RDS encryption                          |
| `ebs_encryption_scanner.py`      | EBS encryption                          |
| `cloudtrail_scanner.py`          | Trail presence and multi-region         |
| `ec2_metadata_scanner.py`        | IMDSv1 vs IMDSv2                        |

## 🔔 Alerting
Optional alerts (Slack/webhook) can be triggered on detection of critical misconfigurations.

## 🛠️ Remediation Examples (Terraform)

The project includes both insecure and secure Terraform setups for each misconfiguration.

### 🔓 Insecure Examples:
- Public S3 bucket
- Over-permissive IAM role
- Open Security Group
- EC2 with IMDSv1
- Unencrypted EBS & RDS
- No CloudTrail

### 🔐 Secure Examples:
- S3 with block public access
- IAM with least privilege
- Restricted Security Group
- EC2 with IMDSv2 enforced
- Encrypted EBS & RDS
- Multi-region CloudTrail enabled

## 📁 Project Structure
 ```text
cloud-misconfig-scanner/
├── scanner/                        # Python misconfiguration scanners
│   ├── public_s3_scanner.py
│   ├── iam_wildcard_scanner.py
│   ├── open_sg_scanner.py
│   ├── ebs_encryption_scanner.py
│   ├── rds_encryption_scanner.py
│   ├── ec2_metadata_scanner.py
│   └── cloudtrail_scanner.py
├── terraform/
│   ├── insecure/
│   │   └── [7 misconfigs]/main.tf
│   └── secure/
│       └── [7 remediations]/main.tf
├── README.md
└── requirements.txt
```

## 🚀 Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/cloud-misconfig-scanner.git

2.  Install dependencies:
    ```bash
    pip install -r requirements.txt

3.  Configure AWS credentials:
    ```bash
    aws configure

4. Run scanners:
   ```bash
   python scanner/public_s3_scanner.py

📘 Deliverables

    ✅ Python-based scanner system for AWS misconfigs

    ✅ Terraform setup for insecure & secure resources

    ✅ Alerting integration (Slack-compatible)

    ✅ Detailed README explaining everything

    ✅ Optional: Ready for CI/CD & dashboard enhancement

🧠 Skills Demonstrated

    AWS security best practices

    Infrastructure as Code (IaC)

    Python + Boto3 scripting

    DevSecOps mindset

    Misconfiguration analysis & remediation

🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

import requests
import json

SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/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"  # Replace with your actual webhook

def send_slack_alert(message):
    payload = {
        "text": message
    }
    headers = {
        "Content-Type": "application/json"
    }
    response = requests.post(SLACK_WEBHOOK_URL, headers=headers, data=json.dumps(payload))
    if response.status_code != 200:
        print("❌ Failed to send Slack alert:", response.text)

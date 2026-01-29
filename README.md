# PacerPro Platform Engineer Coding Test

## Assumptions
- Application logs contain the API endpoint and response time. 
- Response time is measured in milliseconds.
- For this exercise, Sumo Logic alerts are tested using simulated events rather than live production logs.
- Logs are ingested into Sumo Logic in near real time as the application generates them.
- The query continuously evaluates a rolling 10-minute window using timeslice 10m.
- If more than 5 log events for the /api/data endpoint have a response_time_ms greater than 3000 ms within that window, the alert triggers immediately.
- So the alert fires based on real log injection and real-time evaluation, not on a scheduled batch or cron execution.

## Architecture Overview
- The solution implements a simple monitoring and auto-remediation workflow.
- Sumo Logic monitors application logs and triggers alerts for slow API responses.
- Alerts invoke an AWS Lambda function, which performs remediation actions.
- All infrastructure is provisioned using Terraform.

## Alert → Lambda → EC2 Flow
1. Sumo Logic detects `/api/data` responses taking more than 3 seconds.
2. An alert triggers when more than 5 such events occur within 10 minutes.
3. The alert invokes an AWS Lambda function.
4. Lambda reboots the EC2 instance to remediate the issue.
5. Lambda sends an SNS notification and logs the action.

## Terraform Deployment
1. Navigate to the terraform directory.
2. Run `terraform init`.
3. Run `terraform apply`.
4. Terraform provisions the EC2 instance, Lambda function, SNS topic, and IAM role.

## Why Reboot Instead of Replace
Rebooting the EC2 instance is a fast and simple remediation for transient performance issues.
This approach demonstrates automated recovery without introducing additional infrastructure complexity.

## Security Considerations
- Lambda uses an IAM role with permissions limited to EC2 reboot, SNS publish, and CloudWatch logging.
- Sensitive values such as instance IDs and SNS topic ARNs are passed via environment variables.

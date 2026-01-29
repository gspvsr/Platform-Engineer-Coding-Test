import json
import boto3
import os
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2 = boto3.client("ec2")
sns = boto3.client("sns")

INSTANCE_ID = os.environ["INSTANCE_ID"]
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]

def lambda_handler(event, context):
    logger.info("Received alert from Sumo Logic")
    logger.info(json.dumps(event))

    try:
        ec2.reboot_instances(InstanceIds=[INSTANCE_ID])
        logger.info(f"EC2 instance {INSTANCE_ID} rebooted")

        message = f"EC2 instance {INSTANCE_ID} was restarted due to performance degradation."
        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject="EC2 Auto-Restart Triggered",
            Message=message
        )

        return {
            "statusCode": 200,
            "body": json.dumps("Instance restarted and notification sent")
        }

    except Exception as e:
        logger.error(str(e))
        raise

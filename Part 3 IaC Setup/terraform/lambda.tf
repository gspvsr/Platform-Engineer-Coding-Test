resource "aws_lambda_function" "restart_ec2" {
  function_name = "pacerpro-restart-ec2"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  timeout       = 120

  filename = "../lambda_function/lambda.zip"

  environment {
    variables = {
      INSTANCE_ID  = aws_instance.web.id
      SNS_TOPIC_ARN = aws_sns_topic.alerts.arn
    }
  }
}

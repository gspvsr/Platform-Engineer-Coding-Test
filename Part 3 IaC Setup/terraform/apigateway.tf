resource "aws_apigatewayv2_api" "sumo_api" {
  name          = "sumo-alert-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.sumo_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.restart_ec2.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "sumo_route" {
  api_id    = aws_apigatewayv2_api.sumo_api.id
  route_key = "POST /sumo-alert"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.sumo_api.id
  name        = "$default"
  auto_deploy = true
}


resource "aws_lambda_permission" "apigw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.restart_ec2.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.sumo_api.execution_arn}/*/*"
}
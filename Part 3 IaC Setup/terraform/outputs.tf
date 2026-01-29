output "sumo_webhook_url" {
  value = "${aws_apigatewayv2_api.sumo_api.api_endpoint}/sumo-alert"
}

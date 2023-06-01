output "broker_username" {
  value = random_password.random_password.id
}

output "broker_ip_address" {
  value = aws_mq_broker.default.instances.0.ip_address
}
output "broker_endpoints" {
  value = aws_mq_broker.default.instances.0.endpoints
}

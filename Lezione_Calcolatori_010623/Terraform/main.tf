locals {
  name_prefix = var.application_name
}

##########################################
# Security group
##########################################

resource "aws_security_group" "broker" {
  name        = local.name_prefix
  description = "Allow broker connection"
  vpc_id      = var.vpc_id


  ingress {
    description = "Console"
    from_port   = 8162
    to_port     = 8162
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "AMPQ"
    from_port   = 5671
    to_port     = 5671
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "MQTT"
    from_port   = 8883
    to_port     = 8883
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = local.name_prefix
  }
}

resource "random_password" "random_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_string" "random_string" {
  length  = 20
  special = false
}


##########################################
# Broker
##########################################

resource "aws_mq_broker" "default" {
  broker_name = local.name_prefix

  configuration {
    id       = aws_mq_configuration.default.id
    revision = aws_mq_configuration.default.latest_revision
  }

  engine_type        = "ActiveMQ"
  engine_version     = "5.15.9"
  host_instance_type = "mq.t2.micro"
  security_groups    = [aws_security_group.broker.id]

  publicly_accessible = true
  user {
    username = random_password.random_password.id
    password = random_string.random_string.id
  }
}

resource "aws_mq_configuration" "default" {
  description    = "Configuration for broker"
  name           = local.name_prefix
  engine_type    = "ActiveMQ"
  engine_version = "5.15.0"

  data = <<DATA
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<broker xmlns="http://activemq.apache.org/schema/core">
  <plugins>
    <forcePersistencyModeBrokerPlugin persistenceFlag="true"/>
    <statisticsBrokerPlugin/>
    <timeStampingBrokerPlugin ttlCeiling="86400000" zeroExpirationOverride="86400000"/>
  </plugins>
</broker>
DATA
}
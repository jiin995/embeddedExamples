terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Application = var.application_name
      Scope       = "lezioneTano010623"
    }
  }
}
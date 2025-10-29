terraform {
  required_version = ">= 1.11.0"

  backend "s3" {
    bucket = "fase4-terraform-states"
    key    = "fase4-infra-microservices/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.14.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }

  }
}
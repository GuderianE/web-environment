variable "vpc_tag" {
  type    = string
  default = "my_vpc"
}

variable "ami" {
    type = string
    default = "ami-05cd35b907b4ffe77"
}

variable "ec2_instance_type" {
  type = map
  default = {
    development = "t2.small"
    qa          = "t2.medium"
    staging     = "t2.xlarge"
    production  = "t2.xlarge"
  }
}

variable "cidr_ab" {
  type = map
  default = {
    development = "172.22"
    qa          = "172.24"
    staging     = "172.26"
    production  = "172.28"
  }
}

variable "region" {
  type = map(string)
  default = {
    "development" = "us-west-2"
    "qa"          = "us-east-2"
    "staging"     = "us-east-1"
    "production"  = "ca-central-1"
  }
}

variable "environment" {
  type        = string
  description = "Options: development, qa, staging, production"
}

locals {
  cidr_c_private_subnets  = 1
  cidr_c_database_subnets = 11
  cidr_c_public_subnets   = 64
}

locals {
  private_subnets = [
    for az in local.availability_zones :
    "${lookup(var.cidr_ab, var.environment)}.${local.cidr_c_private_subnets + index(local.availability_zones, az)}.0/24"
  ]
  database_subnets = [
    for az in local.availability_zones :
    "${lookup(var.cidr_ab, var.environment)}.${local.cidr_c_database_subnets + index(local.availability_zones, az)}.0/24"
  ]
  public_subnets = [
    for az in local.availability_zones :
    "${lookup(var.cidr_ab, var.environment)}.${local.cidr_c_public_subnets + index(local.availability_zones, az)}.0/24"
  ]
}

locals {
  availability_zones = data.aws_availability_zones.available.names
}

data "aws_availability_zones" "available" {
  state = "available"
}


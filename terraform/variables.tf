variable "aws_region" {
    type = string
    description = "The AWS region to deploy resources in"
    default = "us-east-1"
  
}
# variable "environment" {
#     type = string
#     description = "The environment to deploy resources in (e.g., dev, staging, prod)"
#     validation {
#       condition = contains(["dev", "staging", "prod"], var.environment)
#       error_message = "Environment must be dev, staging, or prod."
#     }
  
# }

variable "vpc_cidr" {
    type = string
    description = "The CIDR block for the VPC"
    default = "10.0.0.0/16"
  
}
variable "availability_zones" {
    type = string
    description = "List of availability zones to use for subnets"
    default = "us-east-1a"
  
}

variable "public_subnet_cidrs" {
    type = list(string)
    description = "List of CIDR blocks for public subnets"
    default = ["10.0.1.0/24", "10.0.2.0/24","10.0.3.0/24"]
  
}

variable "jenkins_instance_type" {
    type = string
    description = "The instance type for the Jenkins server"
    default = "t2.micro"
  
}
variable "jenkins_ami" {
    type = string
    description = "The AMI ID for the Jenkins server"
    default = "ami-0b6c6ebed2801a5cb"
  
}

variable "jenkins_volume_size" {
    type = number
    description = "The size of the EBS volume for the Jenkins server (in GB)"
    default = 50
  
}

variable "allowed_ssh_cidrs" {
    type = list(string)
    description = "List of CIDR blocks allowed to access Jenkins via SSH"
    default = ["0.0.0.0/0"]
  
}
variable "allowed_http_cidrs" {
    type = list(string)
    description = "List of CIDR blocks allowed to access Jenkins via HTTP"
    default = ["0.0.0.0/0"]
  
}
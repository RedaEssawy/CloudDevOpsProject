# ami variable for the public EC2 instance
variable "jenkins_ami" {
    type = string
    description = "The AMI ID for the Jenkins server"
    default = "ami-0b6c6ebed2801a5cb"
  
}
# Instance type variable for the Jenkins server
variable "jenkins_instance_type" {
    type = string
    description = "The instance type for the Jenkins server"
    default = "t2.micro"
  
}
# Key name variable for SSH access to the Jenkins server
variable "key_name" {
    type = string
    description = "SSH key pair name"
  
}
# Volume size variable for the Jenkins server
variable "jenkins_volume_size" {
    type = number
    description = "The size of the EBS volume for the Jenkins server (in GB)"
    default = 50
  
}
# Environment variable to differentiate between dev, staging, and prod
# variable "environment" {
#   description = "Environment name"
#   type        = string
#   validation {
#     condition     = contains(["dev", "staging", "prod"], var.environment)
#     error_message = "Environment must be dev, staging, or prod."
#   }
# }
# tags variable for the public EC2 instance
variable "public_instance_ec2_tags" {
  description = "Tags for the EC2 instance"
  type        = string
  default     = "Jenkins"
  
}
# subnet ID variable for the public EC2 instance
variable "public_subnet_id" {
  description = "Subnet ID for the public EC2 instance"
  type        = string
  default     = "subnet-0bb1c79de3EXAMPLE"
  
}
variable "jenkins_sg_id" {
  description = "Security group ID for the Jenkins server"
  type        = string

  
}
variable "vpc_varaibles" {
    description = "VPC related variables"
    type        = map(string)
    default     = {
        vpc_name = "ivolve_project_vpc"
        cidr     = "192.168.0.0/16"
        public_subnet_cidr = "192.168.0.0/24"
      

    }
  
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDRs allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Change in production
}

variable "allowed_http_cidrs" {
  description = "List of CIDRs allowed for HTTP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

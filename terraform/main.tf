module "networking" {
    source = "./modules/networking"

    vpc_cidr = var.vpc_cidr
    availability_zones = var.availability_zones
    public_subnet_cidrs = var.public_subnet_cidrs
    allowed_ssh_cidrs = var.allowed_ssh_cidrs
    allowed_http_cidrs = var.allowed_http_cidrs
}
module "servers" {
    source = "./modules/servers"
    # environment = var.environment
    jenkins_ami = var.jenkins_ami
    key_name = aws_key_pair.ansible_key.key_name
    jenkins_instance_type = var.jenkins_instance_type
    jenkins_volume_size = var.jenkins_volume_size
    
    public_subnet_id = module.networking.public_subnet_ids[0]  # Use the first public subnet
    jenkins_sg_id = module.networking.jenkins_sg_id

    
}

# module "ec2_web" {
#     source = "./modules/ec2"
#     public_subnet_id = module.vpc.public_subnet_id
#     private_subnet_id = module.vpc.private_subnet_id
    
  
# }
# module "s3_bucket" {
#     source = "./modules/s3"
  
# }
# module "vpc" {
#     source = "./modules/vpc"
  
# 
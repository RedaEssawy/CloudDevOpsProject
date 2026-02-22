output "vpc_id" {
    value = aws_vpc.main.id
    description = "The ID of the VPC"
  
}
output "public_subnet_ids" {
    value = aws_subnet.public[*].id
    description = "The IDs of the public subnets"
  
}
output "jenkins_sg_id" {
    value = aws_security_group.jenkins.id
    description = "The ID of the security group for the Jenkins server"
  
}
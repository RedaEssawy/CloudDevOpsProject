output "jenkins_instance_id" {
    value = aws_instance.jenkins_server.id
    description = "The ID of the Jenkins EC2 instance"
  
}
output "jenkins_public_id" {
    value = aws_eip.jenkins_eip.public_ip
    description = "The public IP address of the Jenkins EC2 instance"
  
}
output "jenkins_public_dns" {
    value = aws_eip.jenkins_eip.public_dns
    description = "The public DNS name of the Jenkins EC2 instance"
  
}
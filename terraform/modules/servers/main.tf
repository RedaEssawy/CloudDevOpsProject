# Create a public EC2 instance
resource "aws_instance" "jenkins_server" {
  ami = var.jenkins_ami
  instance_type = var.jenkins_instance_type
  key_name = var.key_name
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = [ var.jenkins_sg_id ]
  # key_name = var.key_name
    # root_block_device {
    # volume_type = "gp3"
    # volume_size = var.jenkins_volume_size
    # encrypted = true
    # tags = {
    #   Name = "${var.environment}-jenkins-root"
    # }
    # }
  # user_data = <<-EOF
  #           !/bin/bash
  #           yum update -y
  #           yum install -y docker git java-11-amazon-corretto-devel
  #           systemctl enable docker
  #           systemctl start docker
  #           usermod -aG docker ec2-user

  #           # Install Jenkins
  #           wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  #           rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
  #           yum install -y jenkins
  #           systemctl enable jenkins
  #           systemctl start jenkins
  #         EOF



  tags = {
    
    Name = var.public_instance_ec2_tags
  }
  
}   
resource "aws_cloudwatch_metric_alarm" "jenkins_cpu" {
  alarm_name          = "-jenkins-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This alarm monitors high CPU utilization for the Jenkins server."
  alarm_actions = [ ]

  dimensions = {
    InstanceId = aws_instance.jenkins_server.id
  }
  tags = {
    Name = "jenkins-cpu-alarm"
  }
}
resource "aws_cloudwatch_metric_alarm" "jenkins_memory" {
  alarm_name          = "jenkins-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This alarm monitors high memory utilization for the Jenkins server."
  alarm_actions = [ ]

  dimensions = {
    InstanceId = aws_instance.jenkins_server.id
  }
  tags = {
    Name = "jenkins-memory-alarm"
  }
  
}
resource "aws_eip" "jenkins_eip" {
  instance = aws_instance.jenkins_server.id
  domain = "vpc"
  tags = {
    Name = "jenkins-eip"
  }
}
resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Name = "jenkins-role"
  }

}
resource "aws_iam_role_policy_attachment" "jenkins_ecr" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  
}
resource "aws_iam_role_policy_attachment" "jenkins_s3" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnly"
  

}
resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-profile"
  role = aws_iam_role.jenkins_role.name
  tags = {
    Name = "jenkins-profile"
  }
  
}
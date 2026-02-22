

# terraform/modules/networking/main.tf
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ivolve-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ivolve-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Network ACL
resource "aws_network_acl" "main" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.public[*].id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8080
    to_port    = 8080
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "ivolve-nacl"
  }
}

# Security Groups for Jenkins
resource "aws_security_group" "jenkins" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins instance"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "jenkins-sg"
  }
}

resource "aws_security_group_rule" "jenkins_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ssh_cidrs
  security_group_id = aws_security_group.jenkins.id
  description       = "SSH access"
}

resource "aws_security_group_rule" "jenkins_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = var.allowed_http_cidrs
  security_group_id = aws_security_group.jenkins.id
  description       = "Jenkins web interface"
}

resource "aws_security_group_rule" "jenkins_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins.id
  description       = "Allow all outbound traffic"
}


# # this resource block will create a VPC 
# resource "aws_vpc" "ivolve_project_vpc" {
#     cidr_block = var.vpc_cidr  
#     region = var.vpc_varaibles["region"]
#     enable_dns_hostnames = true
#     enable_dns_support = true
#     tags = {
#         Name = "${var.environment}-vpc"
#     }
  
# }
# # this resource block will create a public subnet
# resource "aws_subnet" "public_subnet" {
#     count = length(var.vpc_varaibles["public_subnet_cidr"])
#     vpc_id            = aws_vpc.ivolve_project_vpc.id
#     cidr_block        = var.public_subnet_cidrs[count.index]
#     region = var.vpc_varaibles["region"]
#     availability_zone = element(var.availability_zones, count.index)
#     map_public_ip_on_launch = true
#     tags = {
#         Name = "${var.vpc_varaibles["vpc_name"]}_public_subnet"
#     }
  
# }
# # this resource block will create a route table for public subnet
# resource "aws_route_table" "public_rt" {
#     vpc_id = aws_vpc.ivolve_project_vpc.id
#     region = var.vpc_varaibles["region"]
#     tags = {
#         Name = "${var.vpc_varaibles["vpc_name"]}_public_rt"
#     }
  
# }
# # this resource block will create a route to internet gateway for public subnet
# resource "aws_route" "public_rt_route" {
#     route_table_id         = aws_route_table.public_rt.id
#     destination_cidr_block = "0.0.0.0/0"
#     gateway_id             = aws_internet_gateway.ivolve_project_igw.id
#     region = var.vpc_varaibles["region"]
  
# }
# # this resource block will associate the public subnet with the public route table
# resource "aws_route_table_association" "public_subnet_association" {
#     subnet_id      = aws_subnet.public_subnet[0].id
#     route_table_id = aws_route_table.public_rt.id
#     region = var.vpc_varaibles["region"]
  
# }

# # this resource block will create an internet gateway
# resource "aws_internet_gateway" "ivolve_project_igw" {
#     vpc_id = aws_vpc.ivolve_project_vpc.id
#     region = var.vpc_varaibles["region"]
#     tags = {
#         Name = "${var.vpc_varaibles["vpc_name"]}_igw"
#     }
  
# }
# # this resource block will create an elastic IP for NAT gateway
# resource "aws_eip" "nat_eip" {
    
#     region = var.vpc_varaibles["region"]

  

# }


# resource "aws_network_acl" "ivolve_project_acl" {
#     vpc_id = aws_vpc.ivolve_project_vpc.id
#     subnet_ids = aws_subnet.public_subnet[*].id
# #  ingress {
# #         protocol   = "tcp"
# #         rule_no    = 100
# #         action     = "allow"
# #         cidr_block = "0.0.0.0/0"
# #         from_port  = 80
# #         to_port    = 80
# #     }

#   ingress = {
#     protocol   = "tcp"
#     rule_no    = 110
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 443
#     to_port    = 443
#   }
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 120
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 22
#     to_port    = 22
#   }
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 130
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 8080
#     to_port    = 8080
#          }
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 140
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 1024
#     to_port    = 65535
#          }
#   egress {
#         protocol   = "-1"
#         rule_no    = 100
#         action     = "allow"
#         cidr_block = "0.0.0.0/0"
#         from_port  = 0
#         to_port    = 0
#     }
#      tags = {
#         Name = "${var.vpc_varaibles["vpc_name"]}_acl"
#     }

# }

# resource "aws_security_group" "jenkins_sg" {
#     name        = "${var.vpc_varaibles["vpc_name"]}_sg"
#     description = "Security group for ${var.vpc_varaibles["vpc_name"]}"
#     vpc_id      = aws_vpc.ivolve_project_vpc.id
#     region = var.vpc_varaibles["region"]
#     tags = {
#       Name = "${var.environment}-jenkins-sg"

#     }
  
# }
# resource "aws_security_group_rule" "jenkins-ssh" {
#     security_group_id = aws_security_group.jenkins_sg.id
#     type              = "ingress"
#     from_port         = 22
#     to_port           = 22
#     protocol          = "tcp"
#     cidr_blocks       = var.allowed_ssh_cidrs
  
# }

# resource "aws_security_group_rule" "jenkins_http" {
#     security_group_id = aws_security_group.jenkins_sg.id
#     type              = "ingress"
#     from_port         = 8080
#     to_port           = 8080
#     protocol          = "tcp"
#     cidr_blocks       = var.allowed_http_cidrs
#     description = "Jenkins web interface"
  
# }
# resource "aws_security_group_rule" "jenkins_egress" {
#     security_group_id = aws_security_group.jenkins_sg.id
#     type              = "egress"
#     from_port         = 0
#     to_port           = 0
#     protocol          = "-1"
#     cidr_blocks       = ["0.0.0.0"]
#     description = "Allow all autbound traffic"
  
# }
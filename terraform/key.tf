resource "tls_private_key" "ansible_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
  
}

resource "aws_key_pair" "ansible_key" {
    key_name   = "ansible-key"
    public_key = tls_private_key.ansible_key.public_key_openssh
}

resource "local_file" "private_key" {
    content         = tls_private_key.ansible_key.private_key_pem
    filename        = "/home/reda/.ssh/ansible-key.pem"
    file_permission = "0400"
  
}
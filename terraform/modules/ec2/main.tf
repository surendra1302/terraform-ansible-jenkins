resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  associate_public_ip_address = true
  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y apache2
    echo "Instance Configured" > /var/www/html/index.html
  EOF

  tags = {
    Name = var.instance_name
  }
}


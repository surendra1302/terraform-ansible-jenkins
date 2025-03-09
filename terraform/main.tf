provider "aws" {
  region = var.aws_region
}

module "ec2" {
  source         = "./modules/ec2"
  ami_id         = "ami-04b4f1a9cf54c11d0"  # Replace with a valid AMI ID
  instance_type  = "t2.micro"
  subnet_id      = "subnet-0a0e93d2651dc6f21"  # Replace with a valid Subnet ID
  key_name       = "my-aws-key"
  instance_name  = "jenkins-provisioned-ec2"
}


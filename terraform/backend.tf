terraform {
  backend "s3" {
    bucket         = "terraform-jenkins-ansible"
    key            = "terraform/ec2-instance.tfstate"
    region         = "us-east-1"
    //dynamodb_table = "terraform-lock"
  }
}


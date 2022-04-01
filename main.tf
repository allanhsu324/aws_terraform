terraform {
  required_version = ">= 0.15"

  backend "s3" {
    bucket         = "tf-remote-state20220401103228984300000002"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "a94ee300-4f01-4001-97dd-c9fa14c9c41e"
    dynamodb_table = "tf-remote-state-lock"
    access_key = "AKIAQEQ4MAG3EDWBTYN5"
    secret_key = "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"
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_KEY
}

provider "aws" {
  alias  = "replica"
  region = "us-west-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_KEY
}

# IAM User admin setup
data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user" "iamadmin" {
  name = "iamadmin"
  path = "/system/"

  tags = {
    Name = "admin"
  }
}

resource "aws_iam_access_key" "iamadmin_access_key" {
  user = aws_iam_user.iamadmin.name
}

resource "aws_iam_user_policy_attachment" "aws_admin_policy_attach" {
  user       = "${aws_iam_user.iamadmin.name}"
  policy_arn = "${data.aws_iam_policy.AdministratorAccess.arn}"
}

# modules
module "terraform_remote_state" {
  source = "./modules/terraform_remote_state"

  providers = {
    aws         = aws
    aws.replica = aws.replica
  }
}

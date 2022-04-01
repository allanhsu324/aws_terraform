output "user_arn" {
    value = "${aws_iam_user.iamadmin.arn}"
}

output "terraform_remote_state" {
    value = module.terraform_remote_state
}
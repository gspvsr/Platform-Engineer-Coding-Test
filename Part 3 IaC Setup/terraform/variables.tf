variable "aws_region" {
    default = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI"
  default = "ami-0b6c6ebed2801a5cb"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS AMI ID (hvm-ssd, amd64)"
  type        = string
  # Replace with your actual AMI from https://cloud-images.ubuntu.com/locator/
  default     = "ami-0c398cb65a93047f2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

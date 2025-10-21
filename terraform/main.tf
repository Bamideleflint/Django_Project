
provider "aws" {
  region  = var.aws_region
  profile = "terraform-deployer"  # ← use your new IAM user
}

# Security group: only allow port 8000 from anywhere (for Django)
resource "aws_security_group" "django_sg" {
  name        = "django-app-sg"
  description = "Allow inbound traffic on port 8000 for Django"

  ingress {
    description = "Django app"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "django-app-sg"
  }
}

# EC2 instance (no SSH key!)
resource "aws_instance" "django_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.django_sg.id]

  # User data: install Docker + Docker Compose on first boot
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io docker-compose
              usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "django-ci-cd-server"
  }

  # Wait for instance to be ready
  # provisioner "remote-exec" {
  #   inline = [
  #     "cloud-init status --wait"
  #   ]
  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     host        = self.public_ip
  #     timeout     = "10m"
  #     # No private key — this will fail, but that's OK!
  #     # We only use this to wait for cloud-init to finish.
  #   }
  # }

  # Suppress SSH key warning
  lifecycle {
    ignore_changes = [key_name]
  }
}

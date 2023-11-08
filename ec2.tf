locals {
  tagss = {
    "owner"   = "binay"
    "Name"    = "label_loadtest_tf"
    "project" = "major"
  }
}



# resource "aws_instance" "public_instance" {
#   ami           = "ami-0fc5d935ebf8bc3bc"  # Specify the appropriate AMI
#   instance_type = "t2.micro"
#   subnet_id = module.vpc.public_subnets[0]
#   key_name      = "binay"  # Replace with your key pair
#   associate_public_ip_address = true
#   security_groups = [aws_security_group.my_security_group.id]
#   root_block_device {
#     volume_type           = "gp2"
#     volume_size           = 8
#     delete_on_termination = true
#   }
#   volume_tags = local.tagss
#   tags = {
#     "owner"   = "binay"
#     "Name"    = "chatadex-ecs-ec2"
#     "project" = "major"
#   }

# }


# resource "aws_security_group" "my_security_group" {
#   name        = "my-security-group"
#   description = "Allow SSH and HTTP traffic"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#     ingress {
#     from_port   = 2049
#     to_port     = 2049
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#     ingress {
#     from_port   = 111
#     to_port     = 111
#     protocol    = "udp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   # Allow all outbound traffic.
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }




resource "aws_instance" "ec2_instance" {
  ami                         = "ami-0fc5d935ebf8bc3bc" # Specify the appropriate AMI
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[0] # Replace with the correct subnet
  key_name                    = "binay"                      # Replace with your key pair name
  associate_public_ip_address = true
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
  volume_tags = local.tagss

  tags = {
    "Name"    = "chatadex-ecs-ec2"
    "owner"   = "binay"
    "project" = "major"
  }

  # IAM instance profile for EC2 to access EFS
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  # Attach the security group for SSH and NFS access
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
}

resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Allow SSH and NFS traffic"
  vpc_id      = module.vpc.vpc_id

  # Ingress rules for SSH and NFS
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile-for-efs"
  # Attach a policy that allows access to EFS
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-role-for-efs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  # Attach an EFS policy (Replace with a more restrictive policy if needed)
  inline_policy {
    name = "efs-access-policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action   = "elasticfilesystem:ClientMount",
          Effect   = "Allow",
          Resource = "*"
        }
      ]
    })
  }
}






# Create a private EC2 instance
resource "aws_instance" "private_instance" {
  ami           = "ami-0c2b8ca1dad447f8a"  # Specify the appropriate NAT instance AMI
  instance_type = "t2.micro"
  subnet_id     = module.vpc.private_subnets[0] 
  key_name      = "binay"  # Replace with your key pair
  associate_public_ip_address = false
  security_groups = [aws_security_group.my_security_group.id]
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
  volume_tags = local.tagss
  tags = {
    "owner"   = "binay"
    "Name"    = "hamropatro_private"
    "project" = "major"
  }
}

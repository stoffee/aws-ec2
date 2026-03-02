resource "random_pet" "server" {
}

provider "aws" {
  region = "us-west-1"
}

# HC-approved base AMI with EDR (HC-COMPUTE-011)
module "base_ami" {
  source = "git::ssh://git@github.com/stoffee/terraform-aws-hc-base-ami.git"

  os_flavor    = "rhel-9"
  architecture = "x86_64"
}

resource "aws_instance" "demo" {
  ami = module.base_ami.ami_id

  #instance_type = "t2.micro"
  instance_type = "t2.small"


  tags = {
    Name = random_pet.server.id
    Owner = "cd"
    TTL   = "24"
  }
provisioner "local-exec" {
    command = "echo hello >> hello.txt"
  }
}

output "private_ip" {
  description = "Private IP of instance"
  value       = join("", aws_instance.demo.*.private_ip)
}

output "public_ip" {
  description = "Public IP of instance (or EIP)"
  value       = join("", aws_instance.demo.*.public_ip)
}

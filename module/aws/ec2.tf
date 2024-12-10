
// module/aws/ec2.tf
resource "aws_instance" "control_host" {
  ami = data.aws_ami.ubuntu.id

  instance_type = var.instance_type

  subnet_id = var.public_subnet_id[0].id

  vpc_security_group_ids = [var.sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  availability_zone = var.availability_zones
  key_name          = var.key_name
  tags = {
    Name = "${var.cluster-name}-eks-control-plane"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = var.private_key
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt upgrade -y",
      "sudo apt-get install curl wget unzip zip -y",
      "curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      "sudo apt-get update -y",
      "sudo apt-get install jq -y",
      "curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.0/2024-09-12/bin/linux/amd64/kubectl",
      "chmod +x ./kubectl",
      "mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin",
      "echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc",
      "kubectl version --client",
      "curl --silent --location https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz | tar xz -C /tmp",
      "sudo mv /tmp/eksctl /usr/local/bin",
      "aws eks  update-kubeconfig --region ${var.region} --name ${var.cluster-name}",
      "curl -o aws-auth-cm.yaml https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-02-11/aws-auth-cm.yaml",
      "curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator",
      "chmod +x ./aws-iam-authenticator",
      "sudo mv ./aws-iam-authenticator /usr/local/bin/",
      "export AWS_ACCESS_KEY_ID=${var.access_keys}",
      "export AWS_SECRET_ACCESS_KEY=${var.secret_key}",
      "aws eks  update-kubeconfig --region ${var.region} --name ${var.cluster-name}",
    ]
  }
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes = [
      tags,
      iam_instance_profile
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A JENKINS MASTER INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "enkins-master" {
  provider = aws.region-master
  ami = var.instance-ami
  instance_type = var.instance-type
  key_name = aws_key_pair.master-key.key_name
  vpc_security_group_ids = [aws_security_group.Jenkins_SG.id]
  subnet_id   = aws_subnet.subnet_1.id

  tags = {
    Name = "jenkins_master_tf"
  }
  
  connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = "${self.public_ip}"
  }	
  
#  provisioner "file" {
#    source      = "~/Terraform_mod_instance/Jenkins_files/"
#    destination = "/tmp/Jenkins-files"
#  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install openjdk-11-jdk -y",
      "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
      "sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt update",
      "sudo apt install jenkins -y", 
	  "sudo usermod -aG jenkins ubuntu",
	  "sudo chmod 775 /var/lib/jenkins",
	  "sudo cp -rf /tmp/Jenkins-files/* /var/lib/jenkins",
	  "sudo rm -rf /tmp/Jenkins-files",
    ]
	
  }
}


resource "aws_instance" "jenkins-worker" {
  provider = aws.region-master
  count = var.workers-count
  ami = var.instance-ami
  instance_type = var.instance-type
  key_name = aws_key_pair.master-key.key_name
  vpc_security_group_ids = [aws_security_group.Jenkins_SG.id]
  subnet_id   = aws_subnet.subnet_1.id

  tags = {
    Name = join("_", ["jenkins_worker_tf", count.intex + 1])
  }
  dpends_on = [aws.instance.jenkins-master]
  
resource "aws_key_pair" "master-key" {
  provider   = aws.region-master
  key_name   = "jenkins-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
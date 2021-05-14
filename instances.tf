# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A JENKINS MASTER INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "Jenkins" {
   provider = aws.region-master
   ami = var.instance-ami
  instance_type = "t2.micro"
  key_name = "jenkins"
  vpc_security_group_ids = [aws_security_group.Jenkins_SG.id]

  tags = {
    Name = "Jenkins-master"
  }
  
  connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("~/Terraform_mod_instance/jenkins.pem")}"
      host        = "${self.public_ip}"
  }	
  
  provisioner "file" {
    source      = "~/Terraform_mod_instance/Jenkins_files/"
    destination = "/tmp/Jenkins-files"
		
  }
  
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
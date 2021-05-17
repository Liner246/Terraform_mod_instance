output "Master_public_ip" {
  value       = aws_instance.jenkins-master.public_ip
  description = "The public IP of the Jenkins Master server"
}

output "Worker_public_ip" {
  value       = { 
    for instance in aws_instance.jenkins-worker :
  instance.id => instance.public_ip
  }
  description = "The public IP of the Jenkins Master server"
}
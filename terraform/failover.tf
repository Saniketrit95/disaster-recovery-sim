provider "aws" {
  alias  = "secondary"
  region = "us-west-1"
}

resource "aws_instance" "secondary" {
  provider      = aws.secondary
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Secondary Server Running" > /var/www/html/index.html
              EOF

  tags = {
    Name = "SecondaryAppServer"
  }
}

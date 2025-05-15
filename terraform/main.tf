provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "primary" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  monitoring     = true  # ✅ Enables detailed monitoring

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Primary Server Running" > /var/www/html/index.html
              EOF

  tags = {
    Name = "PrimaryAppServer"
  }
}




resource "aws_cloudwatch_metric_alarm" "primary_down" {
  alarm_name          = "PrimaryEC2Failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "Alarm when EC2 instance fails status check"
  dimensions = {
    InstanceId = aws_instance.primary.id
  }

  alarm_actions = [aws_sns_topic.ec2_failover.arn]
}





resource "aws_sns_topic" "ec2_failover" {
  name = "ec2-failover-topic"
}

resource "aws_sns_topic_subscription" "jenkins_webhook" {
  topic_arn = aws_sns_topic.ec2_failover.arn
  protocol  = "https"
  endpoint  = "http://<your-jenkins-ip>:8080/job/dr-failover-trigger/build?token=failover123"
}


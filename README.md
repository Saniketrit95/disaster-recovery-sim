# Disaster Recovery Simulation Project

## Project Overview
A simple disaster recovery simulation where a primary EC2 instance is monitored with AWS CloudWatch, and if it fails, the workload is manually shifted to a secondary EC2 instance in another region using a Jenkins pipeline.

## Features
- **Primary EC2 instance** deployed using Terraform
- **CloudWatch alarm** monitors the primary instance health
- **Jenkins pipeline** to manually trigger failover by deploying secondary EC2 instance
- Failover instance launched in a secondary AWS region
- Basic SRE monitoring and failover mechanism

## Project Structure

disaster-recovery-sim/
│
├── terraform/
│ ├── main.tf # Terraform script to create primary EC2 + CloudWatch alarm
│ ├── failover.tf # Terraform script to create secondary EC2 instance for failover
│
├── jenkins/
│ ├── Jenkinsfile # Jenkins pipeline script for managing Terraform deploys
│ ├── jenkinsfile.failover # Optional pipeline for failover job
│ └── monitor.py # Optional monitoring script (if any)
│
└── README.md # Project documentation


## How It Works
1. **Terraform** provisions a primary EC2 instance.
2. **CloudWatch alarm** monitors the primary instance for failure.
3. If the primary instance fails, a Jenkins job is triggered manually.
4. Jenkins applies the failover Terraform script to launch a secondary EC2 instance in a different AWS region.
5. The workload can then be switched to the secondary instance manually or automatically if extended.

## Prerequisites
- Terraform installed on your machine
- Jenkins installed and configured
- AWS CLI installed and configured with appropriate permissions
- Git installed

## Deployment Instructions

### Initial Deployment (Primary Server)
```bash
cd terraform/
terraform init
terraform apply -auto-approve

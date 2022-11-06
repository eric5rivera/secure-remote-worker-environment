# Secure Remote Worker Environment
Inspired by [AWS's Secure Remote Worker Environment Reference Architecture](https://d1.awsstatic.com/architecture-diagrams/ArchitectureDiagrams/secure-remote-worker-environment-ra.pdf?did=wp_card&trk=wp_card); deployed using Infrastructure as Code (IaC).


## Table of Contents
- [Technologies](#technologies)
- [Getting Started](#getting-started)
    - [Pre-requisites](#pre-requisites)
    - [Usage](#usage)
- [Future Work](#future-work)
- [References](#references)


## Technologies
- Terrafrom
- Ansible (in the future)
- more


![Alt text](./secure_remote_worker_environment.png) ("Secure Remote Worker Environment diagram")


Currently, the following resources are provisioned by Ansible:
- AWS Managed Microsoft AD
- AWS WorkSpace
- FSx File Server


# Getting Started

## Pre-requisites

- AWS Account
- Terraform 


These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.


## Usage
- Just clone this repository by typing: git clone `https://github.com/eric5rivera/secure-remote-worker-environment.git`
- Switch to project directory: `secure-remote-worker-environment.git`
- Create a Terraform Cloud Workspace 

```bash
terraform init
```

## Future Work
- Provision resources using Terraform
- Automate configuration with Ansible
- Implement multi-factor authentication (MFA)
- Implement Group policy in Active Directory to prevent unwanted activities
- Implement Group policy in Active Directory to prevent unwanted activities
rules
- Stand up AWS Network Firewall, NAT gateway and internet gateway
- Configure firewall rules to block outbound
traffic to unwanted sites 


## References
https://docs.aws.amazon.com/directoryservice/latest/admin-guide/microsoftadbasestep3.html


https://blog.knoldus.com/how-to-deploy-aws-workspaces-in-aws-using-terraform/

https://medium.com/analytics-vidhya/terraform-diagrams-provisioning-and-visualizing-a-simple-environment-on-aws-471f5d88c95d

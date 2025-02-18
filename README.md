# Project covering AWS Compute/Storage, Terraform, GitHub Actions

In this project, the Terraform scripts and GitHub Actions VI/CD pipelines created are as follows:

1.  Create AWS VPC and its networking components for 3 public subnets, 3 private subnets and 1 internet gateway using Terraform Resources. Ensure that the output is the same as that created via the cloud console.
       - Create AWS VPC and its networking components for 3 public subnets, 3 private subnets and 1 internet gateway using Terraform Module. Ensure that the output is the same as that created via the cloud console.
2.  Create an EC2 using Terraform Resources and place it inside the public subnet of your previously created VPC. Ensure that you install Apache Web Server via User Data/ Bootstrap script.
3.  Create an RDS with MySQL installed with Terraform, and ensure it works. Test whether you are able to connect to the RDS via MySQL Workbench if you’d like to.
4.  Create a Lambda Function that prints a simple “Hello World” in Python using Terraform.
5.  Create a workflow on a new Github Repository or an existing Repository that has 1 job which only prints “Hello World” on a workflow_dispatch and git push trigger.
6.  Create a new Github Repository to create an EC2 from Terraform using Github Actions. EC2 should be created with Apache Web Server installed and deployed onto an existing public subnet and be publicly accessible. Create a yaml file in your .github/workflows to run the steps needed to create the EC2 via terraform plan and terraform apply -auto-approve. Test your workflow and ensure that your workflow allows an EC2 to be created on a workflow_dispatch.
7.  Utilize dev.tfvars, uat.tfvars, and prod.tfvars on the same Terraform codes to allow you to create multiple resources for different environments using Terraform workspaces. Run the code locally without using Github Actions first for noq.


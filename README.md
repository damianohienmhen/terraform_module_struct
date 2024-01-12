## Table of Contents
* [About the repo](#about-the-repo)
* [Quick start](#quick-start)
* [Repository structure](#repository-structure)
* [modules](#modules)
* [environments](#environments)
* [k8s](#k8s)
* [service-accounts](#service-accounts)

## About the repo
This repository contains an example of deploying and managing [Kubernetes](https://kubernetes.io/) clusters to [Google Cloud Platform](https://cloud.google.com/) (GCP) in a reliable and repeatable way.

[Terraform](https://www.terraform.io/) is used to describe the desired state of the infrastructure, thus implementing Infrastructure as Code (IaC) approach.

[Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/) (GKE) service is used for cluster deployment. Since Google announced that [they had eliminated the cluster management fees for GKE](https://cloudplatform.googleblog.com/2017/11/Cutting-Cluster-Management-Fees-on-Google-Kubernetes-Engine.html), it became the safest and cheapest way to run a Kubernetes cluster on GCP, because you only pay for the nodes (compute instances) running in your cluster and Google abstracts away and takes care of the master control plane.  


## Quick start
**Prerequisite:** make sure you're authenticated to GCP via [gcloud](https://cloud.google.com/sdk/gcloud/) command line tool using either _default application credentials_ or _service account_ with proper access.

Check **terraform.tfvars** file inside `environments/prod or environments/dev` folder to see what variables you need to define before you can use terraform to create a cluster.

Once the required variables are defined, use the commands below to create a Kubernetes cluster:
```bash
$ terraform init
$ terraform apply
```

After the cluster is created, run a command from terraform output to configure access to the cluster via `kubectl` command line tool. You can recieve the command input from inside GCP.

## Repository structure
```bash
├── .terraform
├── environments
│   └── prod
│   └── dev
├── global  
├── k8s         
└── modules
    ├── service-account
    ├── network
README.md
```

### modules
The folder contains reusable pieces of terraform code which help us manage our configuration more efficiently by avoiding code repetition and reducing the volume of configuration.

The folder contains 4 modules at the moment of writing:

* `service-account` module allows to create new service accounts.
* `network` module allows to create your kubernetes cluster which includes the NAT,router, subnets, VPC and Firewall rules.

### environments
Inside the **environments** folder, I put terraform configuration for the creation and management of an example of Kubernetes cluster.
Important files here:

* `terraform.tfvars.example` contains example terraform input variables which you need to define before you can start creating a cluster.
* `outputs.tf` contains output variables
* `variables.tf` contains input variables
  
### k8s
* `k8s` folder contains yaml files of all the resources to be deployed into terraform e.g
* `1.3-example` has an bunch of Kubernetes objects definitions which are used to deploy nginx to a Kubernetes cluster. You can use the command below to deploy nginx to the cluster once it is created:
	```bash
	$ kubectl apply -f k8s/1.3-example.yaml
	```

### service-accounts
This is another top level folder in this project. It defines servicea accounts which will be created and used by the Kubernetes clusters.
<img width="1085" alt="image" src="https://github.com/damianohienmhen/terraform_module_struct/assets/73041606/bf86ab21-ecb6-439b-bffc-0d0817aca5a9">

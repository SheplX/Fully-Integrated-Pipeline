# Fully-Integrated-Pipeline-Project
Introducing a pipeline project integrating with several popular DevOps tools. I tried to make everything as automated, secure, reliable, and logical as possible.
a complete cycle that can simulate a real environment on companies, a process that can produce good & secure software quality with good sights for each resource inside the infrastructure.

![Image](https://github.com/SheplX/test/blob/main/diagrams/fully%20integrated%20project/final%20project.drawio.png)

# Getting started

- During the project, I used several tools that can handle each part and I would like to provide each tool with a little explanation :
    - `Terraform` - for deploying the required infrastructure on Google Cloud Provider (GCP)
    - `Docker` - for building the application image.
    - `Kubernetes` - for deploying the application & database manifests, and helm charts.
    - `Ansible` - for automating some tasks inside the cluster like creating the namespaces, deploying the helm charts on each namespace and configuring the Hashicorp Vault cluster.
    - `Helm` - for deploying several required helm charts.
    - `Prometheus` - as a data source for Grafana. to scrape the metrics from several configured targets.
    - `Grafana` - for visualization, watch each target metric.
    - `SonarQube` - for automatic code reviews, delivers a clean & safe code.
    - `Nexus` - to store the images privately inside the Cluster.
    - `Hashicorp Vault` - as a free & great solution for storing secrets.
    - `External-Secrets` - configured with Hashicorp Vault for managing the secrets inside each namespace.
    - `Jenkins` - as a CI/CD automation tool.
    - `Slack` - as a notifications channel configured with Prometheus & Jenkins.
    - `Redis` - as a database server required to be available for the 
   application.
- I will talk about each part of the project with each tool used in it.


# Building the infrastructure with Terraform

- Building a VPC with 2 subnets, each subnet will have different sources.
- The first subnet will be Management (Public) with these resources :
    - An instance that will be used to access the cluster control plane privately.
    - This instance will be configured with a script to have preinstalled tools like ansible, kubectl, gcloud-cli, and helm.
- The second subnet will be restricted (Private) and associated with a router, and nat gateway so the resources can access the internet without external IP. this subnet will have these resources :
    - A private GKE cluster is configured with a private control plane to be accessed only from a CIDR range, this range will be the Management subnet range so the instance only can access the cluster control plane.
- A service account is bound with a role to be able to create the cluster and also for the instance to be able to manage the cluster.
- A firewall with IAP access to be able to SSH into the Management instance privately.
- A google storage bucket for storing tfstate file of terraform and syncing any new changes has been made inside the infrastructure.

# Managing the cluster with Ansible

- After the resources have been deployed by Terraform, it would be necessary to configure the cluster using Ansible, for that I need first to ssh into the management instance to be able to communicate with the cluster.
```
gcloud compute ssh project-340821-management-vm --project project-340821 --zone europe-west1 --tunnel-through-iap
```
- Now i can implement the Ansible playbook.
```
ansible-playbook --ask-become-pass Ansible.yaml
```
- This Ansible playbook will perform several tasks :
    - Connect to the GKE cluster.
    - Create several namespaces, each namespace will contain different deployments/helm charts.
    - Deploy the helm charts of `Jenkins` `Vault` `External-Secrets` `Prometheus` `Grafana` `SonarQube` and the `Nexus` deployments.
    - Deploy the Jenkins roles into its namespace.
    - Initiate the hashicorp Vault cluster.

# Setting up secrets with Hashicorp Vault

- After the deployment of the helm charts had been completed, we must set up the secrets inside the cluster in the first step to make sure that all the required secrets are available. to perform that we need to check if the Hashicorp Vault cluster is up and ready state is 1/1.

![Image](vault.png)

- Now we can access the Vault UI and set up our credentials. in this case, I need to set up 2 different types of secrets:
    - the first one is the application credentials necessary for the application to be able to communicate with the Redis database server so the manifest type of the secret will be `Opaque`.
    - the second one is the container credentials. because we have a private nexus repository and we want the application container being able to authenticate with the repo. we must set up a credentials type `kubernetes.io/dockerconfigjson` with the repo link, user, and password.

![Image](vault_credentials.png)

# Setting up External Secrets Operator with Hashicorp Vault

- External secret operator (ESO) is a Kubernetes Operator which can integrate with an external secrets manager like Vault or AWS secret manager or Google Secrets Manager, I found it a great idea if I made integrate with Vault so its free & great solution for handling the secrets inside the cluster.
    - First, we need to set up a SecretStore with Vault so it can pull any secrets being requested from it. 
    - A secret with the vault token so it can be able to access the vault and pull the secrets from it.
    - There are 2 types of SecretStores :
        - `SecretStore` - it can only handle the secrets inside a specific namespace.
        - `ClusterSecretStore` - it can handle the secrets across all the namespaces inside the cluster.
    - I choose the second type because I would like to handle all the namespaces secrets at once with one SecretStore so it will be a more convenient way.
- After setting up the SecretStore with Vault it must be able to connect with Vault and pull the requested secrets then create each one on the app namespace once we deploy the application.

![Image](external-secrets.png)

# 
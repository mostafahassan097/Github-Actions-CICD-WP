
# WordPress Theme Deployment

This project demonstrates deploying a WordPress theme to a cloud server using GitHub Actions workflows.
## Prerequisites

Before using this workflow, ensure you have the following prerequisites in place:

1. **WordPress Environment**: You should have a WordPress environment set up on your server, including a working installation with the theme you want to deploy.
  A  [wordpress-installation.sh](/helper_scripts/wordpress-installation.sh)  script that configures the cloud server and installs the necessary packages.
2. **SSH Key Pair**: You should have an SSH key pair (public and private) set up. The public key should be added to your server's authorized keys.

3. **GitHub Repository**: Your theme's source code should be hosted in a GitHub repository.

4. **GitHub Secrets**: In your GitHub repository, set up the following secrets:
   - `SSH_PRIVATE_KEY`: The private SSH key used for authenticating with your server.
   - `SERVER`: The SSH server and username (e.g., `root@myhs.mooo.com`).
5. **Domain**  to use for the project. (Optional), I used a free subdomain for this demo
[Freedns Afraid]( https://freedns.afraid.org/). 

## Overview

The goal is to automatically build and deploy a theme to a WordPress site hosted on a cloud server whenever code is pushed to the main branch.

The server has already been configured manually with the required services like Nginx, PHP, MySQL etc. based on the previous setp The [wordpress-installation.sh](/helper_scripts/wordpress-installation.sh) script was used to install and configure WordPress on the server.

The workflow uses GitHub Actions to:

- Install Node.js and PHP dependencies
- Build the theme static assets 
- Deploy the built theme to the  server over SSH

This allows the theme to be continuously built, tested and deployed on every code change.

## Deployment Workflow

The [deploy.yml](.github/workflows/deploy.yml) GitHub Actions workflow handles building and deploying the theme.

On every push to `main`, it will:

1. Checkout code
2. Install Node.js and PHP dependencies
3. Build theme assets 
4. Sync built theme folder to server over SSH

The workflow uses secrets for the SSH private key and domain to securely connect to the server.

## Workflow Explanation

This GitHub Actions workflow, named "Deploy Website Theme," automates the process of building and deploying your website theme to a remote server whenever changes are pushed to the `main` branch.

### Workflow Triggers

The workflow is triggered on `push` events to the `main` branch:

```yaml
on:
  push:
    branches:
      - main
```

### Workflow Environment Variables

The workflow defines environment variables for reuse:

- `SERVER`: Specifies the SSH server and username.
- `REMOTE_DIR`: Specifies the remote directory on the server where the theme will be deployed.

### Workflow Jobs

The workflow consists of two jobs:

#### 1. Build Job (`build`)

This job handles the building of the theme. It performs the following steps:

- Checks out the repository's code.
- Installs Composer dependencies (if any).
- Sets up Node.js LTS, installs Node.js dependencies, and builds the theme based on the branch being pushed (`main` or other branches).

#### 2. Deploy Job (`deploy`)

This job deploys the built theme to the remote server using SSH. It does the following:

- Sets up SSH authentication with the provided private key.
- Uses `rsync` to copy the built theme files to the specified remote directory on the server. It excludes Git-related files and the `helper_scripts` directory.

## How to Use

1. Ensure that your WordPress theme's source code is hosted in a GitHub repository.

2. Create an SSH key pair, and add the public key to the `~/.ssh/authorized_keys` file on your server.

3. In your GitHub repository, navigate to "Settings" -> "Secrets" and add two secrets:
   - `SSH_PRIVATE_KEY`: Paste your private SSH key.
   - `SERVER`: Set the SSH server and username (e.g., `root@myhs.mooo.com`).

4. Copy the provided GitHub Actions workflow YAML and add it to your repository in the `.github/workflows` directory (create this directory if it doesn't exist) with a `.yml` extension.

5. Customize the workflow as needed. Ensure that the paths, script names, and environment variables match your project's structure and requirements.

6. Commit and push your changes to the GitHub repository.

7. GitHub Actions will automatically run the workflow whenever changes are pushed to the `main` branch. You can monitor the workflow's progress and view its output in the Actions tab of your repository.

With this workflow in place, your WordPress theme will be built and deployed to your server whenever you push changes to the `main` branch.
### Screenshots
![Image Description](https://github.com/mostafahassan097/Github-Actions-CICD-WP/blob/main/imgs/1.png)
![Image Description](https://github.com/mostafahassan097/Github-Actions-CICD-WP/blob/main/imgs/2.png)
![Image Description](https://github.com/mostafahassan097/Github-Actions-CICD-WP/blob/main/imgs/3.png)
![Image Description](https://github.com/mostafahassan097/Github-Actions-CICD-WP/blob/main/imgs/4.png)
![Image Description](https://github.com/mostafahassan097/Github-Actions-CICD-WP/blob/main/Imgs/5.png)
### Alternative Deployment Options

While this workflow uses a manually configured server, there are other ways to deploy WordPress:

- Using managed Kubernetes services like EKS to run WordPress in containers
- Hosting on fully managed platform like WordPress.com or Kinsta
- Creating cloud infrastructure as code with Terraform/CloudFormation

For this demo project, manually configuring a small server keeps things simple and cost effective. But those options could be considered for larger scale production deployments.

## Resources

- GitHub Repository: [Github-Actions-CICD-WP](https://github.com/mostafahassan097/Github-Actions-CICD-WP)

- Live Website: [Link](https://myhs.mooo.com)


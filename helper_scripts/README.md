
#  WordPress Installation Script, and DB Backup Script.

## Table of Contents
- [Overview](#overview)
- [Getting Started](#getting-started)
  - [Creating SSH Keys](#creating-ssh-keys-to-access-the-server-and-run-scripts)
  - [WordPress Installation Script](#wordpress-installation-script)
      - [Nginx Configuration Details](#nginx-configurations)
  - [Backup Script](#backup-script)
- [Setting up a Cron Job](#setting-up-a-cron-job)
- [Contributing](#contributing)
- [License](#license)

## Overview

This repository contains two scripts: WordPress installation script, and DB backup script

The WordPress installation script automates the installation and configuration of WordPress on a server running Ubuntu. It installs the required packages, configures PHP for Nginx, sets up Nginx for a domain, creates an SSL certificate using Let's Encrypt, creates a MySQL database and user for WordPress, and downloads and configures WordPress.

The backup  script takes one parameter to run  backup . It also deletes old backups based on the default retention days (7 days ago).

## Getting Started

To use these scripts, follow these steps:

1. Clone the repository: `git clone https://github.com/mostafahassan097/Github-Actions-CICD-WP.git`
2. Change the directory: `cd Github-Actions-CICD-WP/helper_scripts`

## Creating SSH Keys to Access the Server and Run Scripts
To create SSH keys, follow these steps:

1. Open a terminal on your local machine.
2. Run the following command: `ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`
3. Follow the prompts to set a passphrase for your key.
4. Your public key will be saved in `~/.ssh/id_rsa.pub`.
5. `ssh-copy-id user@remote_server`

### WordPress Installation Script

To use the WordPress installation script on a cloud server, follow these steps:

1. Connect to your cloud server using SSH: `ssh username@your-server-ip`
2. Change to the directory where you cloned the repository: `cd Github-Actions-CICD-WP/helper_scripts`
3. Make the script executable: `chmod +x wordpress-installation.sh`
4. Run the script: `./wordpress-installation.sh`

After the script has completed, you can access your WordPress site by visiting `https://your-domain/` in your web browser.

### Nginx Configurations
#### WordPress Server Block
This configuration is for a server block that handles requests for your WordPress site.

#### Basic Settings
- `server_name myhs.mooo.com localhost;`: This sets the domain names that this server block will respond to.
- `access_log /var/log/nginx/wp_access.log;`: This sets the location where the server will write the access log.
- `error_log /var/log/nginx/wp_error.log;`: This sets the location where the server will write the error log.
- `root /var/www/html/wordpress/public_html;`: This sets the root directory of your website.
- `index index.php;`: This sets the default file to serve when a directory is requested.

#### Location Blocks
- Static files: The server is configured to directly serve static files like images, CSS, JavaScript, and HTML. These files have their caching set to 'max' and won't log if they're not found.
- Hidden files: Access to '.ht' files is denied for security reasons.
- Favicon and Robots.txt: These special files have logging turned off.
- PHP scripts: PHP scripts are passed to PHP-FPM for processing. The 'fastcgi-php.conf' snippet is included for additional FastCGI settings.

#### SSL Settings
The server is configured to listen on port 443 for both IPv4 and IPv6 connections. SSL is enabled with certificates provided by Let's Encrypt.

#### Redirect Server Block
This server block listens on port 80 and redirects all traffic to HTTPS. If a request comes in for 'myhs.mooo.com', it will be redirected to 'https://myhs.mooo.com'. Any other requests will receive a 404 error.


### Backup Script

To use the backup  script, follow these steps:

1. Make the script executable: `chmod +x backup.sh`
2. Run the script with the desired parameter: `export DB_HOST="localhyour_host" && export DB_PASSWORD="your_password" && export DB_USER="your_user" && export DB_NAME="youe_db_name" && ./backup.sh backup` .

## Setting up a Cron Job

To set up a cron job to run the backup  script every day at 12 am, follow these steps:

1. Open the crontab file: `crontab -e`
2. Add the following line to the file: `0 0 * * *  /path/to/scripts/backup.sh backup`
3. Save and close the file.

This will set up a cron job that runs the script every day at 12 am and takes a backup.

## Contributing

We welcome contributions to these scripts! Please see our [contribution guidelines](CONTRIBUTING.md) for more information.

## License

These scripts are licensed under the [MIT License](LICENSE).


sudo yum install -y yum-utils

Download Certificate and Key
Follow these steps to download the certificate and private key for NGINX Management Suite. You’ll need these files when adding the official repository for installing NGINX Management Suite. You can also use the certificate and key when installing NGINX Plus.

On the host where you’re installing NGINX Management Suite, create the /etc/ssl/nginx/ directory:

 Copy
sudo mkdir -p /etc/ssl/nginx
Download the NGINX Management Suite .crt and .key files from MyF5 or follow the download link in your trial activation email.

Move and rename the .crt and .key files:

 Copy
sudo mv <nginx-mgmt-suite-trial.crt> /etc/ssl/nginx/nginx-repo.crt
sudo mv <nginx-mgmt-suite-trial.key> /etc/ssl/nginx/nginx-repo.key
Note:
The downloaded filenames may vary depending on your subscription type. Modify the commands above accordingly to match the actual filenames.



 
Installation instructions for RHEL 8.0+ / Oracle Linux 8.0+ / AlmaLinux 8.6+ / Rocky Linux 8.6+
If you already have old NGINX packages in your system, back up your configs and logs:

sudo cp -a /etc/nginx /etc/nginx-plus-backup
sudo cp -a /var/log/nginx /var/log/nginx-plus-backup
Create the /etc/ssl/nginx/ directory:

sudo mkdir -p /etc/ssl/nginx
Log in to MyF5, if you purchased subscription, or follow the link in the trial activation email, and download the following two files:

nginx-repo.key
nginx-repo.crt
Copy the above two files to the RHEL/Oracle Linux/AlmaLinux/Rocky Linux server into /etc/ssl/nginx/ directory. Use your SCP client or other secure file transfer tools.
Install prerequisite packages:

sudo yum install ca-certificates
Add NGINX Plus repository by downloading the file nginx-plus-8.repo to /etc/yum.repos.d:

sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-8.repo
If you have modsecurity subscription, add modsecurity repository by downloading the file modsecurity-8.repo to /etc/yum.repos.d:

sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/modsecurity-8.repo
Install the NGINX Plus package

sudo yum install nginx-plus
Install modsecurity, if you have modsecurity subscription

sudo yum install nginx-plus nginx-plus-module-modsecurity
Check the nginx binary version to ensure that you have NGINX Plus installed correctly:

nginx -v


systemctl enable --now nginx
systemctl status nginx


Install ClickHouse
Note:
NGINX Management Suite requires ClickHouse 22.3.15.33 or later.
NGINX Management Suite uses ClickHouse to store metrics, events, and alerts, as well as configuration settings.

Select the tab for your Linux distribution, then follow the instructions to install ClickHouse.

CENTOS, RHEL, RPM-BASED
DEBIAN, UBUNTU, DEB-BASED
To install and enable ClickHouse CentOS, RHEL, and RPM-Based distributions, take the following steps:

Set up the repository:

 Copy
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo
Install the ClickHouse server and client:

 Copy
sudo yum install -y clickhouse-server clickhouse-client
 IMPORTANT! When installing ClickHouse, you have the option to specify a password or leave the password blank (the default is an empty string). If you choose to specify a password for ClickHouse, you must also edit the /etc/nms/nms.conf file after installing NGINX Management Suite and enter your ClickHouse password; otherwise, NGINX Management Suite won’t start.

For more information on customizing ClickHouse settings, refer to the Configure ClickHouse topic.

Enable ClickHouse so that it starts automatically if the server is restarted:

 Copy
sudo systemctl enable clickhouse-server
Start the ClickHouse server:

 Copy
sudo systemctl start clickhouse-server
Verify ClickHouse is running:

 Copy
sudo systemctl status clickhouse-server


Add NGINX Management Suite Repository
To install NGINX Management Suite, you need to add the official repository to pull the pre-compiled deb and rpm packages from.

Select the tab matching your Linux distribution, then follow the instructions to add the NGINX Management Suite repository.


CENTOS, RHEL, RPM-BASED
DEBIAN, UBUNTU, DEB-BASED
Add the NGINX Management Suite repository:

CentOS/RHEL

 Copy
sudo wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nms.repo

RHEL 8: If you’re installing on RHEL 8 and using the distro’s NGINX, run the following commands to use the new version of NGINX (1.20 at the time of this update):

 Copy
sudo yum module disable nginx:1.14
sudo yum module enable nginx:1.20



Install Instance Manager
CENTOS, RHEL, RPM-BASED
DEBIAN, UBUNTU, DEB-BASED
To install the latest version of Instance Manager, run the following command:

 Copy
sudo yum install -y nms-instance-manager
 IMPORTANT! The Instance Manager’s administrator username (default is admin) and generated password are displayed in the terminal during installation. You should make a note of the password and store it securely.

Enable and start the NGINX Management Suite platform services:

 Copy
sudo systemctl enable nms nms-core nms-dpm nms-ingestion nms-integrations --now
NGINX Management Suite components started this way run by default as the non-root nms user inside the nms group, both of which are created during installation.

Restart the NGINX web server:

 Copy
sudo systemctl restart nginx

nstall NGINX Management Suite Policy
The NGINX Management Suite installer places the SELinux policy files in the following locations:

/usr/share/selinux/packages/nms.pp - loadable binary policy module
/usr/share/selinux/devel/include/contrib/nms.if - interface definitions file
/usr/share/man/man8/nms_selinux.8.gz - policy man page
You can interact with these files to learn about the policy. See the following section for steps on how to load the policy.

Load Policy and Set Default Labels
To use the SELinux policy that’s included with NGINX Management Suite, take the following steps:

Load the NGINX Management Suite policy:

 Copy
sudo semodule -n -i /usr/share/selinux/packages/nms.pp
sudo /usr/sbin/load_policy
Run the following commands to restore the default SELinux labels for the files and directories related to NGINX Management suite:

 Copy
sudo restorecon -F -R /usr/bin/nms-core
sudo restorecon -F -R /usr/bin/nms-dpm
sudo restorecon -F -R /usr/bin/nms-ingestion
sudo restorecon -F -R /usr/bin/nms-integrations
sudo restorecon -F -R /usr/lib/systemd/system/nms.service
sudo restorecon -F -R /usr/lib/systemd/system/nms-core.service
sudo restorecon -F -R /usr/lib/systemd/system/nms-dpm.service
sudo restorecon -F -R /usr/lib/systemd/system/nms-ingestion.service
sudo restorecon -F -R /usr/lib/systemd/system/nms-integrations.service
sudo restorecon -F -R /var/lib/nms/modules/manager.json
sudo restorecon -F -R /var/lib/nms/modules.json
sudo restorecon -F -R /var/lib/nms/streaming
sudo restorecon -F -R /var/lib/nms
sudo restorecon -F -R /var/lib/nms/dqlite
sudo restorecon -F -R /var/run/nms
sudo restorecon -F -R /var/lib/nms/modules
sudo restorecon -F -R /var/log/nms
(API Connectivity Manager) If you installed API Connectivity Manager, run the following additional commands to restore the default SELinux labels for the following files and directories:

 Copy
sudo restorecon -F -R /usr/bin/nms-acm
sudo restorecon -F -R /usr/lib/systemd/system/nms-acm.service
sudo restorecon -F -R /var/lib/nms/modules/acm.json
(App Delivery Manager) If you installed App Delivery Manager, run the following additional commands to restore the default SELinux labels for the following files and directories:

This topic documents an early access feature. These features are provided for you to try before they are generally available. You shouldn't use early access features for production purposes.

 Copy
sudo semodule -n -i /usr/share/selinux/packages/nms-adm.pp
sudo /usr/sbin/load_policy
sudo restorecon -F -R /usr/bin/nms-adm
sudo restorecon -F -R /usr/lib/systemd/system/nms-adm.service
sudo restorecon -F -R /var/lib/nms/modules/adm.json
Restart the NGINX Management Suite services:

 Copy
sudo systemctl restart nms
Add Ports to SELinux Context
NGINX Management Suite uses the nms_t context in the policy module. The following example shows how to add a new port to the context. You should add external ports to the firewall exception list. Note, as a system admin, you’re responsible for any custom configurations that differ from the default policy.

To add TCP ports 10000 and 11000 to the nmx_t context, run the following commands:

 Copy
sudo semanage port -a -t nms_port_t -p tcp 10000
sudo semanage port -a -t nms_port_t -p tcp 11000
If you’ve already defined the port context, use -m:

 Copy
sudo semanage port -m -t nms_port_t -p tcp 10000
sudo semanage port -m -t nms_port_t -p tcp 11000

systemctl restart nms
systemctl restart nginx


(Recommended) Use the Provided Script
You can use the basic_passwords.sh script to add a user’s encrypted password to the /etc/nms/nginx/.htpasswd file on the NGINX Management Suite server.

Note:
The basic_passwords.sh script requires the OpenSSL package. We strongly recommend OpenSSL v1.1.1 or later.
To change a user’s password with the basic_passwords.sh script:

Open an SSH connection to your NGINX Management Suite host and log in.

Run the basic_passwords.sh script, providing the username you want to update and the desired password. Make sure to enclose the password in single quotation marks.

 Copy
sudo bash /etc/nms/scripts/basic_passwords.sh <username> '<desired password>'
For example:

 Copy
sudo bash /etc/nms/scripts/basic_passwords.sh johndoe 'jelly22fi$h'



IP Addresses
192.168.152.144
Ports
80
Status
To manage this instance:

Connect and log in to the system that you want to add to NGINX Instance Management.
Run the following command to download and install the NGINX Agent Package.
curl https://nginx.local/install/nginx-agent | sudo sh
Note: You may need to add the --insecure flag to curl if TLS has not been set up.

The instance will appear in NGINX Instance Management after the NGINX Agent is started.



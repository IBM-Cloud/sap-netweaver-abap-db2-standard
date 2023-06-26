# Single Tier SAP Netweaver ABAP Stack with Db2 Deployment

## Description
This automation solution is designed for the deployment of [**Single Tier SAP Netweaver ABAP Stack with Db2**](https://cloud.ibm.com/docs/sap?topic=sap-sap-terraform-nw-db2-existing-vpc&interface=ui). The SAP solution will be deployed on top of one of the following Operating Systems: **SUSE Linux Enterprise Server 15 SP 3 for SAP**, **Red Hat Enterprise Linux 8.4 for SAP**, **Red Hat Enterprise Linux 7.6 for SAP** in an existing IBM Cloud Gen2 VPC, using an existing [bastion host with secure remote SSH access](https://github.com/IBM-Cloud/sap-bastion-setup).


## Contents:

- [1.1 Installation media](#11-installation-media)
- [1.2 VSI Configuration](#12-vsi-configuration)
- [1.3 VPC Configuration](#13-vpc-configuration)
- [1.4 Files description and structure](#14-files-description-and-structure)
- [2.1 Executing the deployment of **Single Tier SAP Netweaver ABAP Stack with Db2** in GUI (Schematics)](#21-executing-the-deployment-of-single-tier-sap-netweaver-abap-stack-with-db2-in-gui-schematics)
- [2.2 Executing the deployment of **Single Tier SAP Netweaver ABAP Stack with Db2** in CLI](#22-executing-the-deployment-of-single-tier-sap-netweaver-abap-stack-with-db2-in-cli)
- [3.1 Related links](#31-related-links)


## 1.1 Installation media
SAP installation media used for this deployment is the default one for **SAP Netweaver 7.5** with **Db2 11.5.6 FP0** on Red Hat 8.4, 8.6 and Suse 15 SP3, SP4, available at SAP Support Portal under *INSTALLATION AND UPGRADE* area and it has to be provided manually at the "input parameter" section.

## 1.2 VSI Configuration
The VSIs are deployed with one of the following Operating Systems: Suse Enterprise Linux 15 SP3 for SAP Applications (amd64), Suse Enterprise Linux 15 SP4 for SAP Applications (amd64), Red Hat Enterprise Linux 8.4 for SAP Applications (amd64), Red Hat Enterprise Linux 8.6 for SAP Applications (amd64). The SSH keys are configured to allow root user access. The following storage volumes are creating during the provisioning:

SAP NetWeaver-ABAP-Db2-standard VSI Disks:
- 1 x 32 GB disk with 10 IOPS / GB - DATA
- 1 x 40 GB disk with 10 IOPS / GB - SWAP
- 1 x 64 GB disk with 10 IOPS / GB - DATA
- 1 x 128 GB disk with 10 IOPS / GB - DATA
- 1 x 256 GB disk with 10 IOPS / GB - DATA

In order to perform the deployment you can use either the CLI component or the GUI component (Schematics) of the automation solution.

## 1.3 VPC Configuration

The Security Rules inherited from BASTION deployment are the following:
- Allow all traffic in the Security group for private networks.
- Allow outbound traffic  (ALL for port 53, TCP for ports 80, 443, 8443)
- Allow inbound SSH traffic (TCP for port 22) from IBM Schematics Servers.

 ## 1.4 Files description and structure

 - `modules` - directory containing the terraform modules.
 - `ansible`  - directory containing the SAP ansible playbooks.
 - `main.tf` - contains the configuration of the VSI for the deployment of the current SAP solution.
 - `output.tf` - contains the code for the information to be displayed after the VSI is created (VPC, Hostname, Private IP).
 - `integration*.tf & generate*.tf` files - contain the integration code that makes the SAP variabiles from Terraform available to Ansible.
 - `provider.tf` - contains the IBM Cloud Provider data in order to run `terraform init` command.
 - `variables.tf` - contains variables for the VPC and VSI.
 - `versions.tf` - contains the minimum required versions for terraform and IBM Cloud provider.
 - `sch.auto.tfvars` - contains programatic variables.

## 2.1 Executing the deployment of **Single Tier SAP Netweaver ABAP Stack with Db2** in GUI (Schematics)

The solution is based on Terraform remote-exec and Ansible playbooks executed by Schematics and it is implementing a 'reasonable' set of best practices for SAP VSI host configuration.

**It contains:**
- Terraform scripts for the deployment of a VSI, in an EXISTING VPC, with Subnet and Security Group. The VSI is intended to be used for the data base instance and the for the application instance. The Terraform version used for deployment should be >= 1.3.6. Note: The deployment was tested with Terraform 1.3.6
- Bash scripts used for the checking of the prerequisites required by SAP VSI deployment and for the integration into a single step in IBM Schematics GUI of the VSI provisioning and the **Single Tier SAP Netweaver ABAP Stack with Db2** installation.
- Ansible scripts to configure Single Tier SAP Netweaver ABAP Stack with Db2 installation.
Please note that Ansible is started by Terraform and must be available on the same host.

### IBM Cloud API Key
The IBM Cloud API Key should be provided as input value of type sensitive for "ibmcloud_api_key" variable, in `IBM Schematics -> Workspaces -> <Workspace name> -> Settings` menu.
The IBM Cloud API Key can be created [here](https://cloud.ibm.com/iam/apikeys).

### Input parameters

The following parameters can be set in the Schematics workspace: VPC, Subnet, Security group, Resource group, Hostname, Profile, Image, SSH Keys and your SAP system configuration variables, as below:

**VSI input parameters:**

Parameter | Description
----------|------------
ibmcloud_api_key | IBM Cloud API key (Sensitive* value).
private_ssh_key | Input your id_rsa private key content in OpenSSH format (Sensitive* value). This private key should be used only during the terraform provisioning and it is recommended to be changed after the SAP deployment.
ID_RSA_FILE_PATH | The file path for private_ssh_key will be automatically generated by default. If it is changed, it must contain the relative path from git repo folders.<br /> Default value: "ansible/id_rsa".
SSH_KEYS | List of SSH Keys UUIDs that are allowed to SSH as root to the VSI. Can contain one or more IDs. The list of SSH Keys is available [here](https://cloud.ibm.com/vpc-ext/compute/sshKeys). <br /> Sample input (use your own SSH UUIDs from IBM Cloud):<br /> [ "r010-57bfc315-f9e5-46bf-bf61-d87a24a9ce7a" , "r010-3fcd9fe7-d4a7-41ce-8bb3-d96e936b2c7e" ]
BASTION_FLOATING_IP | The FLOATING IP from the Bastion Server.
RESOURCE_GROUP | The name of an EXISTING Resource Group for VSIs and Volumes resources. <br /> Default value: "Default". The list of Resource Groups is available [here](https://cloud.ibm.com/account/resource-groups).
REGION | The cloud region where to deploy the solution. <br /> The regions and zones for VPC are listed [here](https://cloud.ibm.com/docs/containers?topic=containers-regions-and-zones#zones-vpc). <br /> Review supported locations in IBM Cloud Schematics [here](https://cloud.ibm.com/docs/schematics?topic=schematics-locations).<br /> Sample value: eu-de.
ZONE | The cloud zone where to deploy the solution. <br /> Sample value: eu-de-2.
VPC | The name of an EXISTING VPC. The list of VPCs is available [here](https://cloud.ibm.com/vpc-ext/network/vpcs)
SUBNET | The name of an EXISTING Subnet. The list of Subnets is available [here](https://cloud.ibm.com/vpc-ext/network/subnets).
SECURITY_GROUP | The name of an EXISTING Security group. The list of Security Groups is available [here](https://cloud.ibm.com/vpc-ext/network/securityGroups).
HOSTNAME | The Hostname for the VSI. The hostname should be up to 13 characters as required by SAP. For more information on rules regarding hostnames for SAP systems, check [SAP Note 611361: Hostnames of SAP ABAP Platform servers](https://launchpad.support.sap.com/#/notes/%20611361)
PROFILE |  A list of profiles is available [here](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles) <br>  For more information about supported DB/OS and IBM Gen 2 Virtual Server Instances (VSI), check [SAP Note 2927211: SAP Applications on IBM Virtual Private Cloud](https://launchpad.support.sap.com/#/notes/2927211) <br /> Default value: "bx2-4x16"
IMAGE | The OS image used for the VSI. A list of images is available [here](https://cloud.ibm.com/docs/vpc?topic=vpc-about-images).<br /> Supported images: ibm-sles-15-3-amd64-sap-applications-5, ibm-sles-15-4-amd64-sap-applications-4, ibm-redhat-8-4-amd64-sap-applications-4, ibm-redhat-8-6-amd64-sap-applications-2. Default value: ibm-redhat-8-6-amd64-sap-applications-2

**SAP input parameters:**

Parameter | Description | Requirements
----------|-------------|-------------
sap_sid | The SAP system ID <SAPSID> identifies the entire SAP system. <br /> Default value: DB2 | <ul><li>Consists of exactly three alphanumeric characters</li><li>Has a letter for the first character</li><li>Does not include any of the reserved IDs listed in SAP Note 1979280</li></ul>|
sap_ci_instance_number | Technical identifier for internal processes of CI. <br /> Default value: 00 | <ul><li>Two-digit number from 00 to 97</li><li>Must be unique on a host</li></ul>
sap_ascs_instance_number | Technical identifier for internal processes of ASCS. <br /> Default value: 01 | <ul><li>Two-digit number from 00 to 97</li><li>Must be unique on a host</li></ul>
sap_main_password | Common password for all users that are created during the installation. (Sensitive* value). | <ul><li>It must be 8 to 14 characters long</li><li>It must contain at least one digit (0-9)</li><li>It must not contain \ (backslash) and " (double quote)</li></ul>
kit_sapcar_file  | Path to sapcar binary | As downloaded from SAP Support Portal
kit_swpm_file | Path to SWPM archive (SAR) | As downloaded from SAP Support Portal
kit_saphostagent_file | Path to SAP Host Agent archive (SAR) | As downloaded from SAP Support Portal
kit_sapexe_file | Path to SAP Kernel OS archive (SAR) | As downloaded from SAP Support Portal
kit_sapexedb_file | Path to SAP Kernel DB archive (SAR) | As downloaded from SAP Support Portal
kit_igsexe_file | Path to IGS archive (SAR) | As downloaded from SAP Support Portal
kit_igshelper_file | Path to IGS Helper archive (SAR) | As downloaded from SAP Support Portal
kit_export_dir | Path to NW 7.5 Installation Export dir | The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file
kit_db2_dir | Path to DB2 LUW 11.5 MP6 FP0 SAP2 Linux on x86_64 64bit dir for Red Hat 8.4, 8.6 and Suse 15 SP3, SP4 | The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file. Default value: /storage/NW75DB2/51055138/DB2_FOR_LUW_11.5_MP6_FP0SAP2_LINUX_
kit_db2client_dir | Path to DB2 LUW 11.5 MP6 FP0 SAP2 RDBMS Client dir for Red Hat 8.4, 8.6 and Suse 15 SP3, SP4| The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file. Default value: /storage/NW75DB2/51055140

**Obs***: <br />
- Sensitive - The variable value is not displayed in your Schematics logs and it is hidden in the input field.<br />
- The following parameters should have the same values as the ones set for the BASTION server: REGION, ZONE, VPC, SUBNET, SECURITY_GROUP.
- For any manual change in the terraform code, you have to make sure that you use a certified image based on the SAP NOTE: 2927211.

### Steps to follow:

1.  Make sure that you have the [required IBM Cloud IAM
    permissions](https://cloud.ibm.com/docs/vpc?topic=vpc-managing-user-permissions-for-vpc-resources) to
    create and work with VPC infrastructure and you are [assigned the
    correct
    permissions](https://cloud.ibm.com/docs/schematics?topic=schematics-access) to
    create the workspace in Schematics and deploy resources.
2.  [Generate an SSH
    key](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys).
    The SSH key is required to access the provisioned VPC virtual server
    instances via the bastion host. After you have created your SSH key,
    make sure to [upload this SSH key to your IBM Cloud
    account](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-managing-ssh-keys#managing-ssh-keys-with-ibm-cloud-console) in
    the VPC region and resource group where you want to deploy the SAP solution
3.  Create the Schematics workspace:
    1.  From the IBM Cloud menu
    select [Schematics](https://cloud.ibm.com/schematics/overview).
       - Click Create a workspace.
       - Enter a name for your workspace.
       - Click Create to create your workspace.
    2.  On the workspace **Settings** page, enter the URL of this solution in the Schematics examples Github repository.
     - Select the latest Terraform version.
     - Click **Save template information**.
     - In the **Input variables** section, review the default input variables and provide alternatives if desired.
    - Click **Save changes**.

4.  From the workspace **Settings** page, click **Generate plan** 
5.  Click **View log** to review the log files of your Terraform
    execution plan.
6.  Apply your Terraform template by clicking **Apply plan**.
7.  Review the log file to ensure that no errors occurred during the
    provisioning, modification, or deletion process.

The output of the Schematics Apply Plan will list the public/private IP addresses
of the VSI host, the hostname and the VPC.

## 2.2 Executing the deployment of **Single Tier SAP Netweaver ABAP Stack with Db2** in CLI

The solution is based on Terraform scripts and Ansible playbooks executed in CLI and it is implementing a 'reasonable' set of best practices for SAP VSI host configuration.

**It contains:**
- Terraform scripts for the deployment of a VSI, in an EXISTING VPC, with Subnet and Security Group. The VSI is intended to be used for the data base instance and the for the application instance. The Terraform version used for deployment should be >= 1.3.6. Note: The deployment was tested with Terraform 1.3.6
- Ansible scripts to configure SAP Netweaver and Db2 installation.
Please note that Ansible is started by Terraform and must be available on the same host.

### IBM Cloud API Key
For the script configuration add your IBM Cloud API Key in terraform planning phase command 'terraform plan --out plan1'.
You can create an API Key [here](https://cloud.ibm.com/iam/apikeys).

### Input parameter file
The solution is configured by editing your variables in the file `input.auto.tfvars`
Edit your VPC, Subnet, Security group, Hostname, Profile, Image, SSH Keys and starting with minimal recommended disk sizes like so:

**VSI input parameters**

```shell
##########################################################
# General & Default VPC variables for CLI deployment:
######################################################

REGION = ""  
# Region for the VSI. Supported regions: https://cloud.ibm.com/docs/containers?topic=containers-regions-and-zones#zones-vpc
# Edit the variable value with your deployment Region.
# Example: REGION = "eu-de"

ZONE = ""    
# Availability zone for VSI. Supported zones: https://cloud.ibm.com/docs/containers?topic=containers-regions-and-zones#zones-vpc
# Edit the variable value with your deployment Zone.
# Example: ZONE = "eu-de-1"

VPC = ""
# EXISTING VPC, previously created by the user in the same region as the VSI. The list of available VPCs: https://cloud.ibm.com/vpc-ext/network/vpcs
# Example: VPC = "ic4sap"

SECURITY_GROUP = ""
# EXISTING Security group, previously created by the user in the same VPC. The list of available Security Groups: https://cloud.ibm.com/vpc-ext/network/securityGroups
# Example: SECURITY_GROUP = "ic4sap-securitygroup"

RESOURCE_GROUP = ""
# EXISTING Resource group, previously created by the user. The list of available Resource Groups: https://cloud.ibm.com/account/resource-groups
# Example: RESOURCE_GROUP = "wes-automation"

SUBNET = ""
# EXISTING Subnet in the same region and zone as the VSI, previously created by the user. The list of available Subnets: https://cloud.ibm.com/vpc-ext/network/subnets
# Example: SUBNET = "ic4sap-subnet"

SSH_KEYS = [""]
# List of SSH Keys UUIDs that are allowed to SSH as root to the VSI. The SSH Keys should be created for the same region as the VSI. The list of available SSH Keys UUIDs: https://cloud.ibm.com/vpc-ext/compute/sshKeys
# Example: SSH_KEYS = ["r010-8f72b994-c17f-4500-af8f-d05680374t3c", "r011-8f72v884-c17f-4500-af8f-d05900374t3c"]
 
ID_RSA_FILE_PATH = ""
# Input your id_rsa private key file path in OpenSSH format with 0600 permissions.
# This private key it is used only during the terraform provisioning and it is recommended to be changed after the SAP deployment.
# Can be used relative or absolut paths. Examples: "~/.ssh/id_rsa_abap_db2_std" or "/root/.ssh/id_rsa".

##########################################################
# VSI variables:
##########################################################

HOSTNAME = "db2saphost1" 
# The Hostname for the DB VSI. The hostname should be up to 13 characters, as required by SAP
# Example: HOSTNAME = "db2saphost1"

PROFILE = "bx2-4x16"
# The DB VSI profile. Supported profiles for DB VSI: mx2-16x128. The list of available profiles: https://cloud.ibm.com/docs/vpc?topic=vpc-profiles&interface=ui

IMAGE = "ibm-redhat-8-6-amd64-sap-applications-2"
# OS image for SAP APP VSI. Supported OS images for APP VSIs: ibm-sles-15-3-amd64-sap-applications-5, ibm-sles-15-4-amd64-sap-applications-4, ibm-redhat-8-4-amd64-sap-applications-4, ibm-redhat-8-6-amd64-sap-applications-2.
# The list of available VPC Operating Systems supported by SAP: SAP note '2927211 - SAP Applications on IBM Virtual Private Cloud (VPC) Infrastructure environment' https://launchpad.support.sap.com/#/notes/2927211; The list of all available OS images: https://cloud.ibm.com/docs/vpc?topic=vpc-about-images
# Example: IMAGE = "ibm-sles-15-3-amd64-sap-applications-5"
```

Parameter | Description
----------|------------
ibmcloud_api_key | IBM Cloud API key (Sensitive* value).
SSH_KEYS | List of SSH Keys IDs that are allowed to SSH as root to the VSI. Can contain one or more IDs. The list of SSH Keys is available [here](https://cloud.ibm.com/vpc-ext/compute/sshKeys). <br /> Sample input (use your own SSH IDS from IBM Cloud):<br /> [ "r010-57bfc315-f9e5-46bf-bf61-d87a24a9ce7a" , "r010-3fcd9fe7-d4a7-41ce-8bb3-d96e936b2c7e" ]
ID_RSA_FILE_PATH | The id_rsa private key file path in OpenSSH format with 0600 permissions. It is recommended to be changed after the SAP deployment. <br /> Sample values: "~/.ssh/id_rsa_abap_db2_std" or "ansible/id_rsa_abap_db2_std".
REGION | The cloud region where to deploy the solution. <br /> The regions and zones for VPC are listed [here](https://cloud.ibm.com/docs/containers?topic=containers-regions-and-zones#zones-vpc). <br /> Sample value: eu-de.
ZONE | The cloud zone where to deploy the solution. <br /> Sample value: eu-de-2.
VPC | The name of an EXISTING VPC. The list of VPCs is available [here](https://cloud.ibm.com/vpc-ext/network/vpcs)
SUBNET | The name of an EXISTING Subnet. The list of Subnets is available [here](https://cloud.ibm.com/vpc-ext/network/subnets).
SECURITY_GROUP | The name of an EXISTING Security group. The list of Security Groups is available [here](https://cloud.ibm.com/vpc-ext/network/securityGroups).
RESOURCE_GROUP | The name of an EXISTING Resource Group for VSIs and Volumes resources. The list of Resource Groups is available [here](https://cloud.ibm.com/account/resource-groups).
HOSTNAME | The Hostname for the VSI. The hostname should be up to 13 characters as required by SAP.<br> For more information on rules regarding hostnames for SAP systems, check [SAP Note 611361: Hostnames of SAP ABAP Platform servers](https://launchpad.support.sap.com/#/notes/%20611361)
PROFILE |  The profile used for the VSI. A list of profiles is available [here](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles).<br> For more information about supported DB/OS and IBM Gen 2 Virtual Server Instances (VSI), check [SAP Note 2927211: SAP Applications on IBM Virtual Private Cloud](https://launchpad.support.sap.com/#/notes/2927211)
IMAGE | The OS image used for the VSI. A list of images is available [here](https://cloud.ibm.com/docs/vpc?topic=vpc-about-images).<br /> Supported images: ibm-sles-15-3-amd64-sap-applications-5, ibm-sles-15-4-amd64-sap-applications-4, ibm-redhat-8-4-amd64-sap-applications-4, ibm-redhat-8-6-amd64-sap-applications-2. Default value: ibm-redhat-8-6-amd64-sap-applications-2

**SAP input parameters**

Edit the SAP system configuration variables that will be passed to the ansible automated deployment:

```shell
##########################################################
# SAP system configuration
##########################################################

sap_sid = "DB2"
# SAP System ID

sap_ascs_instance_number = "01"
# The central ABAP service instance number. Should follow the SAP rules for instance number naming.
# Example: sap_ascs_instance_number = "01"

sap_ci_instance_number = "00"
# The SAP central instance number. Should follow the SAP rules for instance number naming.
# Example: sap_ci_instance_number = "06"

##########################################################
# Kit Paths
##########################################################

kit_sapcar_file = "/storage/NW75DB2/SAPCAR_1010-70006178.EXE"
kit_swpm_file =  "/storage/NW75DB2/SWPM10SP37_2-20009701.SAR"
kit_saphotagent_file = "/storage/NW75DB2/SAPHOSTAGENT51_51-20009394.SAR"
kit_sapexe_file = "/storage/NW75DB2/SAPEXE_800-80002573.SAR"
kit_sapexedb_file = "/storage/NW75DB2/SAPEXEDB_800-80002603.SAR"
kit_igsexe_file = "/storage/NW75DB2/igsexe_13-80003187.sar"
kit_igshelper_file = "/storage/NW75DB2/igshelper_17-10010245.sar"
kit_export_dir = "/storage/NW75DB2/51050829"
# On Red Hat 8 and SLES 15
kit_db2_dir = "/storage/NW75DB2/51055138/DB2_FOR_LUW_11.5_MP6_FP0SAP2_LINUX_"
```

Parameter | Description | Requirements
----------|-------------|-------------
sap_sid | The SAP system ID <SAPSID> identifies the entire SAP system | <ul><li>Consists of exactly three alphanumeric characters</li><li>Has a letter for the first character</li><li>Does not include any of the reserved IDs listed in SAP Note 1979280</li></ul>|
sap_ci_instance_number | Technical identifier for internal processes of CI| <ul><li>Two-digit number from 00 to 97</li><li>Must be unique on a host</li></ul>
sap_ascs_instance_number | Technical identifier for internal processes of ASCS| <ul><li>Two-digit number from 00 to 97</li><li>Must be unique on a host</li></ul>
sap_main_password | Common password for all users that are created during the installation (Sensitive* value). | <ul><li>It must be 8 to 14 characters long</li><li>It must contain at least one digit (0-9)</li><li>It must not contain \ (backslash) and " (double quote)</li></ul>
kit_sapcar_file  | Path to sapcar binary | As downloaded from SAP Support Portal
kit_swpm_file | Path to SWPM archive (SAR) | As downloaded from SAP Support Portal
kit_saphostagent_file | Path to SAP Host Agent archive (SAR) | As downloaded from SAP Support Portal
kit_sapexe_file | Path to SAP Kernel OS archive (SAR) | As downloaded from SAP Support Portal
kit_sapexedb_file | Path to SAP Kernel DB archive (SAR) | As downloaded from SAP Support Portal
kit_igsexe_file | Path to IGS archive (SAR) | As downloaded from SAP Support Portal
kit_igshelper_file | Path to IGS Helper archive (SAR) | As downloaded from SAP Support Portal
kit_export_dir | Path to NW 7.5 Installation Export dir | The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file
kit_db2_dir | Path to DB2 LUW 11.5 MP6 FP0 SAP2 Linux on x86_64 64bit dir for Red Hat 8.4 and Suse 15 SP3 and path to DB2 LUW 10.5 FP7SAP2 Linux on x86_64 64bit dir for Red Hat 7.6 | The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file. Default value: /storage/NW75DB2/51055138/DB2_FOR_LUW_11.5_MP6_FP0SAP2_LINUX_
kit_db2client_dir | Path to DB2 LUW 11.5 MP6 FP0 SAP2 RDBMS Client dir for Red Hat 8.4 and Suse 15 SP3 and path to DB2 LUW 10.5 FP7SAP2 RDBMS Client dir for Red Hat 7.6 | The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file. Default value: /storage/NW75DB2/51055140

**Obs***: <br />
- Sensitive - The variable value is not displayed in your tf files details after terrafrorm plan&apply commands.<br />
- The following variables should be the same like the bastion ones: REGION, ZONE, VPC, SUBNET, SECURITY_GROUP.

### Steps to follow:

For initializing terraform:

```shell
terraform init
```

For planning phase:

```shell
terraform plan --out plan1
# you will be asked for the following sensitive variables: 'ibmcloud_api_key' and 'sap_main_password'.
```

For apply phase:

```shell
terraform apply "plan1"
```

For destroy:

```shell
terraform destroy
# you will be asked for the following sensitive variables as a destroy confirmation phase:
'ibmcloud_api_key'  and  'sap_main_password'.
```

### 3.1 Related links:

- [How to create a BASTION/STORAGE VSI for SAP in IBM Schematics](https://github.com/IBM-Cloud/sap-bastion-setup)
- [Securely Access Remote Instances with a Bastion Host](https://www.ibm.com/cloud/blog/tutorial-securely-access-remote-instances-with-a-bastion-host)
- [VPNs for VPC overview: Site-to-site gateways and Client-to-site servers.](https://cloud.ibm.com/docs/vpc?topic=vpc-vpn-overview)
- [IBM Cloud Schematics](https://www.ibm.com/cloud/schematics)
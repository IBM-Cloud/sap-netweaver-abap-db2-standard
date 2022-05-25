# Automation script for central SAP Netweaver and DB2 installation using Terraform and Ansible integration deployment throught IBM Schematics.


## Description
This solution will perform an automated deployment of a single host with **SAP Netweaver** and  **DB2** on top of **Red Hat Enterprise Linux 7.6 for SAP Applications** through IBM Cloud Schematics. It shows how to deploy an SAP solution in an existing IBM Cloud Gen2 VPC using a bastion host with secure remote SSH access.

The intended usage is for remote software installation using Terraform remote-exec and Ansible playbooks executed by Schematics.

This example and the terraform modules only seek to implement a 'reasonable' set of best practices for SAP VSI host configuration. Your own Organization could have additional requirements that should be applied before the deployment.

**It contains:**

- Terraform scripts for deploying in an **existing  VPC** the  Subnet, Security Group with rules, SAP volumes and a VSI.
- Bash scripts to install the prerequisites for the SAP VSI deployment and the integration toward to **SAP Netweaver 7.5** with **DB2 10.5FP7** installation using IBM Schematics GUI in a single step.
- Ansible scripts to configure SAP Netweaver and DB2 installation.

## Installation media
The SAP installation media used for this deployment is the default one for **SAP Netweaver 7.5** with **DB2 10.5FP7** available at SAP Support Portal under *INSTALLATION AND UPGRADE* area and it has to be provided manually in the input parameter file.

## VSI Configuration
The VSI is deployed with Red Hat Enterprise Linux 7.6 for SAP Applications (amd64). The SSH keys are configured to allow root user access. The following storage volumes are creating during the provisioning:

SAP NetWeaver-ABAP-DB2-standard VSI Disks:
- 1 x 32 GB disk with 10 IOPS / GB - DATA
- 1x 32 GB disk with 10 IOPS / GB - SWAP
- 1 x 64 GB disk with 10 IOPS / GB - DATA
- 1 x 128 GB disk with 10 IOPS / GB - DATA
- 1 x 256 GB disk with 10 IOPS / GB - DATA

## IBM Cloud API Key
The IBM Cloud API Key should be provided as input value of type sensitive for "ibmcloud_api_key" variable, in `IBM Schematics -> Workspaces -> <Workspace name> -> Settings` menu.
The IBM Cloud API Key can be created [here](https://cloud.ibm.com/iam/apikeys).

## Input parameters

The following parameters can be set in the Schematics workspace: VPC, Subnet, Security group, Resource group, Hostname, Profile, Image, SSH Keys and your SAP system configuration variables, as below:

**VSI input parameters:**

Parameter | Description
----------|------------
ibmcloud_api_key | IBM Cloud API key (Sensitive* value).
private_ssh_key | id_rsa private key content (Sensitive* value).
SSH_KEYS | List of SSH Keys UUIDs that are allowed to SSH as root to the VSI. Can contain one or more IDs. The list of SSH Keys is available [here](https://cloud.ibm.com/vpc-ext/compute/sshKeys). <br /> Sample input (use your own SSH UUIDs from IBM Cloud):<br /> [ "r010-57bfc315-f9e5-46bf-bf61-d87a24a9ce7a" , "r010-3fcd9fe7-d4a7-41ce-8bb3-d96e936b2c7e" ]
BASTION_FLOATING_IP | The FLOATING IP from the Bastion Server.
RESOURCE_GROUP | An EXISTING  Resource Group for VSIs and Volumes resources. <br /> Default value: "Default". The list of Resource Groups is available [here](https://cloud.ibm.com/account/resource-groups).
REGION | The cloud region where to deploy the solution. <br /> The regions and zones for VPC are listed [here](https://cloud.ibm.com/docs/containers?topic=containers-regions-and-zones#zones-vpc). <br /> Review supported locations in IBM Cloud Schematics [here](https://cloud.ibm.com/docs/schematics?topic=schematics-locations).<br /> Sample value: eu-de.
ZONE | The cloud zone where to deploy the solution. <br /> Sample value: eu-de-2.
VPC | EXISTING VPC name. The list of VPCs is available [here](https://cloud.ibm.com/vpc-ext/network/vpcs)
SUBNET | EXISTING Subnet name. The list of Subnets is available [here](https://cloud.ibm.com/vpc-ext/network/subnets). 
SECURITY_GROUP | EXISTING Security group name. The list of Security Groups is available [here](https://cloud.ibm.com/vpc-ext/network/securityGroups). 
HOSTNAME | The Hostname for the VSI. The hostname must have up to 13 characters as required by SAP. For more information on rules regarding hostnames for SAP systems, check SAP Note *611361 - Hostnames of SAP ABAP Platform servers*
PROFILE |  The profile used for the VSI. A list of profiles is available [here](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles) <br /> Default value: "bx2-4x16"
IMAGE | The OS image used for the VSI. A list of images is available [here](https://cloud.ibm.com/docs/vpc?topic=vpc-about-images).<br /> Default value: ibm-redhat-7-6-amd64-sap-applications-3

**SAP input parameters:**

Parameter | Description | Requirements
----------|-------------|-------------
sap_sid | The SAP system ID <SAPSID> identifies the entire SAP system. <br /> Default value: DB1 | <ul><li>Consists of exactly three alphanumeric characters</li><li>Has a letter for the first character</li><li>Does not include any of the reserved IDs listed in SAP Note 1979280</li></ul>| 
sap_ci_instance_number | Technical identifier for internal processes of CI. <br /> Default value: 00 | <ul><li>Two-digit number from 00 to 97</li><li>Must be unique on a host</li></ul>
sap_ascs_instance_number | Technical identifier for internal processes of ASCS. <br /> Default value: 01 | <ul><li>Two-digit number from 00 to 97</li><li>Must be unique on a host</li></ul>
sap_master_password | Common password for all users that are created during the installation. (Sensitive* value). | <ul><li>It must be 8 to 14 characters long</li><li>It must contain at least one digit (0-9)</li><li>It must not contain \ (backslash) and " (double quote)</li></ul>
kit_sapcar_file  | Path to sapcar binary | As downloaded from SAP Support Portal
kit_swpm_file | Path to SWPM archive (SAR) | As downloaded from SAP Support Portal
kit_saphostagent_file | Path to SAP Host Agent archive (SAR) | As downloaded from SAP Support Portal
kit_sapexe_file | Path to SAP Kernel OS archive (SAR) | As downloaded from SAP Support Portal
kit_sapexedb_file | Path to SAP Kernel DB archive (SAR) | As downloaded from SAP Support Portal
kit_igsexe_file | Path to IGS archive (SAR) | As downloaded from SAP Support Portal
kit_igshelper_file | Path to IGS Helper archive (SAR) | As downloaded from SAP Support Portal
kit_export_dir | Path to NW 7.5 Installation Export dir | The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file
kit_db2_dir | Path to DB2 LUW 10.5 FP7SAP2 Linux on x86_64 64bit dir | The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file
kit_db2client_dir | Path to DB2 LUW 10.5 FP7SAP2 RDBMS Client dir | The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file


**Obs***: <br />
- Sensitive - The variable value is not displayed in your Schematics logs and it is hidden in the input field.<br />
- The following parameters should have the same values as the ones set for the BASTION server: REGION, ZONE, VPC, SUBNET, SECURITY_GROUP.
- For any manual change in the terraform code, you have to make sure that you use a certified image based on the SAP NOTE: 2927211.


## VPC Configuration

The Security Rules inherited from BASTION deployment are the following:
- Allow all traffic in the Security group for private networks.
- Allow outbound traffic  (ALL for port 53, TCP for ports 80, 443, 8443)
- Allow inbound SSH traffic (TCP for port 22) from IBM Schematics Servers.


 ## Files description and structure:

 - `modules` - directory containing the terraform modules.
 - `ansible`  - directory containing the SAP ansible playbooks.
 - `main.tf` - contains the configuration of the VSI for the deployment of the current SAP solution.
 - `output.tf` - contains the code for the information to be displayed after the VSI is created (VPC, Hostname, Private IP).
 - `integration*.tf & generate*.tf` files - contain the integration code that makes the SAP variabiles from Terraform available to Ansible.
 - `provider.tf` - contains the IBM Cloud Provider data in order to run `terraform init` command.
 - `variables.tf` - contains variables for the VPC and VSI.
 - `versions.tf` - contains the minimum required versions for terraform and IBM Cloud provider.



## Steps to reproduce:

1.  Be sure that you have the [required IBM Cloud IAM
    permissions](https://cloud.ibm.com/docs/vpc?topic=vpc-managing-user-permissions-for-vpc-resources) to
    create and work with VPC infrastructure and you are [assigned the
    correct
    permissions](https://cloud.ibm.com/docs/schematics?topic=schematics-access) to
    create the workspace in Schematics and deploy resources.
2.  [Generate an SSH
    key](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys).
    The SSH key is required to access the provisioned VPC virtual server
    instances via the bastion host. After you have created your SSH key,
    make sure to [upload this SSH key to your IBM Cloud
    account](https://cloud.ibm.com/docs/vpc-on-classic-vsi?topic=vpc-on-classic-vsi-managing-ssh-keys#managing-ssh-keys-with-ibm-cloud-console) in
    the VPC region and resource group where you want to deploy the SAP solution
3.  Create the Schematics workspace:
    1.  From the IBM Cloud menu
    select [Schematics](https://cloud.ibm.com/schematics/overview).
       - Click Create a workspace.   
       - Enter a name for your workspace.   
       - Click Create to create your workspace.
    2.  On the workspace **Settings** page, enter the URL of this solution in the Schematics examples Github repository.
     - Select the latest Terraform version.
     - Click **Save template information**.
     - In the **Input variables** section, review the default input variables and provide alternatives if desired.
    - Click **Save changes**.

4.  From the workspace **Settings** page, click **Generate plan** 
5.  Click **View log** to review the log files of your Terraform
    execution plan.
6.  Apply your Terraform template by clicking **Apply plan**.
7.  Review the log file to ensure that no errors occurred during the
    provisioning, modification, or deletion process.

The output of the Schematics Apply Plan will list the public/private IP addresses
of the VSI host, the hostname and the VPC.  


### Related links:

- [How to create a BASTION/STORAGE VSI for SAP in IBM Schematics](https://github.com/IBM-Cloud/sap-bastion-setup)
- [Securely Access Remote Instances with a Bastion Host](https://www.ibm.com/cloud/blog/tutorial-securely-access-remote-instances-with-a-bastion-host)
- [VPNs for VPC overview: Site-to-site gateways and Client-to-site servers.](https://cloud.ibm.com/docs/vpc?topic=vpc-vpn-overview)
- [IBM Cloud Schematics](https://www.ibm.com/cloud/schematics)

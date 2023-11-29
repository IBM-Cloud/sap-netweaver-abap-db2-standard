##########################################################
# General & Default VPC variables for CLI deployment:
######################################################

REGION = ""  
# The cloud region where to deploy the solution. Supported regions: https://cloud.ibm.com/docs/containers?topic=containers-regions-and-zones#zones-vpc
# Example: REGION = "eu-de"

ZONE = ""    
# Availability zone for VSIs, in the REGION. Supported zones: https://cloud.ibm.com/docs/containers?topic=containers-regions-and-zones#zones-vpc
# Example: ZONE = "eu-de-2"

VPC = ""
# The name of an EXISTING VPC. Must be in the same region as the solution to be deployed. The list of VPCs is available here: https://cloud.ibm.com/vpc-ext/network/vpcs.
# Example: VPC = "ic4sap"

SECURITY_GROUP = ""
# The name of an EXISTING Security group for the same VPC. It can be found at the end of the Bastion Server deployment log, in "Outputs", before "Command finished successfully" message.
# The list of available Security Groups: https://cloud.ibm.com/vpc-ext/network/securityGroups
# Example: SECURITY_GROUP = "ic4sap-securitygroup"

RESOURCE_GROUP = ""
# The name of an EXISTING Resource Group, previously created by the user. The list of available Resource Groups: https://cloud.ibm.com/account/resource-groups
# Example: RESOURCE_GROUP = "wes-automation"

SUBNET = "" 
# The name of an EXISTING Subnet, in the same VPC and ZONE where the VSIs will be created. The list of Subnets is available here: https://cloud.ibm.com/vpc-ext/network/subnets. 
# Example: SUBNET = "ic4sap-subnet"

SSH_KEYS = [""]
# List of SSH Keys UUIDs that are allowed to SSH as root to the VSI. The SSH Keys should be created for the same region as the VSIs. The list of available SSH Keys UUIDs: https://cloud.ibm.com/vpc-ext/compute/sshKeys
# Example: SSH_KEYS = ["r010-8f72b994-c17f-4500-af8f-d05680374t3c", "r011-8f72v884-c17f-4500-af8f-d05900374t3c"]

ID_RSA_FILE_PATH = "ansible/id_rsa"
# The path to an existing id_rsa private key file, with 0600 permissions. The private key must be in OpenSSH format.
# This private key is used only during the provisioning and it is recommended to be changed after the SAP deployment.
# It must contain the relative or absoute path from your Bastion.
# Examples: "ansible/id_rsa_db2" , "~/.ssh/id_rsa_ase-db2" , "/root/.ssh/id_rsa_db2".

##########################################################
# Activity Tracker variables:
##########################################################

ATR_NAME = ""
# The name of the EXISTENT Activity Tracker instance, in the same region chosen for SAP system deployment.
# Example: ATR_NAME="Activity-Tracker-SAP-eu-de"


##########################################################
# VSI variables:
##########################################################

HOSTNAME = ""
# The Hostname for the VSI. The hostname should be up to 13 characters, as required by SAP
# Example: HOSTNAME = "ic4sap"

PROFILE = "bx2-4x16"
# The profile for the VSI. The list of available profiles: https://cloud.ibm.com/docs/vpc?topic=vpc-profiles. 
# For more information, check SAP Note 2927211: "SAP Applications on IBM Virtual Private Cloud"
# Example: PROFILE = "bx2-4x16"

IMAGE = "ibm-redhat-8-6-amd64-sap-applications-4"
# The OS image for the VSI. 
# Supported OS images: ibm-redhat-8-6-amd64-sap-applications-4, ibm-redhat-8-4-amd64-sap-applications-7, ibm-sles-15-4-amd64-sap-applications-6, ibm-sles-15-3-amd64-sap-applications-9. 
# The list of available VPC Operating Systems supported by SAP: SAP note '2927211 - SAP Applications on IBM Virtual Private Cloud (VPC) Infrastructure environment' https://launchpad.support.sap.com/#/notes/2927211
# A list of images is available here: https://cloud.ibm.com/docs/vpc?topic=vpc-about-images.
# Example: IMAGE = "ibm-redhat-8-6-amd64-sap-applications-4"

##########################################################
# SAP system configuration
##########################################################

SAP_SID = "DB2"
# The SAP system ID identifies the entire SAP system. 
# Consists of three alphanumeric characters and the first character must be a letter. 
# Does not include any of the reserved IDs listed in SAP Note 1979280

SAP_ASCS_INSTANCE_NUMBER = "01"
# The central ABAP service instance number. Should follow the SAP rules for instance number naming.
# Example: SAP_ASCS_INSTANCE_NUMBER = "01"

SAP_CI_INSTANCE_NUMBER = "00"
# The SAP central instance number. Should follow the SAP rules for instance number naming.
# Example: SAP_CI_INSTANCE_NUMBER = "06"

##########################################################
# Kit Paths
##########################################################

KIT_SAPCAR_FILE = "/storage/NW75DB2/SAPCAR_1010-70006178.EXE"
KIT_SWPM_FILE =  "/storage/NW75DB2/SWPM10SP37_2-20009701.SAR"
KIT_SAPHOSTAGENT_FILE = "/storage/NW75DB2/SAPHOSTAGENT51_51-20009394.SAR"
KIT_SAPEXE_FILE = "/storage/NW75DB2/SAPEXE_800-80002573.SAR"
KIT_SAPEXEDB_FILE = "/storage/NW75DB2/SAPEXEDB_800-80002603.SAR"
KIT_IGSEXE_FILE = "/storage/NW75DB2/igsexe_13-80003187.sar"
KIT_IGSHELPER_FILE = "/storage/NW75DB2/igshelper_17-10010245.sar"
KIT_EXPORT_DIR = "/storage/NW75DB2/51050829"
KIT_DB2_DIR = "/storage/NW75DB2/51055138/DB2_FOR_LUW_11.5_MP6_FP0SAP2_LINUX_"
KIT_DB2CLIENT_DIR = "/storage/NW75DB2/51055140"

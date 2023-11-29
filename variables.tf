variable "PRIVATE_SSH_KEY" {
	type		= string
	description = "id_rsa private key content in OpenSSH format (Sensitive value). This private key should be used only during the provisioning and is recommended to be changed after the SAP deployment."
	nullable = false
	validation {
	condition = length(var.PRIVATE_SSH_KEY) >= 64 && var.PRIVATE_SSH_KEY != null && length(var.PRIVATE_SSH_KEY) != 0 || contains(["n.a"], var.PRIVATE_SSH_KEY )
	error_message = "The content for PRIVATE_SSH_KEY variable must be completed in OpenSSH format."
      }
}

variable "ID_RSA_FILE_PATH" {
    default = "ansible/id_rsa"
    nullable = false
    description = "File path for PRIVATE_SSH_KEY. It will be automatically generated. If it is changed, it must contain the relative path from git repo folders. Example: ansible/id_rsa_abap_db2_dst"
}

variable "SSH_KEYS" {
	type		= list(string)
	description = "List of SSH Keys UUIDs that are allowed to connect via SSH, as root, to the VSIs. Can contain one or more IDs. The list of SSH Keys is available here: https://cloud.ibm.com/vpc-ext/compute/sshKeys"
	validation {
		condition     = var.SSH_KEYS == [] ? false : true && var.SSH_KEYS == [""] ? false : true
		error_message = "At least one SSH KEY is needed to be able to access the VSI."
	}
}

variable "BASTION_FLOATING_IP" {
	type		= string
	description = "The BASTION FLOATING IP. It can be found at the end of the Bastion Server deployment log, in \"Outputs\", before \"Command finished successfully\" message."
	nullable = false
	validation {
        condition = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$",var.BASTION_FLOATING_IP)) || contains(["localhost"], var.BASTION_FLOATING_IP ) && var.BASTION_FLOATING_IP!= null
        error_message = "Incorrect format for variable: BASTION_FLOATING_IP."
      }
}

##############################################################
# The variables used in Activity Tracker service.
##############################################################

variable "ATR_NAME" {
  type        = string
  description = "The name of the EXISTING Activity Tracker instance, in the same region as HANA VSI. The list of available Activity Tracker is available here: https://cloud.ibm.com/observe/activitytracker"
  default     = ""
}

################################################################

variable "RESOURCE_GROUP" {
  type        = string
  description = "The name of an EXISTING Resource Group, previously created by the user. The list of Resource Groups is available here: https://cloud.ibm.com/account/resource-groups"
  default     = "Default"
}

variable "REGION" {
	type		= string
	description	= "The cloud region where to deploy the solution. The regions and zones for VPC are available here: https://cloud.ibm.com/docs/containers?topic=containers-regions-and-zones#zones-vpc. Supported locations in IBM Cloud Schematics: https://cloud.ibm.com/docs/schematics?topic=schematics-locations."
	validation {
		condition     = contains(["au-syd", "jp-osa", "jp-tok", "eu-de", "eu-gb", "ca-tor", "us-south", "us-east", "br-sao"], var.REGION )
		error_message = "For CLI deployments, the REGION must be one of: au-syd, jp-osa, jp-tok, eu-de, eu-gb, ca-tor, us-south, us-east, br-sao. \n For Schematics, the REGION must be one of: eu-de, eu-gb, us-south, us-east."
	}
}

variable "ZONE" {
	type		= string
	description	= "Availability zone for VSIs, in the same VPC. Supported zones: https://cloud.ibm.com/docs/containers?topic=containers-regions-and-zones#zones-vpc"
	validation {
		condition     = length(regexall("^(au-syd|jp-osa|jp-tok|eu-de|eu-gb|ca-tor|us-south|us-east|br-sao)-(1|2|3)$", var.ZONE)) > 0
		error_message = "The ZONE is not valid."
	}
}

variable "VPC" {
	type		= string
	description = "The name of an EXISTING VPC. Must be in the same region as the solution to be deployed. The list of VPCs is available here: https://cloud.ibm.com/vpc-ext/network/vpcs."
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.VPC)) > 0
		error_message = "The VPC name is not valid."
	}
}

variable "SUBNET" {
	type		= string
	description = "The name of an EXISTING Subnet, in the same VPC, region and zone as the VSIs to be created. The list of Subnets is available here: https://cloud.ibm.com/vpc-ext/network/subnets"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.SUBNET)) > 0
		error_message = "The SUBNET name is not valid."
	}
}

variable "SECURITY_GROUP" {
	type		= string
	description = "The name of an EXISTING Security group for the same VPC. It can be found at the end of the Bastion Server deployment log, in \"Outputs\", before \"Command finished successfully\" message. The list of Security Groups is available here: https://cloud.ibm.com/vpc-ext/network/securityGroups."
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.SECURITY_GROUP)) > 0
		error_message = "The SECURITY_GROUP name is not valid."
	}
}

variable "HOSTNAME" {
	type		= string
	description = "The hostname for VSI. The hostname should be up to 13 characters. "
	validation {
		condition     = length(var.HOSTNAME) <= 13 && length(regexall("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$", var.HOSTNAME)) > 0
		error_message = "The HOSTNAME is not valid, please update input tfvars file."
	}
}

variable "PROFILE" {
	type		= string
	description = "The profile for the VSI. The list of available profiles: https://cloud.ibm.com/docs/vpc?topic=vpc-profiles&interface=ui. For more information, check SAP Note 2927211: \"SAP Applications on IBM Virtual Private Cloud\""
	default		= "bx2-4x16"
}

variable "IMAGE" {
	type		= string
	description = "The OS image for VSI. Supported OS images for APP VSIs: ibm-redhat-8-6-amd64-sap-applications-4, ibm-redhat-8-4-amd64-sap-applications-7, ibm-sles-15-4-amd64-sap-applications-6, ibm-sles-15-3-amd64-sap-applications-9. The list of available VPC Operating Systems supported by SAP: SAP note '2927211-SAP Applications on IBM Virtual Private Cloud (VPC) Infrastructure environment' https://launchpad.support.sap.com/#/notes/2927211; The list of all available OS images: https://cloud.ibm.com/docs/vpc?topic=vpc-about-images"
	default		= "ibm-redhat-8-6-amd64-sap-applications-4"
        validation {
         condition     = length(regexall("^(ibm-redhat-8-(4|6)-amd64-sap-applications|ibm-sles-15-(3|4)-amd64-sap-applications)-[0-9][0-9]*", var.IMAGE)) > 0
             error_message = "The OS SAP IMAGE must be one of \"ibm-redhat-8-4-amd64-sap-applications-x\", \"ibm-redhat-8-6-amd64-sap-applications-x\", \"ibm-sles-15-3-amd64-sap-applications-x\" or \"ibm-sles-15-4-amd64-sap-applications-x\"."
 	}
}

data "ibm_is_instance" "vsi" {
  depends_on = [module.vsi]
  name    =  var.HOSTNAME
}

variable "SAP_SID" {
	type		= string
	description = "The SAP system ID. Identifies the entire SAP system. Consists of three alphanumeric characters and the first character must be a letter. Does not include any of the reserved IDs listed in SAP Note 1979280."
	default		= "DB2"
	validation {
		condition     = length(regexall("^[a-zA-Z][a-zA-Z0-9][a-zA-Z0-9]$", var.SAP_SID)) > 0
		error_message = "The SAP_SID is not valid."
	}
}

variable "SAP_ASCS_INSTANCE_NUMBER" {
	type		= string
	description = "The central ABAP service instance number. Technical identifier for internal processes of ASCS. Consists of a two-digit number from 00 to 97. Must be unique on a host. Must follow the SAP rules for instance number naming."
	default		= "01"
	validation {
		condition     = var.SAP_ASCS_INSTANCE_NUMBER >= 0 && var.SAP_ASCS_INSTANCE_NUMBER <=97
		error_message = "The SAP_ASCS_INSTANCE_NUMBER is not valid."
	}
}

variable "SAP_CI_INSTANCE_NUMBER" {
	type		= string
	description = "The SAP central instance number. Technical identifier for internal processes of PAS. Consists of a two-digit number from 00 to 97. Must be unique on a host. Must follow the SAP rules for instance number naming"
	default		= "00"
	validation {
		condition     = var.SAP_CI_INSTANCE_NUMBER >= 0 && var.SAP_CI_INSTANCE_NUMBER <=97
		error_message = "The SAP_CI_INSTANCE_NUMBER is not valid."
	}
}

variable "SAP_MAIN_PASSWORD" {
	type		= string
	sensitive = true
	description = "The SAP MAIN Password. Common password for all users that are created during the installation. Must be 8 to 14 characters long, must contain at least one digit (0-9) and one uppercase letter, and must not contain \\ (backslash) and \" (double quote)."
	validation {
		condition     = length(regexall("^(.{0,9}|.{15,}|[^0-9]*)$", var.SAP_MAIN_PASSWORD)) == 0 && length(regexall("^[^0-9_][0-9a-zA-Z@#$_]+$", var.SAP_MAIN_PASSWORD)) > 0
		error_message = "The SAP_MAIN_PASSWORD is not valid."
	}
}

variable "KIT_SAPCAR_FILE" {
	type		= string
	description = 	"Path to sapcar binary, as downloaded from SAP Support Portal."
	default		= "/storage/NW75DB2/SAPCAR_1010-70006178.EXE"
}

variable "KIT_SWPM_FILE" {
	type		= string
	description = 	"Path to SWPM archive (SAR), as downloaded from SAP Support Portal."
	default		= "/storage/NW75DB2/SWPM10SP37_2-20009701.SAR"
}

variable "KIT_SAPHOSTAGENT_FILE" {
	type		= string
	description = 	"Path to SAP Host Agent archive (SAR), as downloaded from SAP Support Portal."
	default		= "/storage/NW75DB2/SAPHOSTAGENT51_51-20009394.SAR"
}

variable "KIT_SAPEXE_FILE" {
	type		= string
	description = 	"Path to SAP Kernel OS archive (SAR), as downloaded from SAP Support Portal."
	default		= "/storage/NW75DB2/SAPEXE_800-80002573.SAR"
}

variable "KIT_SAPEXEDB_FILE" {
	type		= string
	description = 	"Path to SAP Kernel DB archive (SAR), as downloaded from SAP Support Portal."
	default		= "/storage/NW75DB2/SAPEXEDB_800-80002603.SAR"
}

variable "KIT_IGSEXE_FILE" {
	type		= string
	description = 	"Path to IGS archive (SAR), as downloaded from SAP Support Portal."
	default		= "/storage/NW75DB2/igsexe_13-80003187.sar"
}

variable "KIT_IGSHELPER_FILE" {
	type		= string
	description = 	"Path to IGS Helper archive (SAR), as downloaded from SAP Support Portal."
	default		= "/storage/NW75DB2/igshelper_17-10010245.sar"
}

variable "KIT_EXPORT_DIR" {
	type		= string
	description = 	"Path to NW 7.5 Installation Export dir. The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file."
	default		= "/storage/NW75DB2/51050829"
}

variable "KIT_DB2_DIR" {
	type		= string
	description = 	"Path to Db2 LUW 11.5 MP6 FP0 SAP2 Linux on x86_64 64bit dir for Red Hat 8 and Suse 15. The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file. Default value: \"/storage/NW75DB2/51055138/DB2_FOR_LUW_11.5_MP6_FP0SAP2_LINUX_\".	"
	default		= "/storage/NW75DB2/51055138/DB2_FOR_LUW_11.5_MP6_FP0SAP2_LINUX_"
}

variable "KIT_DB2CLIENT_DIR" {
	type		= string
	description = 	"Path to Db2 LUW 11.5 MP6 FP0 SAP2 RDBMS Client dir for Red Hat 8 and Suse 15. The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file. Default value: \"/storage/NW75DB2/51055140\"."
	default		= "/storage/NW75DB2/51055140"
}


locals {
	ATR_ENABLE = true
}

resource "null_resource" "check_atr_name" {
  count             = local.ATR_ENABLE == true ? 1 : 0
  lifecycle {
    precondition {
      condition     = var.ATR_NAME != "" && var.ATR_NAME != null
      error_message = "The name of an EXISTENT Activity Tracker in the same region must be specified."
    }
  }
}

data "ibm_resource_instance" "activity_tracker" {
  count             = local.ATR_ENABLE == true ? 1 : 0
  name              = var.ATR_NAME
  location          = var.REGION
  service           = "logdnaat"
}

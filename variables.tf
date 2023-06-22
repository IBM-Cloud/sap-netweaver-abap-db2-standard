variable "private_ssh_key" {
	type		= string
	description = 	<<EOF
    Input your id_rsa private key pair content in OpenSSH format (Sensitive* value). This private key should be used only during the terraform provisioning and it is recommended to be changed after the SAP deployment.
	EOF
	nullable = false
	validation {
		condition = length(var.private_ssh_key) >= 64 && var.private_ssh_key != null && length(var.private_ssh_key) != 0 || contains(["n.a"], var.private_ssh_key )
		error_message = "The content for private_ssh_key variable must be completed in OpenSSH format."
    }
}

variable "ID_RSA_FILE_PATH" {
    default = "ansible/id_rsa_abap_db2_std"
    nullable = false
    description = 	<<EOF
    The file path for private_ssh_key will be automatically generated by default. If it is changed, it must contain the relative path from git repo folders.
    Default value: "ansible/id_rsa_abap_db2_std".
	EOF
}


variable "SSH_KEYS" {
	type		= list(string)
	description = 	<<EOF
    List of SSH Keys UUIDs that are allowed to SSH as root to the VSI. Can contain one or more IDs. The list of SSH Keys is available here https://cloud.ibm.com/vpc-ext/compute/sshKeys.
    Sample input (use your own SSH UUIDs from IBM Cloud):
    [ "r010-57bfc315-f9e5-46bf-bf61-d87a24a9ce7a" , "r010-3fcd9fe7-d4a7-41ce-8bb3-d96e936b2c7e" ]
	EOF
	validation {
		condition     = var.SSH_KEYS == [] ? false : true && var.SSH_KEYS == [""] ? false : true
		error_message = "At least one SSH KEY is needed to be able to access the VSI."
	}
}

variable "BASTION_FLOATING_IP" {
	type		= string
	description = <<EOF
    Input the FLOATING IP from the Bastion Server
	EOF
	nullable = false
	validation {
        condition = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$",var.BASTION_FLOATING_IP)) || contains(["localhost"], var.BASTION_FLOATING_IP ) && var.BASTION_FLOATING_IP!= null
        error_message = "Incorrect format for variable: BASTION_FLOATING_IP."
      }
}

variable "RESOURCE_GROUP" {
  	type        = string
  	description = <<EOF
  	The name of an EXISTING Resource Group for VSIs and Volumes resources.
  	Default value: "Default". The list of Resource Groups is available here https://cloud.ibm.com/account/resource-groups
	EOF
  	default     = "Default"
}

variable "REGION" {
	type		= string
	description	= 	<<EOF
	The cloud region where to deploy the solution.
    The regions and zones for VPC are listed here https://cloud.ibm.com/docs/containers?topic=containers-regions-and-zones#zones-vpc 
    Review supported locations in IBM Cloud Schematics here https://cloud.ibm.com/docs/containers?topic=containers-regions-and-zones#zones-vpc
    Sample value: eu-de.
	EOF
	validation {
		condition     = contains(["au-syd", "jp-osa", "jp-tok", "eu-de", "eu-gb", "ca-tor", "us-south", "us-east", "br-sao"], var.REGION )
		error_message = "For CLI deployments, the REGION must be one of: au-syd, jp-osa, jp-tok, eu-de, eu-gb, ca-tor, us-south, us-east, br-sao. \n For Schematics, the REGION must be one of: eu-de, eu-gb, us-south, us-east."
	}
}

variable "ZONE" {
	type		= string
	description	= 	<<EOF
    The cloud zone where to deploy the solution.
    Sample value: eu-de-2.
	EOF
	validation {
		condition     = length(regexall("^(au-syd|jp-osa|jp-tok|eu-de|eu-gb|ca-tor|us-south|us-east|br-sao)-(1|2|3)$", var.ZONE)) > 0
		error_message = "The ZONE is not valid."
	}
}

variable "VPC" {
	type		= string
	description = 	<<EOF
    The name of an EXISTING VPC. The list of VPCs is available here https://cloud.ibm.com/vpc-ext/network/vpcs
	EOF
	default = "sap"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.VPC)) > 0
		error_message = "The VPC name is not valid."
	}
}

variable "SUBNET" {
	type		= string
	description = 	<<EOF
    The name of an EXISTING Subnet. The list of Subnets is available here https://cloud.ibm.com/vpc-ext/network/subnets
	EOF
	default		= "sap-subnet"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.SUBNET)) > 0
		error_message = "The SUBNET name is not valid."
	}
}

variable "SECURITY_GROUP" {
	type		= string
	description = <<EOF
	The name of an EXISTING Security group. The list of Security Groups is available here https://cloud.ibm.com/vpc-ext/network/securityGroups
	EOF
	default = "sap-securitygroup"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.SECURITY_GROUP)) > 0
		error_message = "The SECURITY_GROUP name is not valid."
	}
}

variable "HOSTNAME" {
	type		= string
	description = 	<<EOF
	The Hostname for the VSI. The hostname should be up to 13 characters as required by SAP. For more information on rules regarding hostnames for SAP systems, check SAP Note 611361: Hostnames of SAP ABAP Platform servers
	EOF
	default		= "db2saphost1"	
	validation {
		condition     = length(var.HOSTNAME) <= 13 && length(regexall("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$", var.HOSTNAME)) > 0
		error_message = "The HOSTNAME is not valid."
	}
}

variable "PROFILE" {
	type		= string
	description = <<EOF
    A list of profiles is available here https://cloud.ibm.com/docs/vpc?topic=vpc-profiles
    For more information about supported DB/OS and IBM Gen 2 Virtual Server Instances (VSI), check SAP Note 2927211: SAP Applications on IBM Virtual Private Cloud
	Default value: "bx2-4x16"
	EOF
	default		= "bx2-4x16"
}

variable "IMAGE" {
	type		= string
	description = 	<<EOF
	The OS image used for the VSI. A list of images is available here https://cloud.ibm.com/docs/vpc?topic=vpc-about-images
	Supported images: ibm-sles-15-3-amd64-sap-applications-5, ibm-redhat-8-4-amd64-sap-applications-4, ibm-redhat-7-6-amd64-sap-applications-3. Default value: ibm-redhat-8-4-amd64-sap-applications-4
	EOF
	default		= "ibm-redhat-8-4-amd64-sap-applications-4"
	validation {
		condition     = length(regexall("^(ibm-redhat-7-6-amd64-sap-applications|ibm-redhat-8-4-amd64-sap-applications|ibm-sles-15-3-amd64-sap-applications)-[0-9][0-9]*", var.IMAGE)) > 0
		error_message = "The OS SAP IMAGE must be one of  \"ibm-sles-15-3-amd64-sap-applications-x\", \"ibm-redhat-8-4-amd64-sap-applications-x\" or \"ibm-redhat-7-6-amd64-sap-applications-x\"."
	}
}

data "ibm_is_instance" "vsi" {
  depends_on = [module.vsi]
  name    =  var.HOSTNAME
}

variable "sap_sid" {
	type		= string
	description =	<<EOF
	The SAP system ID identifies the entire SAP system.
	Default value: DB1
	EOF
	default		= "DB2"
	validation {
		condition     = length(regexall("^[a-zA-Z][a-zA-Z0-9][a-zA-Z0-9]$", var.sap_sid)) > 0 && !contains(["ADD", "ALL", "AMD", "AND", "ANY", "ARE", "ASC", "AUX", "AVG", "BIT", "CDC", "COM", "CON", "DBA", "END", "EPS", "FOR", "GET", "GID", "IBM", "INT", "KEY", "LOG", "LPT", "MAP", "MAX", "MIN", "MON", "NIX", "NOT", "NUL", "OFF", "OLD", "OMS", "OUT", "PAD", "PRN", "RAW", "REF", "ROW", "SAP", "SET", "SGA", "SHG", "SID", "SQL", "SUM", "SYS", "TMP", "TOP", "UID", "USE", "USR", "VAR"], var.sap_sid)
		error_message = "The sap_sid is not valid."
	}
}

variable "sap_ci_instance_number" {
	type		= string
	description = <<EOF
	Technical identifier for internal processes of CI.
	Default value: 00
	EOF
	default		= "00"
	validation {
		condition     = var.sap_ci_instance_number >= 0 && var.sap_ci_instance_number <=97
		error_message = "The sap_ci_instance_number is not valid."
	}
}

variable "sap_ascs_instance_number" {
	type		= string
	description =<<EOF
	Technical identifier for internal processes of ASCS.
	Default value: 01
	EOF
	default		= "01"
	validation {
		condition     = var.sap_ascs_instance_number >= 0 && var.sap_ascs_instance_number <=97
		error_message = "The sap_ascs_instance_number is not valid."
	}
}

variable "sap_main_password" {
	type		= string
	sensitive = true
	description = 	<<EOF
	Common password for all users that are created during the installation. (Sensitive* value).
	EOF
	validation {
		condition     = length(regexall("^(.{0,9}|.{15,}|[^0-9]*)$", var.sap_main_password)) == 0 && length(regexall("^[^0-9_][0-9a-zA-Z@#$_]+$", var.sap_main_password)) > 0
		error_message = "The sap_main_password is not valid."
	}
}

variable "kit_sapcar_file" {
	type		= string
	description = 	<<EOF
	Path to sapcar binary, as downloaded from SAP Support Portal.
	EOF
	default		= "/storage/NW75DB2/SAPCAR_1010-70006178.EXE"
}

variable "kit_swpm_file" {
	type		= string
	description = 	<<EOF
	Path to SWPM archive (SAR), as downloaded from SAP Support Portal.
	EOF
	default		= "/storage/NW75DB2/SWPM10SP37_2-20009701.SAR"
}

variable "kit_saphotagent_file" {
	type		= string
	description = 	<<EOF
	Path to SAP Host Agent archive (SAR), as downloaded from SAP Support Portal.
	EOF
	default		= "/storage/NW75DB2/SAPHOSTAGENT51_51-20009394.SAR"
}

variable "kit_sapexe_file" {
	type		= string
	description = 	<<EOF
	Path to SAP Kernel OS archive (SAR), as downloaded from SAP Support Portal.
	EOF
	default		= "/storage/NW75DB2/SAPEXE_800-80002573.SAR"
}

variable "kit_sapexedb_file" {
	type		= string
	description = 	<<EOF
	Path to SAP Kernel DB archive (SAR), as downloaded from SAP Support Portal.
	EOF
	default		= "/storage/NW75DB2/SAPEXEDB_800-80002603.SAR"
}

variable "kit_igsexe_file" {
	type		= string
	description = 	<<EOF
	Path to IGS archive (SAR), as downloaded from SAP Support Portal.
	EOF
	default		= "/storage/NW75DB2/igsexe_13-80003187.sar"
}

variable "kit_igshelper_file" {
	type		= string
	description = 	<<EOF
	Path to IGS Helper archive (SAR), as downloaded from SAP Support Portal.
	EOF
	default		= "/storage/NW75DB2/igshelper_17-10010245.sar"
}

variable "kit_export_dir" {
	type		= string
	description = 	<<EOF
	Path to NW 7.5 Installation Export dir.
	The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file
	EOF
	default		= "/storage/NW75DB2/51050829"
}

variable "kit_db2_dir" {
	type		= string
	description = 	<<EOF
	Path to DB2 LUW 11.5 MP6 FP0 SAP2 Linux on x86_64 64bit dir for Red Hat 8.4 and Suse 15 SP3 and path to DB2 LUW 10.5 FP7SAP2 Linux on x86_64 64bit dir for Red Hat 7.6
	The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file. Default value: /storage/NW75DB2/51055138/DB2_FOR_LUW_11.5_MP6_FP0SAP2_LINUX_
	EOF
	default		= "/storage/NW75DB2/51055138/DB2_FOR_LUW_11.5_MP6_FP0SAP2_LINUX_"
}

variable "kit_db2client_dir" {
	type		= string
	description = 	<<EOF
	Path to DB2 LUW 11.5 MP6 FP0 SAP2 RDBMS Client dir for Red Hat 8.4 and Suse 15 SP3 and path to DB2 LUW 10.5 FP7SAP2 RDBMS Client dir for Red Hat 7.6
	The archive downloaded from SAP Support Portal must be extracted and the path provided to this parameter must contain LABEL.ASC file. Default value: /storage/NW75DB2/51055140	
	EOF
	default		= "/storage/NW75DB2/51055140"
}

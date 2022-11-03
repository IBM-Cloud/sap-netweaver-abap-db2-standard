variable "SSH_KEYS" {
	type		= list(string)
	description = "SSH Keys ID list to access the VSI"
	validation {
		condition     = var.SSH_KEYS == [] ? false : true && var.SSH_KEYS == [""] ? false : true
		error_message = "At least one SSH KEY is needed to be able to access the VSI."
	}
}

variable "REGION" {
	type		= string
	description	= "Cloud Region"
	validation {
		condition     = contains(["au-syd", "jp-osa", "jp-tok", "eu-de", "eu-gb", "ca-tor", "us-south", "us-east", "br-sao"], var.REGION )
		error_message = "The REGION must be one of: au-syd, jp-osa, jp-tok, eu-de, eu-gb, ca-tor, us-south, us-east, br-sao."
	}
}

variable "ZONE" {
	type		= string
	description	= "Cloud Zone"
	validation {
		condition     = length(regexall("^(eu-de|eu-gb|us-south|us-east)-(1|2|3)$", var.ZONE)) > 0
		error_message = "The ZONE is not valid."
	}
}

variable "VPC" {
	type		= string
	description = "EXISTING VPC name"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.VPC)) > 0
		error_message = "The VPC name is not valid."
	}
}

variable "SUBNET" {
	type		= string
	description = "EXISTING Subnet name"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.SUBNET)) > 0
		error_message = "The SUBNET name is not valid."
	}
}

variable "SECURITY_GROUP" {
	type		= string
	description = "EXISTING Security group name"
	validation {
		condition     = length(regexall("^([a-z]|[a-z][-a-z0-9]*[a-z0-9]|[0-9][-a-z0-9]*([a-z]|[-a-z][-a-z0-9]*[a-z0-9]))$", var.SECURITY_GROUP)) > 0
		error_message = "The SECURITY_GROUP name is not valid."
	}
}

variable "RESOURCE_GROUP" {
  type        = string
  description = "EXISTING Resource Group for VSI and volumes"
  default     = "Default"
}

variable "HOSTNAME" {
	type		= string
	description = "VSI Hostname"
	validation {
		condition     = length(var.HOSTNAME) <= 13 && length(regexall("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$", var.HOSTNAME)) > 0
		error_message = "The HOSTNAME is not valid."
	}
}

variable "PROFILE" {
	type		= string
	description = "VSI Profile"
	default		= "bx2-4x16"
}

variable "IMAGE" {
	type		= string
	description = "VSI OS Image"
	default		= "ibm-redhat-8-4-amd64-sap-applications-4"
	validation {
		condition     = length(regexall("^(ibm-redhat-7-6-amd64-sap-applications|ibm-redhat-8-4-amd64-sap-applications|ibm-sles-15-3-amd64-sap-applications)-[0-9][0-9]*", var.IMAGE)) > 0
		error_message = "The OS SAP IMAGE must be one of  \"ibm-sles-15-3-amd64-sap-applications-x\", \"ibm-redhat-8-4-amd64-sap-applications-x\" or \"ibm-redhat-7-6-amd64-sap-applications-x\"."
	}
}

variable "VOL1" {
	type		= string
	description = "Volume 1 Size"
	default		= "40"
}

variable "VOL2" {
	type		= string
	description = "Volume 2 Size"
	default		= "32"
}

variable "VOL3" {
	type		= string
	description = "Volume 3 Size"
	default		= "64"
}

variable "VOL4" {
	type		= string
	description = "Volume 4 Size"
	default		= "128"
}

variable "VOL5" {
	type		= string
	description = "Volume 5 Size"
	default		= "256"
}


variable "sap_sid" {
	type		= string
	description = "sap_sid"
	default		= "DB1"
}

variable "sap_ci_instance_number" {
	type		= string
	description = "sap_ci_instance_number"
	default		= "00"
}

variable "sap_ascs_instance_number" {
	type		= string
	description = "sap_ascs_instance_number"
	default		= "01"
}

variable "sap_main_password" {
	type		= string
	sensitive = true
	description = "sap_main_password"
	validation {
		condition     = length(regexall("^(.{0,9}|.{15,}|[^0-9]*)$", var.sap_main_password)) == 0 && length(regexall("^[^0-9_][0-9a-zA-Z@#$_]+$", var.sap_main_password)) > 0
		error_message = "The sap_main_password is not valid."
	}
}

variable "kit_sapcar_file" {
	type		= string
	description = "kit_sapcar_file"
	default		= "/storage/NW75DB2/SAPCAR_1010-70006178.EXE"
}

variable "kit_swpm_file" {
	type		= string
	description = "kit_swpm_file"
	default		= "/storage/NW75DB2/SWPM10SP31_7-20009701.SAR"
}

variable "kit_saphotagent_file" {
	type		= string
	description = "kit_saphotagent_file"
	default		= "/storage/NW75DB2/SAPHOSTAGENT51_51-20009394.SAR"
}

variable "kit_sapexe_file" {
	type		= string
	description = "kit_sapexe_file"
	default		= "/storage/NW75DB2/SAPEXE_800-80002573.SAR"
}

variable "kit_sapexedb_file" {
	type		= string
	description = "kit_sapexedb_file"
	default		= "/storage/NW75DB2/SAPEXEDB_800-80002603.SAR"
}

variable "kit_igsexe_file" {
	type		= string
	description = "kit_igsexe_file"
	default		= "/storage/NW75DB2/igsexe_13-80003187.sar"
}

variable "kit_igshelper_file" {
	type		= string
	description = "kit_igshelper_file"
	default		= "/storage/NW75DB2/igshelper_17-10010245.sar"
}

variable "kit_export_dir" {
	type		= string
	description = "kit_export_dir"
	default		= "/storage/NW75DB2/51050829"
}

variable "kit_db2_dir" {
	type		= string
	description = "kit_db2_dir"
	default		= "/storage/NW75DB2/51055138/DB2_FOR_LUW_11.5_MP6_FP0SAP2_LINUX_"
}

variable "kit_db2client_dir" {
	type		= string
	description = "kit_db2client_dir"
	default		= "/storage/NW75DB2/51055140"
}

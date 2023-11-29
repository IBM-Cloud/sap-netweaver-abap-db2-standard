module "pre-init-schematics" {
  source  = "./modules/pre-init"
  count = (var.PRIVATE_SSH_KEY == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 0 : 1)
  ID_RSA_FILE_PATH = var.ID_RSA_FILE_PATH
  PRIVATE_SSH_KEY = var.PRIVATE_SSH_KEY
}

module "pre-init-cli" {
  source  = "./modules/pre-init/cli"
  count = (var.PRIVATE_SSH_KEY == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 1 : 0)
  ID_RSA_FILE_PATH = var.ID_RSA_FILE_PATH
  KIT_SAPCAR_FILE = var.KIT_SAPCAR_FILE
  KIT_SWPM_FILE = var.KIT_SWPM_FILE
  KIT_SAPHOSTAGENT_FILE = var.KIT_SAPHOSTAGENT_FILE
  KIT_SAPEXE_FILE = var.KIT_SAPEXE_FILE
  KIT_SAPEXEDB_FILE = var.KIT_SAPEXEDB_FILE
  KIT_IGSEXE_FILE = var.KIT_IGSEXE_FILE
  KIT_IGSHELPER_FILE = var.KIT_IGSHELPER_FILE
  KIT_EXPORT_DIR = var.KIT_EXPORT_DIR
  KIT_DB2_DIR = var.KIT_DB2_DIR
  KIT_DB2CLIENT_DIR = var.KIT_DB2CLIENT_DIR
}

module "precheck-ssh-exec" {
  source  = "./modules/precheck-ssh-exec"
  count = (var.PRIVATE_SSH_KEY == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 0 : 1)
  depends_on	= [ module.pre-init-schematics ]
  BASTION_FLOATING_IP = var.BASTION_FLOATING_IP
  ID_RSA_FILE_PATH = var.ID_RSA_FILE_PATH
  PRIVATE_SSH_KEY = var.PRIVATE_SSH_KEY
  HOSTNAME  = var.HOSTNAME
  SECURITY_GROUP = var.SECURITY_GROUP
  
}

module "vpc-subnet" {
  source  = "./modules/vpc/subnet"
  depends_on	= [ module.precheck-ssh-exec ]
  ZONE  = var.ZONE
  VPC = var.VPC
  SECURITY_GROUP = var.SECURITY_GROUP
  SUBNET  = var.SUBNET
}

module "volumes" {
  source  = "./modules/volumes"
  depends_on	= [ module.pre-init-schematics, module.pre-init-cli ]
  ZONE  = var.ZONE
  HOSTNAME  = var.HOSTNAME
  RESOURCE_GROUP = var.RESOURCE_GROUP
}

module "vsi" {
  source  = "./modules/vsi"
  depends_on	= [ module.volumes ]
  ZONE  = var.ZONE
  VPC = var.VPC
  SECURITY_GROUP = var.SECURITY_GROUP
  SUBNET  = var.SUBNET
  HOSTNAME  = var.HOSTNAME
  PROFILE = var.PROFILE
  IMAGE = var.IMAGE
  RESOURCE_GROUP = var.RESOURCE_GROUP
  SSH_KEYS  = var.SSH_KEYS
  VOLUMES_LIST	= module.volumes.volumes_list
  SAP_SID = var.SAP_SID
}

module "app-ansible-exec-schematics" {
  source  = "./modules/ansible-exec"
  depends_on	= [ module.vsi , local_file.ansible_inventory , local_file.app_ansible-vars ]
  count = (var.PRIVATE_SSH_KEY == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 0 : 1)
  IP  = data.ibm_is_instance.vsi.primary_network_interface[0].primary_ip[0].address
  PLAYBOOK = "sap-abap-db2-standard.yml"
  BASTION_FLOATING_IP = var.BASTION_FLOATING_IP
  ID_RSA_FILE_PATH = var.ID_RSA_FILE_PATH
  PRIVATE_SSH_KEY = var.PRIVATE_SSH_KEY
  
}

module "ansible-exec-cli" {
  source  = "./modules/ansible-exec/cli"
  depends_on	= [ module.vsi , local_file.ansible_inventory , local_file.app_ansible-vars, module.pre-init-cli]
  count = (var.PRIVATE_SSH_KEY == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 1 : 0)
  IP  = data.ibm_is_instance.vsi.primary_network_interface[0].primary_ip[0].address
  ID_RSA_FILE_PATH = var.ID_RSA_FILE_PATH
  sap_main_password = var.SAP_MAIN_PASSWORD
  PLAYBOOK = "sap-abap-db2-standard.yml"
}

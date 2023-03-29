module "pre-init" {
  source  = "./modules/pre-init"
  count = (var.private_ssh_key == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 0 : 1)
}

module "precheck-ssh-exec" {
  source  = "./modules/precheck-ssh-exec"
  count = (var.private_ssh_key == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 0 : 1)
  depends_on	= [ module.pre-init ]
  BASTION_FLOATING_IP = var.BASTION_FLOATING_IP
  private_ssh_key = var.private_ssh_key
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
  depends_on	= [ module.precheck-ssh-exec ]
  ZONE  = var.ZONE
  HOSTNAME  = var.HOSTNAME
  RESOURCE_GROUP = var.RESOURCE_GROUP
}

module "vsi" {
  source  = "./modules/vsi"
  depends_on	= [ module.volumes , module.precheck-ssh-exec ]
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
  SAP_SID = var.sap_sid
}

module "app-ansible-exec-schematics" {
  source  = "./modules/ansible-exec"
  count = (var.private_ssh_key == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 0 : 1)
  depends_on	= [ module.vsi , local_file.ansible_inventory , local_file.app_ansible-vars ]
  IP  = data.ibm_is_instance.vsi.primary_network_interface[0].primary_ip[0].address
  PLAYBOOK = "playbook.yml"
  BASTION_FLOATING_IP = var.BASTION_FLOATING_IP
  private_ssh_key = var.private_ssh_key
  
}

module "ansible-exec-cli" {
  source  = "./modules/ansible-exec/cli"
  count = (var.private_ssh_key == "n.a" && var.BASTION_FLOATING_IP == "localhost" ? 1 : 0)
  depends_on	= [ module.vsi , local_file.ansible_inventory , local_file.app_ansible-vars  ]
  IP  = data.ibm_is_instance.vsi.primary_network_interface[0].primary_ip[0].address
  sap_main_password = var.sap_main_password
  kit_sapcar_file=var.kit_sapcar_file
  kit_swpm_file=var.kit_swpm_file
  kit_saphotagent_file=var.kit_saphotagent_file
  kit_sapexe_file=var.kit_sapexe_file
  kit_sapexedb_file=var.kit_sapexedb_file
  kit_igsexe_file=var.kit_igsexe_file
  kit_igshelper_file=var.kit_igshelper_file
}



module "pre-init" {
  source		= "./modules/pre-init"
}

module "precheck-ssh-exec" {
  source		= "./modules/precheck-ssh-exec"
  depends_on	= [ module.pre-init ]
  BASTION_FLOATING_IP = var.BASTION_FLOATING_IP
  private_ssh_key = var.private_ssh_key
  HOSTNAME		= var.HOSTNAME
  SECURITY_GROUP = var.SECURITY_GROUP
}

module "vpc-subnet" {
  source		= "./modules/vpc/subnet"
  depends_on	= [ module.precheck-ssh-exec ]
  ZONE			= var.ZONE
  VPC			= var.VPC
  SECURITY_GROUP = var.SECURITY_GROUP
  SUBNET		= var.SUBNET
}

module "volumes" {
  source		= "./modules/volumes"
  depends_on	= [ module.precheck-ssh-exec ]
  ZONE			= var.ZONE
  HOSTNAME		= var.HOSTNAME
  RESOURCE_GROUP = var.RESOURCE_GROUP
}

module "vsi" {
  source		= "./modules/vsi"
  depends_on	= [ module.volumes , module.precheck-ssh-exec ]
  ZONE			= var.ZONE
  VPC			= var.VPC
  SECURITY_GROUP = var.SECURITY_GROUP
  SUBNET		= var.SUBNET
  HOSTNAME		= var.HOSTNAME
  PROFILE		= var.PROFILE
  IMAGE			= var.IMAGE
  RESOURCE_GROUP = var.RESOURCE_GROUP
  SSH_KEYS		= var.SSH_KEYS
  VOLUMES_LIST	= module.volumes.volumes_list
  SAP_SID		= var.sap_sid
}

module "app-ansible-exec" {
  source		= "./modules/ansible-exec"
  depends_on	= [ module.vsi , local_file.app_ansible-vars ]
  IP			= module.vsi.PRIVATE-IP
  PLAYBOOK = "sapnwdb2.yml"
  BASTION_FLOATING_IP = var.BASTION_FLOATING_IP
  private_ssh_key = var.private_ssh_key
}

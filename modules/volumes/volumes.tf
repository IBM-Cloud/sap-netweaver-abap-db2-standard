data "ibm_resource_group" "group" {
  name		= var.RESOURCE_GROUP
}

resource "ibm_is_volume" "vol1" {
  name		= "${var.HOSTNAME}-vol1"
  profile	= "10iops-tier"
  zone		= var.ZONE
  resource_group = data.ibm_resource_group.group.id
  capacity	= local.VOL1
}

resource "ibm_is_volume" "vol2" {
  name		= "${var.HOSTNAME}-vol2"
  profile	= "10iops-tier"
  zone		= var.ZONE
  resource_group = data.ibm_resource_group.group.id
  capacity	= local.VOL2
}

resource "ibm_is_volume" "vol3" {
  name		= "${var.HOSTNAME}-vol3"
  profile	= "10iops-tier"
  zone		= var.ZONE
  resource_group = data.ibm_resource_group.group.id
  capacity	= local.VOL3
}

resource "ibm_is_volume" "vol4" {
  name		= "${var.HOSTNAME}-vol4"
  profile	= "10iops-tier"
  zone		= var.ZONE
  resource_group = data.ibm_resource_group.group.id
  capacity	= local.VOL4
}

resource "ibm_is_volume" "vol5" {
  name		= "${var.HOSTNAME}-vol5"
  profile	= "10iops-tier"
  zone		= var.ZONE
  resource_group = data.ibm_resource_group.group.id
  capacity	= local.VOL5
}

output "volumes_list" {
  value       = [ ibm_is_volume.vol1.id , ibm_is_volume.vol2.id , ibm_is_volume.vol3.id , ibm_is_volume.vol4.id , ibm_is_volume.vol5.id ]
}

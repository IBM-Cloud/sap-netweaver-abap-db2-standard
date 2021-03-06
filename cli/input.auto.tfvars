#Infra VPC variables
REGION = "eu-de"
ZONE = "eu-de-3"
VPC = "ic4sap" # EXISTING Security group name
SECURITY_GROUP = "ic4sap-securitygroup" # EXISTING Security group name
SUBNET = "ic4sap-fra3" # EXISTING Subnet name
HOSTNAME = "db2sapm1"
PROFILE = "bx2-4x16"
IMAGE = "ibm-redhat-7-6-amd64-sap-applications-3"
RESOURCE_GROUP = "wes-automation" # EXISTING Resource Group for VSI and volumes
SSH_KEYS = [ "r010-57bfc315-f9e5-46bf-bf61-d87a24a9ce7a" , "r010-3fcd9fe7-d4a7-41ce-8bb3-d96e936b2c7e" ]

##SAP system configuration
sap_sid	= "DB1"
sap_ci_instance_number = "00"
sap_ascs_instance_number = "01"

#Kits paths
kit_sapcar_file = "/storage/NW75DB2/SAPCAR_1010-70006178.EXE"
kit_swpm_file =  "/storage/NW75DB2/SWPM10SP31_7-20009701.SAR"
kit_saphotagent_file = "/storage/NW75DB2/SAPHOSTAGENT51_51-20009394.SAR"
kit_sapexe_file = "/storage/NW75DB2/SAPEXE_800-80002573.SAR"
kit_sapexedb_file = "/storage/NW75DB2/SAPEXEDB_800-80002603.SAR"
kit_igsexe_file = "/storage/NW75DB2/igsexe_13-80003187.sar"
kit_igshelper_file = "/storage/NW75DB2/igshelper_17-10010245.sar"
kit_export_dir = "/storage/NW75DB2/51050829"
kit_db2_dir = "/storage/NW75DB2/51051007/DB2_FOR_LUW_10.5_FP7SAP2_LINUX_"
kit_db2client_dir = "/storage/NW75DB2/51051049"

# Generate SAP PATHS
resource "local_file" "sap_paths" {
  content = <<-DOC
${var.KIT_SAPCAR_FILE}
${var.KIT_SWPM_FILE}
${var.KIT_SAPHOSTAGENT_FILE}
${var.KIT_SAPEXE_FILE}
${var.KIT_SAPEXEDB_FILE}
${var.KIT_IGSEXE_FILE}
${var.KIT_IGSHELPER_FILE}
${var.KIT_EXPORT_DIR}/*.*
${var.KIT_DB2_DIR}/*.*
${var.KIT_DB2CLIENT_DIR}/*.*

    DOC
  filename = "modules/precheck-ssh-exec/sap-paths-${var.HOSTNAME}"
}

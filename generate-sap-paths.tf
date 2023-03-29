# Generate SAP PATHS
resource "local_file" "sap_paths" {
  content = <<-DOC
${var.kit_sapcar_file}
${var.kit_swpm_file}
${var.kit_saphotagent_file}
${var.kit_sapexe_file}
${var.kit_sapexedb_file}
${var.kit_igsexe_file}
${var.kit_igshelper_file}
${var.kit_export_dir}/*.*
${var.kit_db2_dir}/*.*
${var.kit_db2client_dir}/*.*

    DOC
  filename = "modules/precheck-ssh-exec/sap-paths-${var.HOSTNAME}"
}

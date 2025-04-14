resource "aws_glue_job" "alter_table_job" {
  name         = "${var.project}-alter-table-job"
  role_arn     = var.glue_role_arn
  glue_version = "4.0"

  command {
    name            = "glueetl"
    script_location = "s3://${var.scripts_bucket_name}/de_c3w2a1_alter_ratings_table.py"
    python_version  = 3
  }

  default_arguments = {
    "--enable-job-insights" = "true"
    "--job-language"        = "python"
    "--lakehouse_path"      = "s3://${var.data_lake_name}/"
    "--database_name"       = var.curated_db_name
    "--table_name"          = var.curated_db_ratings_table
    "--column_name"         = var.ratings_new_column_name
    "--column_type"         = var.ratings_new_column_type
    "--datalake-formats"    = "iceberg"
  }

  timeout = 5

  number_of_workers = 2
  worker_type       = "G.1X"
}

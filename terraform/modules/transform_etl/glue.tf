resource "aws_glue_job" "ratings_transformation_job" {
  name         = "${var.project}-ratings-transformation-job"
  role_arn     = var.glue_role_arn
  glue_version = "4.0"

  command {
    name            = "glueetl"
    script_location = "s3://${var.scripts_bucket_name}/de_c3w2a1_json_transform.py"
    python_version  = 3
  }

  default_arguments = {
    "--enable-job-insights" = "true"
    "--job-language"        = "python"
    "--data_lake_bucket"    = var.data_lake_name
    "--database_name"       = var.curated_db_name
    "--ml_table"            = var.curated_db_ml_table
    "--lakehouse_path"      = "s3://${var.data_lake_name}/"
    "--datalake-formats"    = "iceberg"
  }

  timeout = 7

  number_of_workers = 2
  worker_type       = "G.1X"
}

resource "aws_glue_job" "csv_transformation_job" {
  name         = "${var.project}-csv-transformation-job"
  role_arn     = var.glue_role_arn
  glue_version = "4.0"

  command {
    name            = "glueetl"
    script_location = "s3://${var.scripts_bucket_name}/de_c3w2a1_batch_transform.py"
    python_version  = 3
  }

  default_arguments = {
    "--enable-job-insights" = "true"
    "--job-language"        = "python"
    "--data_lake_bucket"    = var.data_lake_name
  }

  timeout = 5

  number_of_workers = 2
  worker_type       = "G.1X"
}


resource "aws_glue_job" "ratings_to_iceberg_job" {
  name         = "${var.project}-ratings-to-iceberg-job"
  role_arn     = var.glue_role_arn
  glue_version = "4.0"

  command {
    name            = "glueetl"
    script_location = "s3://${var.scripts_bucket_name}/de_c3w2a1_ratings_to_iceberg.py"
    python_version  = 3
  }

  default_arguments = {
    "--enable-job-insights" = "true"
    "--job-language"        = "python"
    "--data_lake_bucket"    = var.data_lake_name
    "--database_name"       = var.curated_db_name
    "--table_name"          = var.curated_db_ratings_table
    "--lakehouse_path"      = "s3://${var.data_lake_name}/"
    "--datalake-formats"                  = "iceberg"
  }

  timeout = 7

  number_of_workers = 2
  worker_type       = "G.1X"
}

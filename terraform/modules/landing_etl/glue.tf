resource "aws_glue_connection" "rds_connection" {
  name = "${var.project}-rds-connection"

  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:mysql://${var.host}:${var.port}/${var.database}"
    USERNAME            = var.username
    PASSWORD            = var.password
  }

  physical_connection_requirements {
    availability_zone      = data.aws_subnet.public_a.availability_zone
    security_group_id_list = [data.aws_security_group.db_sg.id]
    subnet_id              = data.aws_subnet.public_a.id
  }
}


resource "aws_glue_job" "rds_ingestion_etl_job" {
  name         = "${var.project}-rds-ingestion-etl-job"
  role_arn     = data.aws_iam_role.glue_role.arn
  glue_version = "4.0"
  connections  = [aws_glue_connection.rds_connection.name]
  command {
    name            = "glueetl"
    script_location = "s3://${var.scripts_bucket_name}/de_c3w2a1_batch_ingress.py"
    python_version  = 3
  }

  default_arguments = {
    "--enable-job-insights" = "true"
    "--job-language"        = "python"
    "--rds_connection"      = aws_glue_connection.rds_connection.name
    "--data_lake_bucket"    = var.data_lake_name
    "--target_path"         = "s3://${var.data_lake_name}"
  }

  timeout = 5

  number_of_workers = 2
  worker_type       = "G.1X"
}

resource "aws_glue_job" "bucket_ingestion_etl_job" {
  name         = "${var.project}-bucket-ingestion-etl-job"
  role_arn     = data.aws_iam_role.glue_role.arn
  glue_version = "4.0"
  connections  = [aws_glue_connection.rds_connection.name]
  command {
    name            = "glueetl"
    script_location = "s3://${var.scripts_bucket_name}/de_c3w2a1_json_ingress.py"
    python_version  = 3
  }

  default_arguments = {
    "--enable-job-insights"     = "true"
    "--job-language"            = "python"
    "--source_data_lake_bucket" = var.source_data_lake_name
    "--dest_data_lake_bucket"   = var.data_lake_name
    "--target_path"             = "s3://${var.data_lake_name}"
  }

  timeout = 5

  number_of_workers = 2
  worker_type       = "G.1X"
}

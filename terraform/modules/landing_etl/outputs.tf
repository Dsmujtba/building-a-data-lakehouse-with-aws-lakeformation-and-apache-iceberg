output "glue_role_arn" {
  value = data.aws_iam_role.glue_role.arn
}

output "glue_bucket_ingestion_job" {
  value = aws_glue_job.bucket_ingestion_etl_job.name
}

output "glue_rds_ingestion_job" {
  value = aws_glue_job.rds_ingestion_etl_job.name
}

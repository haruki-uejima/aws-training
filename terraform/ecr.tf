resource "aws_ecr_repository" "ecr_repository" {
  name         = "example-repository"
  force_delete = true
}

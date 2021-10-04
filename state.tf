resource "aws_s3_bucket" "terraform-state" {
  bucket = "egp-terraform-state"
  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform-state" {
  name           = "terraform-state"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

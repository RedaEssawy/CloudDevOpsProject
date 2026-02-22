resource "aws_dynamodb_table" "state-locking" {
    name         = "state-locking"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }

    tags = {
        Name        = "State-Locking"
    }
  
}
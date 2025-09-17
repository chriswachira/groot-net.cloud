/*
DynamoDB is used to store cluster state, event
metadata, and a simple locking mechanism for SSL
cert generation and renewal.
*/

// DynamoDB table for storing cluster state
resource "aws_dynamodb_table" "groot_net_teleport_cluster_state_table" {
  name           = "groot-net.cloud-teleport-cluster-state"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "HashKey"
  range_key      = "FullPath"

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }

  attribute {
    name = "HashKey"
    type = "S"
  }

  attribute {
    name = "FullPath"
    type = "S"
  }

  stream_enabled   = "true"
  stream_view_type = "NEW_IMAGE"

  ttl {
    attribute_name = "Expires"
    enabled        = true
  }

  tags = {
    TeleportCluster = "groot-net.cloud"
  }
}

// DynamoDB table for storing cluster events
resource "aws_dynamodb_table" "groot_net_teleport_cluster_events_table" {
  name           = "groot-net.cloud-teleport-cluster-events"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "SessionID"
  range_key      = "EventIndex"

  // For demo purposes, CMK isn't necessary
  // tfsec:ignore:aws-dynamodb-table-customer-key
  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }

  global_secondary_index {
    name            = "timesearchV2"
    hash_key        = "CreatedAtDate"
    range_key       = "CreatedAt"
    write_capacity  = 10
    read_capacity   = 10
    projection_type = "ALL"
  }

  lifecycle {
    ignore_changes = all
  }

  attribute {
    name = "SessionID"
    type = "S"
  }

  attribute {
    name = "EventIndex"
    type = "N"
  }

  attribute {
    name = "CreatedAtDate"
    type = "S"
  }

  attribute {
    name = "CreatedAt"
    type = "N"
  }

  ttl {
    attribute_name = "Expires"
    enabled        = true
  }

  tags = {
    TeleportCluster = "groot-net.cloud"
  }
}

// DynamoDB table for simple locking mechanism
resource "aws_dynamodb_table" "groot_net_teleport_cluster_locks_table" {
  name           = "groot-net.cloud_teleport_cluster_locks"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Lock"

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }

  billing_mode = "PROVISIONED"

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
    ]
  }

  attribute {
    name = "Lock"
    type = "S"
  }

  ttl {
    attribute_name = "Expires"
    enabled        = true
  }

  tags = {
    TeleportCluster = "groot-net.cloud"
  }
}

variable "region" {
  default = "us-east-1"
}

variable "tags" {
  type = object({
    Project     = string
    Environment = string
  })

  default = {
    Project     = "nsse",
    Environment = "production"
  }
}

variable "assume_role" {
  type = object({
    profile     = string,
    role_arn    = string,
    external_id = string
  })

  default = {
    role_arn    = "arn:aws:iam::322095785990:role/terraform-role"
    external_id = "4440d132-b017-4f40-a6c6-0f69b7119c31"
    profile     = "Leonardo"
  }
}

variable "queues" {
    type = list(object({
        name                      = string
        delay_seconds             = number
        max_message_size          = number
        message_retention_seconds = number
        receive_wait_time_seconds = number
        sqs_managed_sse_enabled   = bool
    }))
    default = [
    {
        name                      = "EmailNotificationQueue"
        delay_seconds             = 0
        max_message_size          = 2048
        message_retention_seconds = 86400
        receive_wait_time_seconds = 10
        sqs_managed_sse_enabled   = true
    },
    {
        name                      = "ProductStockQueue"
        delay_seconds             = 0
        max_message_size          = 2048
        message_retention_seconds = 86400
        receive_wait_time_seconds = 10
        sqs_managed_sse_enabled   = true
    },
    {
        name                      = "InvoiceQueue"
        delay_seconds             = 0
        max_message_size          = 2048
        message_retention_seconds = 86400
        receive_wait_time_seconds = 10
        sqs_managed_sse_enabled   = true
    }]
 }

 variable "dlqueues" {
  type = list(object({
    name                      = string
    delay_seconds             = number
    max_message_size          = number
    message_retention_seconds = number
    receive_wait_time_seconds = number
    sqs_managed_sse_enabled   = bool
  }))

  default = [{
    name                      = "EmailNotificationQueueDlq"
    delay_seconds             = 0
    max_message_size          = 2048
    message_retention_seconds = 86400
    receive_wait_time_seconds = 10
    sqs_managed_sse_enabled   = true
    },
    {
      name                      = "ProductStockQueueDlq"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true
    },
    {
      name                      = "InvoiceQueueDlq"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true
  }]
}

variable "order_confirmed_topic" {
  type = object({
    name                             = string,
    role_name                        = string,
    sqs_success_feedback_sample_rate = number,
    subscriptions                    = list(string)
  })

  default = {
    role_name                        = "SnsTopicRole"
    name                             = "OrderConfirmedTopic"
    sqs_success_feedback_sample_rate = 100,
    subscriptions                    = ["InvoiceQueue", "ProductStockQueue"]
  }
}

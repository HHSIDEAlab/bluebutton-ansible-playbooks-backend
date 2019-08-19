variable "cloudwatch_notification_arn" {
  description = "The CloudWatch notification ARN."
  type        = "string"
}

variable "app" {
  type        = string
}
variable "env" {
  type        = string
}
variable "rds_name" {
  type        = string
}

variable "high_cpu" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}

variable "free_storage" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}

variable "write_latency" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}

variable "read_latency" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}

variable "swap_usage" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}

variable "disk_queue_depth" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}

variable "free_memory" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}

variable "replica_lag" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}
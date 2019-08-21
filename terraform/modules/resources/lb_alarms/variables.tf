variable "load_balancer_name" {
  description = "Name of the ELB these alarms are for."
  type        = "string"
}

variable "cloudwatch_notification_arn" {
  description = "The CloudWatch notification ARN."
  type        = "string"
}

variable "app" {
  type = string
}

variable "env" {
  type = string
}

variable "healthy_hosts" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}

variable "high_latency" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}

variable "spillover_count" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}

variable "surge_queue_length" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}

variable "status_4xx" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}

variable "rate_of_5xx" {
  type    = object({period: number, eval_periods: number, threshold: number})
  default = null
}

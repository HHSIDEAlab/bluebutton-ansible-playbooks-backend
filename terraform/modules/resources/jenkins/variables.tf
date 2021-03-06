variable "env_config" {
  description = "All high-level info for the whole vpc"
  type        = object({env=string, tags=map(string), vpc_id=string, zone_id=string, azs=list(string)})
}

// variable "app_subnets" {
//   type        = list(string)
//   description = "App Subnets to use for the jenkins application"
// }

variable "vpn_security_group_id" {
  type        = string
  description = "Security group that provides access via VPN"
}

variable "ami_id" {
  type        = string
  description = "Jenkins base AMI ID to use."
}

variable "key_name" {
  type        = string
  description = "The EC2 key pair name to assign to jenkins instances"
}

variable "asg_config" {
  type        = object({min=number, max=number, desired=number, sns_topic_arn=string})
}

variable "mgmt_config" {
  type        = object({vpn_sg=string, tool_sg=string, remote_sg=string, ci_cidrs=list(string)})
}

variable "launch_config" {
  type        = object({instance_type=string, ami_id=string, key_name=string, profile=string})
}

variable "layer" {
  description = "app or data"
  type        = string      
}

variable "role" {
  type        = string
}

variable "vpc_id" {}
  
variable "lb_config" {
  description = "Load balancer information"
  type        = object({name=string, tg_arn=string, port=number})
  default     = null
}

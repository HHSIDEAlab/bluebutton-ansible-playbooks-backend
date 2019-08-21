##
#
# NOTE: This module is for defining ELB CloudWatch alarms
#
##

resource "aws_cloudwatch_metric_alarm" "healthy_hosts" {
  count               = var.healthy_hosts == null ? 0 : 1
  alarm_name          = "${var.load_balancer_name}-healthy-hosts"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.healthy_hosts.eval_periods
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ELB"
  period              = var.healthy_hosts.period
  statistic           = "Average"
  threshold           = var.healthy_hosts.threshold

  alarm_description = "No healthy hosts available for ${var.load_balancer_name} in APP-ENV: ${var.app}-${var.env}"

  dimensions = {
    LoadBalancerName = var.load_balancer_name
  }

  # We should always have a measure of the number of healthy hosts - alert if not
  treat_missing_data = "breaching"
  alarm_actions      = [var.cloudwatch_notification_arn]
  ok_actions         = [var.cloudwatch_notification_arn]
}

resource "aws_cloudwatch_metric_alarm" "high_latency" {
  count               = var.high_latency == null ? 0 : 1
  alarm_name          = "${var.load_balancer_name}-high-latency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.high_latency.eval_periods
  metric_name         = "Latency"
  namespace           = "AWS/ELB"
  period              = var.high_latency.period
  statistic           = "Average"

  dimensions = {
    LoadBalancerName = var.load_balancer_name
  }

  threshold         = var.high_latency.threshold
  unit              = "Seconds"
  alarm_description = "High latency for ELB ${var.load_balancer_name} in APP-ENV: ${var.app}-${var.env}"

  # "Missing data" means that we haven't had any measure of latency - alert if we don't
  treat_missing_data = "breaching"
  alarm_actions      = [var.cloudwatch_notification_arn]
  ok_actions         = [var.cloudwatch_notification_arn]
}

resource "aws_cloudwatch_metric_alarm" "spillover_count" {
  count               = var.spillover_count == null ? 0 : 1
  alarm_name          = "${var.load_balancer_name}-spillover-count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.spillover_count.eval_periods
  metric_name         = "SpilloverCount"
  namespace           = "AWS/ELB"
  period              = var.spillover_count.period
  statistic           = "Maximum"

  dimensions = {
    LoadBalancerName = var.load_balancer_name
  }

  threshold         = var.spillover_count.threshold
  unit              = "Count"
  alarm_description = "Spillover alarm for ELB ${var.load_balancer_name} in APP-ENV: ${var.app}-${var.env}"

  # A missing spillover count means that we haven't spillover - that's good! Don't alert.
  treat_missing_data = "notBreaching"
  alarm_actions      = [var.cloudwatch_notification_arn]
  ok_actions         = [var.cloudwatch_notification_arn]
}

resource "aws_cloudwatch_metric_alarm" "surge_queue_length" {
  count               = var.surge_queue_length == null ? 0 : 1
  alarm_name          = "${var.load_balancer_name}-surge-queue-length"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.surge_queue_length.eval_periods
  metric_name         = "SurgeQueueLength"
  namespace           = "AWS/ELB"
  period              = var.surge_queue_length.period
  statistic           = "Maximum"

  dimensions = {
    LoadBalancerName = var.load_balancer_name
  }

  threshold         = var.surge_queue_length.threshold
  unit              = "Count"
  alarm_description = "Surge queue exceeded for ELB ${var.load_balancer_name} in APP-ENV: ${var.app}-${var.env}"

  # An undefined surge queue length is good - we haven't had to queue any requests recently, so
  # don't alert
  treat_missing_data = "notBreaching"

  alarm_actions = [var.cloudwatch_notification_arn]
  ok_actions    = [var.cloudwatch_notification_arn]
}

resource "aws_cloudwatch_metric_alarm" "status_4xx" {
  count               = var.status_4xx == null ? 0 : 1
  alarm_name          = "${var.load_balancer_name}-status-4xx"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.status_4xx.eval_periods
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ELB"
  period              = var.status_4xx.period
  statistic           = "Sum"

  dimensions = {
    LoadBalancerName = var.load_balancer_name
  }

  threshold         = var.status_4xx.threshold
  unit              = "Count"
  alarm_description = "HTTP Backend 4xx response codes exceeded for ELB ${var.load_balancer_name} in APP-ENV: ${var.app}-${var.env}"

  treat_missing_data = "notBreaching"

  alarm_actions = [var.cloudwatch_notification_arn]
  ok_actions    = [var.cloudwatch_notification_arn]
}

resource "aws_cloudwatch_metric_alarm" "rate_of_5xx" {
  count               = var.rate_of_5xx == null ? 0 : 1
  alarm_name          = "${var.load_balancer_name}-rate-of-5xx"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.rate_of_5xx.eval_periods
  threshold           = var.rate_of_5xx.threshold
  alarm_description   = "HTTP 5xx response codes rate exceeded for ELB ${var.load_balancer_name} in APP-ENV: ${var.app}-${var.env}"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.cloudwatch_notification_arn]
  ok_actions          = [var.cloudwatch_notification_arn]

  metric_query {
    id          = "e1"
    expression  = "error_sum/request_sum*100"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "request_sum"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.rate_of_5xx.period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = var.load_balancer_name
      }
    }
  }

  metric_query {
    id = "error_sum"

    metric {
      metric_name = "HTTPCode_ELB_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = var.rate_of_5xx.period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = var.load_balancer_name
      }
    }
  }
}

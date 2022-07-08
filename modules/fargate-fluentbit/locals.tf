locals {

  cwlog_group         = "/${var.addon_context.eks_cluster_id}/fargate-fluentbit-logs"
  cwlog_stream_prefix = "fargate-logs-"

  default_config = {
    output_conf  = <<-EOF
    [OUTPUT]
      Name cloudwatch_logs
      Match *
      region ${var.addon_context.aws_region_name}
      log_group_name ${local.cwlog_group}
      log_stream_prefix ${local.cwlog_stream_prefix}
      auto_create_group true
    EOF
  }

  config = merge(
    local.default_config,
    var.addon_config
  )
}

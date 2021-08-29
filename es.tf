resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}


resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.domain
  elasticsearch_version = "7.10"

  cluster_config {
    dedicated_master_enabled = var.enabled
    dedicated_master_type = "r6g.large.elasticsearch"
    dedicated_master_count = 3
    instance_count         = 2
    instance_type          = "r6g.large.elasticsearch"
    zone_awareness_enabled = var.enabled

    zone_awareness_config {
      availability_zone_count = 2
    }
  }

  vpc_options {
    subnet_ids         = [aws_subnet.public.id, aws_subnet.public1.id]
    security_group_ids = [aws_security_group.es_cluster_sg.id]

  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  ebs_options {
    ebs_enabled = var.enabled
    volume_size = 10
  }

  advanced_security_options {
    enabled = var.enabled
    internal_user_database_enabled = var.enabled
    master_user_options {
      master_user_name = var.user_name_kibana
      master_user_password = var.user_pass_kibana

    }
  }

  domain_endpoint_options {
    enforce_https = var.enabled
    tls_security_policy = "Policy-Min-TLS-1-0-2019-07"
  }

  encrypt_at_rest {
    enabled = var.enabled
  }

  node_to_node_encryption {
    enabled = var.enabled
  }
#allow open access to domain
  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"

      },
      "Action": "es:*",
      "Resource": "*"
    }
  ]
}
  CONFIG

  tags = {
    Domain = "es_for_eks"
  }

  depends_on = [aws_iam_service_linked_role.es]
}




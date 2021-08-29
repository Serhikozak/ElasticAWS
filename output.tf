output "Bastion" {
  value = aws_instance.For_forward_to_es.public_ip
}

output "elk_kibana_endpoint" {
  value = aws_elasticsearch_domain.es.kibana_endpoint
}
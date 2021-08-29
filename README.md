# ElasticAWS

After the domain deployed you need to enter next command in you CLI
ssh -i <name_private_key>.pem ubuntu@<public_IP> -N -L 9200:<endpoint>:443

then enter in you browser into you VM

https://localhost:9200/_plugin/kibana

You need to change var.cidr_my_pool to you own pool
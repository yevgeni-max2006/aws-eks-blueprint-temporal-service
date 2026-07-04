
###  ---  Database Services ---  ###
module "postgresql" {
  source = "./modules/postgresql"

  name       = "temporal-postgres"
  username   = "temporal"
  password   = var.db_password

  db_name        = "temporal"
  engine_version = "15.5"
  instance_class = "db.t3.medium"

  vpc_security_group_ids = [aws_security_group.rds.id]
  subnet_ids             = module.vpc.private_subnets
  allocated_storage      = 100

  tags = {
    env = "dev"
  }
}

###  ---  Application  ---  ###
module "httpd" {
  source = "./modules/httpd"
  depends_on = [kubernetes_namespace.migration]

  name   = "httpd-server"
  namespace = "default"
  replicas  = 1
  image = "virtapp/apache:7f6c4bf4-3-6"
  service_port = 8080
  service_type = "ClusterIP"
}

module "kong" {
  source = "./modules/kong"
  depends_on = [module.httpd]
}

module "temporal" {
  source = "./modules/temporal"
  depends_on = [module.postgresql]

  db_host     = module.postgresql.endpoint
  db_port     = module.postgresql.port
  db_name     = "temporal"
  db_user     = "temporal"
  db_password = var.db_password
}

module "ingress" {
  source = "./modules/ingress"
  depends_on = [module.temporal]
}



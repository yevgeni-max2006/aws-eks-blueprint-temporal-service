resource "helm_release" "temporal" {
  name       = "temporal"
  repository = "https://go.temporal.io/helm-charts"
  chart      = "temporal"
  namespace  = var.namespace

  values = [
    yamlencode({
      server = {
        config = {
          persistence = {
            default = {
              driver = "sql"
              sql = {
                driver   = "postgres"
                host     = var.db_host
                port     = var.db_port
                database = var.db_name
                user     = var.db_user
                password = var.db_password
              }
            }
          }
        }
      }
    })
  ]
}

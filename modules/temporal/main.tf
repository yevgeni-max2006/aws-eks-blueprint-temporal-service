
resource "helm_release" "temporal" {
  name             = "temporal"
  namespace        = kubernetes_namespace.temporal.metadata[0].name
  create_namespace = false

  repository = "https://go.temporal.io/helm-charts"
  chart      = "temporal"
  version    = "0.53.0" # optional, pin it for stability

  values = [
    yamlencode({
      server = {
        config = {
          persistence = {
            default = {
              driver = "sql"
              sql = {
                driver   = "postgres"
                host     = "postgresql.temporal.svc.cluster.local"
                port     = 5432
                database = "temporal"
                user     = "temporal"
                password = "temporal"
              }
            }

            visibility = {
              driver = "sql"
              sql = {
                driver   = "postgres"
                host     = "postgresql.temporal.svc.cluster.local"
                port     = 5432
                database = "temporal_visibility"
                user     = "temporal"
                password = "temporal"
              }
            }
          }
        }
      }
    })
  ]
}

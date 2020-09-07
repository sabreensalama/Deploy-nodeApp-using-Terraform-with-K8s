
#########create service  for nexus

resource "kubernetes_service" "nexus-service" {
  metadata {
    name      = "nexus-service"
    namespace = kubernetes_namespace.build.metadata[0].name
  }
  spec {
    selector = {
      app = kubernetes_deployment.nexus-deployment.spec[0].selector[0].match_labels.app
    }
    port {
       name = "nexus-port"

      port        = 8081
      target_port = 8081
    }
    port {
      name = "http-port"

      port        = 5000
      target_port = 5000
      node_port = 32644
    }


    type = "NodePort"
  }
}
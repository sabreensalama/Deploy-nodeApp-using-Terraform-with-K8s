
######### create service  for dev namespace

resource "kubernetes_service" "mysql-service-dev" {
  metadata {
    name      = "mysql-service-dev"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }
  spec {
    selector = {
      app = kubernetes_pod.mysql-dev-pod.metadata[0].labels.app
    }
    port {
      port= "3306"
      target_port= "3306"
    }
    type = "ClusterIP"
  }
}

## service fro test env
######### create service  for dev namespace

resource "kubernetes_service" "mysql-service-test" {
  metadata {
    name      = "mysql-service-test"
    namespace = kubernetes_namespace.test.metadata[0].name
  }
  spec {
    selector = {
      app = kubernetes_pod.mysql-dev-pod.metadata[0].labels.app
    }
    port {
      port= "3306"
      target_port= "3306"
    }
    type = "ClusterIP"
  }
}

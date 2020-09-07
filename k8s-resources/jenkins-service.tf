# service for jenkins pod
resource "kubernetes_service" "jenkins-service" {
  metadata {
    name      = "jenkins-service"
    namespace = kubernetes_namespace.build.metadata[0].name
  }
  spec {
    selector = {
      app = kubernetes_deployment.jenkins-deployment.spec[0].selector[0].match_labels.app
    }
    port {
      port        = 8080
      target_port = 8080
    }

    type = "NodePort"
  }
}

resource "kubernetes_service_account" "jenkins-account" {
  metadata {
    name = "jenkins-account"
    namespace = kubernetes_namespace.build.metadata[0].name
  }


}

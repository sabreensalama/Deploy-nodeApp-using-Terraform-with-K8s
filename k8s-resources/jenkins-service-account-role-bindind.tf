resource "kubernetes_role_binding" "jenkins-with-kubectl" {
  metadata {
    name      = "jenkins-with-kubectl"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "jenkins-role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins-account.metadata[0].name
    namespace = kubernetes_namespace.build.metadata[0].name
  }

}

resource "kubernetes_role_binding" "jenkins-with-kubectl-test" {
  metadata {
    name      = "jenkins-with-kubectl"
    namespace = kubernetes_namespace.test.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.jenkins-role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins-account.metadata[0].name
    namespace = kubernetes_namespace.build.metadata[0].name
  }

}


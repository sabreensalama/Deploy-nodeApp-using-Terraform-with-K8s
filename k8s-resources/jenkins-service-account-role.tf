
## create role The role above specifies that we want to be able to get, list, and delete pods.##
resource "kubernetes_cluster_role" "jenkins-role" {
  metadata {
    name = "jenkins-role"

  }

  rule {
    api_groups     = ["*"]
    resources      = ["*"]
    verbs          = ["*"]
  }

}
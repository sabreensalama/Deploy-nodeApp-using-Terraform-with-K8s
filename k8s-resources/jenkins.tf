resource "kubernetes_deployment" "jenkins-deployment" {
  metadata {
    name = "jenkins-deployment"
    namespace = kubernetes_namespace.build.metadata[0].name

    labels = {
      app = "jenkins"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "jenkins"
      }
    }
    template {
      metadata {
        name      = "jenkins"
        namespace = kubernetes_namespace.build.metadata[0].name
        labels = {
          app = "jenkins"
        }
      }
      spec {
        service_account_name            = kubernetes_service_account.jenkins-account.metadata[0].name
        automount_service_account_token = true

        # determin permission
        security_context {
          fs_group = "1000"
        }

        volume {
          name = "task-pv-storage-jenkins"
          persistent_volume_claim {
            claim_name = "pvc-jenkins"
          }

        }
        volume {
          name = "kubectl"
          empty_dir {}
        }
        volume {
          name = "docker"
          empty_dir {}
        }

        volume {
          name = "docker-sock-volume"
          host_path {
            path = "/var/run/docker.sock"
            type = "File"
          }
        }

        container {
          image = "sabreensalama/jenkins-ansible:v2"
          name  = "jenkins-container"

          port {
            container_port = 8080
          }
          volume_mount {
            mount_path = "/var/jenkins_home"
            name       = "task-pv-storage-jenkins"

          }
          volume_mount {
            mount_path = "/usr/local/bin/kubectl"
            name       = "kubectl"
            sub_path   = "kubectl"


          }
          ## docker mount
          volume_mount {
            mount_path = "/usr/bin/docker"
            name       = "docker"
            sub_path   = "docker"
          }

          volume_mount {
            mount_path = "/var/run/docker.sock"
            name       = "docker-sock-volume"
          }

        }

        init_container {
          name = "install-kubectl"
          # image = "allanlei/kubectl"
          image = "sabreensalama/kubectl:v4"
          volume_mount {
            mount_path = "/data"
            name       = "kubectl"

          }
          command = ["cp", "/usr/local/bin/kubectl", "/data/kubectl"]
        }
        # docker container
        init_container {
          name = "install-dcocker"
          # image = "docker:dind"
          image = "sabreensalama/dockercli:v1"
          volume_mount {
            mount_path = "/data/docker"
            name       = "docker"

          }
          command = ["cp", "/usr/bin/docker", "/data/docker"]

        }

      }
    }
  }
}

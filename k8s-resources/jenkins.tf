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

        image_pull_secrets{
              name= "regcred"
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
          image = "192.168.39.20:32644/vodafone-jenkins-ansible"
          ## using dockerhub
          ## image = sabreensalama/jenkins-ansible:latest
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
          image = "192.168.39.20:32644/kubectl:latest"

          ## from docker hub
          ## image ="sabreensalama/kubectl:latest"
          volume_mount {
            mount_path = "/data"
            name       = "kubectl"

          }
          command = ["cp", "/usr/local/bin/kubectl", "/data/kubectl"]
        }
        # docker container
        init_container {
          name = "install-dcocker"
          image = "192.168.39.20:32644/vodafone-dockercli"
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

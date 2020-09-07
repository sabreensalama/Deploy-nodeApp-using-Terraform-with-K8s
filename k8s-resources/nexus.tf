resource "kubernetes_deployment" "nexus-deployment" {
  metadata {
    name = "nexus"
    namespace = kubernetes_namespace.build.metadata[0].name
    labels = {
      app = "nexus"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nexus"
      }
    }

    template {
      metadata {
        labels = {
          app = "nexus"
        }
      }

        spec {
    # determin permission
      security_context{
        ## msh fahmah
        ## run as nexus user to change permission
        fs_group= 1000

 
      }

      volume {
      name = "nexus-data"
      persistent_volume_claim {
        claim_name = "pvc-nexus"
      }
    }
    container {
      image = "sonatype/nexus3"
      name  = "nexus-container"

      resources{
        limits{
          memory= "4Gi"
          cpu= "1000m"
        }
        requests{
          memory= "2Gi"
          cpu= "500m"
        }

      }
      port {
        container_port = 8081
      }
      # for http 
      port{
         container_port =  5000

      }
      // for https

      port{
         container_port =  4000

      }
      
      
  
      volume_mount {
        mount_path = "/nexus-data"
        name       = "nexus-data"

      }

    }


  }

    }
  }
}
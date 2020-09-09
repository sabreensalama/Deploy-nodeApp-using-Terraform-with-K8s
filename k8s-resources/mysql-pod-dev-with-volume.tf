########################## mysql pod ##########################
resource "kubernetes_pod" "mysql-dev-pod" {
  metadata {
    name      = "mysql-pod-dev"
    namespace = "dev"
    labels = {
      app = "mysql"
    }


  }
  spec {

    volume {
      name = "task-pv-storage-mysql-dev"
      persistent_volume_claim {
        claim_name = "pvc-mysql-dev"
      }
    }

    container {
      image = "sabreensalama/node-app-mysql:v1"
      name  = "mysql-container"


          env {
            name = "MYSQL_ROOT_PASSWORD"
            value =  $MYSQL_ROOT_PASSWORD            
          }



      port {
        container_port = 3306
      }
      volume_mount {
        mount_path = "/var/lib/mysql"
        name       = "task-pv-storage-mysql-dev"

      }
    }

  }

}

#########create volume for mysql ###############
resource "kubernetes_persistent_volume_claim" "pvc-mysql-dev" {
  metadata {
    name = "pvc-mysql-dev"
    namespace = "dev" 
  }
  spec {
    access_modes = ["ReadWriteMany"]
    storage_class_name = "manual"

    resources {
      requests = {
        storage = "5Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.pv-mysql-dev.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume" "pv-mysql-dev" {
  metadata {
    name = "pv-mysql-dev"

  }
  spec {
    storage_class_name = "manual"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
          host_path {
      path = "/data/mysql-dev-volume/"
      type = "DirectoryOrCreate"
    }
    }



  }
}
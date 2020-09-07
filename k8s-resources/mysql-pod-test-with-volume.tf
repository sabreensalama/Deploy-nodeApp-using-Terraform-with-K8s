######### mysql for test env #########3
resource "kubernetes_pod" "mysql-dev-test" {
  metadata {
    name      = "mysql-pod-test"
    namespace = "test"
    labels = {
      app = "mysql"
    }


  }
  spec {

    volume {
      name = "task-pv-storage-mysql-test"
      persistent_volume_claim {
        claim_name = "pvc-mysql-test"
      }
    }

    container {
      image = "sabreensalama/node-app-mysql:v1"
      name  = "mysql-container"



      port {
        container_port = 3306
      }
      volume_mount {
        mount_path = "/var/lib/mysql"
        name       = "task-pv-storage-mysql-test"

      }
    }

  }

}

#########create volume for mysql ###############
resource "kubernetes_persistent_volume_claim" "pvc-mysql-test" {
  metadata {
    name = "pvc-mysql-test"
    namespace = "test" 
  }
  spec {
    access_modes = ["ReadWriteMany"]
    storage_class_name = "manual"

    resources {
      requests = {
        storage = "5Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.pv-mysql-test.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume" "pv-mysql-test" {
  metadata {
    name = "pv-mysql-test"

  }
  spec {
    storage_class_name = "manual"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
          host_path {
      path = "/data/mysql-test-volume/"
      type = "DirectoryOrCreate"
    }
    }



  }
}
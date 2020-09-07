## create volume
resource "kubernetes_persistent_volume_claim" "pvc-jenkins" {
  metadata {
    name = "pvc-jenkins"
    namespace = "build"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    storage_class_name = "manual"

    resources {
      requests = {
        storage = "5Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.pv-jenkins.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume" "pv-jenkins" {
  metadata {
    name = "pv-jenkins"

  }
  spec {
    storage_class_name = "manual"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
          host_path {
      path = "/data/jenkins-volume/"
      type = "DirectoryOrCreate"
    }
    }



  }
}
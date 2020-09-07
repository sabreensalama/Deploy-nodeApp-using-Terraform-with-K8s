######### create volume  for nexus ####################
resource "kubernetes_persistent_volume_claim" "pvc-nexus" {
  metadata {
    name = "pvc-nexus"
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
    volume_name = "${kubernetes_persistent_volume.pv-nexus.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume" "pv-nexus" {
  metadata {
    name = "pv-nexus"

  }
  spec {
    storage_class_name = "manual"
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
          host_path {
      path = "/data/nexus-volume/"
      type = "DirectoryOrCreate"
    }
    }



  }
}

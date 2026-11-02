provider "kind" {}

resource "kind_cluster" "platform" {
  name           = var.cluster_name
  node_image     = "kindest/node:${var.kubernetes_version}"
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}

provider "kubernetes" {
  host                   = kind_cluster.platform.endpoint
  client_certificate     = kind_cluster.platform.client_certificate
  client_key             = kind_cluster.platform.client_key
  cluster_ca_certificate = kind_cluster.platform.cluster_ca_certificate
}

resource "kubernetes_namespace" "argocd" {
  depends_on = [kind_cluster.platform]
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "monitoring" {
  depends_on = [kind_cluster.platform]
  metadata {
    name = "monitoring"
  }
}

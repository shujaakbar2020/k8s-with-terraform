provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context"
}

resource "kubernetes_deployment" "k8s" {
  metadata {
    name = "k8s-with-terraform"
    labels = {
      test = "FirstApp"
    }
  }

  spec {
    replicas = 4

    selector {
      match_labels = {
        test = "FirstApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "FirstApp"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "nginx"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}
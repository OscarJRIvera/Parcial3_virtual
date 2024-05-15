provider "kubernetes" {
  config_path    = "~/.kube/config"  
  config_context = "minikube"        
}

# Hello-world api 
resource "kubernetes_deployment" "api" {
  metadata {
    name = "api"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "api"
      }
    }

    template {
      metadata {
        labels = {
          app = "api"
        }
      }

      spec {
        container {
          image = "oscarrivera1/mi_api_flask:latest"
          name  = "api"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

# servicio para el hello-world api
resource "kubernetes_service" "api-service" {
  metadata {
    name = "api-service"
  }

  spec {
    selector = {
      app = "api"
    }

    port {
      port        = 80
      target_port = 8080
    }
  }
}

# Deployment para el hello-wrold spa
resource "kubernetes_deployment" "nginx-spa" {
  metadata {
    name = "nginx-spa"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx-spa"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-spa"
        }
      }

      spec {
        container {
          image = "oscarrivera1/nginx-spa-image:latest" 
          name  = "nginx-spa"
          port {
            container_port = 3037  # Puerto para el segundo API
          }
        }
      }
    }
  }
}

# Serivico para en nginx-spa
resource "kubernetes_service" "nginx-spa-service" {
  metadata {
    name = "nginx-spa-service"
  }

  spec {
    selector = {
      app = "nginx-spa"
    }

    port {
      port        = 80
      target_port = 3037  # Puerto para el segundo API
    }
  }
}



#-------------------------------sql--------------------------------


resource "kubernetes_deployment" "mongodb" {
  metadata {
    name = "mongodb"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mongodb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }

      spec {
        container {
          name  = "mongodb"
          image = "mongo:latest" 
          port {
            container_port = 27017  
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mongodb-service" {
  metadata {
    name = "mongodb-service"
  }

  spec {
    selector = {
      app = "mongodb"
    }

    port {
      port        = 27017
      target_port = 27017
    }
  }
}


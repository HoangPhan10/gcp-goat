project_id = "rare-array-467416-p5"
vpc_name   = "my-vpc-network-asia"


vpc_subnets = {
  public-subnet-web = {
    name                     = "public-subnet-web"
    cidr                     = "10.0.0.0/24"
    region                   = "asia-northeast1"
    private_ip_google_access = false
  }

  private-subnet-app = {
    name                     = "private-subnet-app"
    cidr                     = "10.1.1.0/24"
    region                   = "asia-northeast1"
    private_ip_google_access = true
  }

  private-subnet-database = {
    name                     = "private-subnet-database"
    cidr                     = "10.1.2.0/24"
    region                   = "asia-northeast1"
    private_ip_google_access = true
  }
  private-subnet-direct-vpc = {
    name                     = "private-subnet-direct-vpc"
    cidr                     = "10.2.2.0/24"
    region                   = "asia-northeast1"
    private_ip_google_access = true
  }
}
# vpc_subnets_proxy = {
#   "proxy-asia-northeast1" : {
#     proxy_only_subnet_name = "proxy-only-asia-northeast1"
#     proxy_only_subnet_cidr = "10.129.0.0/23"
#     region                 = "asia-northeast1"
#   },
#   "proxy-asia-northeast2" : {
#     proxy_only_subnet_name = "proxy-only-asia-northeast2"
#     proxy_only_subnet_cidr = "10.130.0.0/23"
#     region                 = "asia-northeast2"
#   }
# }

# vpc_connector = {
#   name          = "shared-cloudrun-connector"
#   region        = "asia-southeast1"
#   ip_cidr_range = "10.8.0.0/28"
# }

network_connectivity = {
  name             = "my-partner-interconnect"
  network_vpc_name = ""
  router_name      = "my-router-interconnect"
  region           = "asia-southeast1"
}

/* Firewall Rules */
private_subnet_app_tag           = "app-tag"
public_subnet_web_tag            = "web-tag"
private_subnet_database_tag      = "database-tag"
private_subnet_direct_to_vpc_tag = "direct-to-vpc-tag"

iam_role = {
  "role_cloudbuild" : {
    role_id     = "role_cloudbuild"
    title       = "Role cloudbuild"
    description = "Role cloudbuild"
    permissions = [
      "logging.logEntries.create",
      "logging.logEntries.list",
      "logging.views.access",
      "storage.objects.list",
      "storage.objects.create",
      "storage.objects.get",
      "storage.objects.delete",
      "artifactregistry.repositories.uploadArtifacts",
      "artifactregistry.repositories.downloadArtifacts",
      "artifactregistry.repositories.create",
      "artifactregistry.repositories.get",
      "artifactregistry.repositories.delete",
      "artifactregistry.dockerimages.get",
      "run.services.get",
      "run.services.create",
      "run.services.update",
    ]
  }
  "role_cloudrun" : {
    role_id     = "role_cloudrun"
    title       = "Role Cloudrun"
    description = "Role Cloudrun"
    permissions = [
      "logging.logEntries.create",
    ]
  }
}
service_account = {
  "sa_cloudrun" : {
    account_id = "sa-cloudrun"
    role_id    = ""
  }
  "sa_dataflow" : {
    account_id = "sa-dataflow"
    role_id    = ""
  }
}


cloud_run_services = {
  service-frontend = {
    name           = "service-frontend"
    container_name = "service-frontend"
    region         = "asia-northeast1"
    minScale       = 1
    maxScale       = 2
    docker_image   = "phanhoang102/docker-example-nextjs:latest"
    ingress        = "internal-and-cloud-load-balancing"
    port           = 3000
    env = {
      NEXT_PUBLIC_API_URL = "https://service-i001-56551686880.asia-northeast1.run.app/notification/get"
    }
    vpc_network    = "my-vpc-network"
    vpc_subnetwork = "private-subnet-direct-vpc"
    vpc_egress     = "all-traffic"
  }
  service-i001 = {
    name           = "service-i001"
    container_name = "service-i001"
    region         = "asia-northeast1"
    minScale       = 1
    maxScale       = 2
    docker_image   = "phanhoang102/docker-springboot-example:latest"
    ingress        = "internal-and-cloud-load-balancing"
    port           = 8080
  }
  service-i002 = {
    name           = "service-i002"
    container_name = "service-i002"
    region         = "asia-northeast1"
    minScale       = 1
    maxScale       = 2
    docker_image   = "phanhoang102/docker-springboot-example:latest"
    ingress        = "internal-and-cloud-load-balancing"
    port           = 8080
  }
  service-i003 = {
    name           = "service-i003"
    container_name = "service-i003"
    region         = "asia-northeast1"
    minScale       = 1
    maxScale       = 2
    docker_image   = "phanhoang102/docker-springboot-example:latest"
    ingress        = "internal-and-cloud-load-balancing"
    port           = 8080
  }
  service-i004 = {
    name           = "service-i004"
    container_name = "service-i004"
    region         = "asia-northeast1"
    minScale       = 1
    maxScale       = 2
    docker_image   = "phanhoang102/docker-springboot-example:latest"
    ingress        = "internal-and-cloud-load-balancing"
    port           = 8080
  }

  # service3 = {
  #   name           = "web-apis-service-primary"
  #   container_name = "web-apis-service-primary"
  #   docker_image   = "phanhoang102/docker-example-nextjs:latest"
  #   region         = "asia-northeast1"
  #   minScale       = 2
  #   maxScale       = 3
  #   ingress        = "internal-and-cloud-load-balancing"
  #   env = {
  #     NEXT_PUBLIC_API_URL = "http://primary.alb.internal/notification/get"
  #   }
  #   # command        = ["/bin/false"]
  #   port           = 3000
  #   vpc_network    = "my-vpc-network"
  #   vpc_subnetwork = "private-subnet-direct-vpc-asia-northeast1"
  # }
}

bucket_storage = {
  "my-bucket-dev-log-asia" = {
    name                 = "my-bucket-dev-log-asia"
    bucket_location      = "ASIA"
    bucket_storage_class = "STANDARD"
  }
  "dataflow-temp-bucket-us" = {
    name                 = "dataflow-temp-bucket-us"
    bucket_location      = "us-central1"
    bucket_storage_class = "STANDARD"
  }
  "saved_logs_bucket" = {
    name                 = "saved_logs_bucket"
    bucket_location      = "us-central1"
    bucket_storage_class = "STANDARD"
  }
}

key_management = {
  key_ring = "my-key-manager-artifact-cicd-10145"
  location = "asia"
  crypto_key = {
    "my-key" = {
      name             = "my-key"
      rotation_period  = "7776000s"
      algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
      protection_level = "SOFTWARE"
      purpose          = "ENCRYPT_DECRYPT"
    },
    "my-key-attestor-cloudrun" = {
      name             = "my-key-attestor-cloudrun"
      rotation_period  = "7776000s"
      algorithm        = "RSA_SIGN_PKCS1_2048_SHA256"
      protection_level = "SOFTWARE"
      purpose          = "ASYMMETRIC_SIGN"
    },
  }
}

alb_region = {
  external_cloud_run_neg_web = {
    "neg-service-frontend" : {
      name : "neg-service-frontend",
      service_name : "service-frontend",
      region : "asia-northeast1"
    },
    "neg-service-i001" : {
      name : "neg-service-i001",
      service_name : "service-i001",
      region : "asia-northeast1"
    }
    "neg-service-i002" : {
      name : "neg-service-i002",
      service_name : "service-i002",
      region : "asia-northeast1"
    }
    "neg-service-i003" : {
      name : "neg-service-i003",
      service_name : "service-i003",
      region : "asia-northeast1"
    }
    "neg-service-i004" : {
      name : "neg-service-i004",
      service_name : "service-i004",
      region : "asia-northeast1"
    }
  }
  external_backend_services_config = {
    "backend-service-frontend" : {
      port_name = "http",
      backends = [
        {
          neg_key         = "neg-service-frontend"
          capacity_scaler = 1.0
        },
      ]
    },
    "backend-service-i001" : {
      port_name = "http",
      backends = [
        {
          neg_key         = "neg-service-i001"
          capacity_scaler = 1.0
        },
      ]
    },
    "backend-service-i002" : {
      port_name = "http",
      backends = [
        {
          neg_key         = "neg-service-i002"
          capacity_scaler = 1.0
        },
      ]
    },
    "backend-service-i003" : {
      port_name = "http",
      backends = [
        {
          neg_key         = "neg-service-i003"
          capacity_scaler = 1.0
        },
      ]
    },
    "backend-service-i004" : {
      port_name = "http",
      backends = [
        {
          neg_key         = "neg-service-i004"
          capacity_scaler = 1.0
        },
      ]
    },
  }
  external_load_balancer_name_web      = "my-gobal-loadbalancer-app-external"
  external_load_balancing_scheme_web   = "EXTERNAL_MANAGED"
  external_url_map_default_service_key = "backend-service-frontend"
  external_url_map_host_rules = [
    {
      hosts        = ["*"]
      path_matcher = "path-matcher-1"
    }
  ]
  external_url_map_path_matchers = [
    {
      name                = "path-matcher-1"
      default_service_key = "backend-service-frontend"
      path_rules = [
        {
          paths       = ["/api/v1/*", "/api/v1"]
          service_key = "backend-service-i001"
          route_action = {
            url_rewrite = {
              path_prefix_rewrite = "/"
            }
          }
        },
        {
          paths       = ["/api/v2/*", "/api/v2/"]
          service_key = "backend-service-i002"
          route_action = {
            url_rewrite = {
              path_prefix_rewrite = "/"
            }
          }
        },
        {
          paths       = ["/api/v3/*", "/api/v3"]
          service_key = "backend-service-i003"
          route_action = {
            url_rewrite = {
              path_prefix_rewrite = "/"
            }
          }
        },
        {
          paths       = ["/api/v4/*", "/api/v4"]
          service_key = "backend-service-i004"
          route_action = {
            url_rewrite = {
              path_prefix_rewrite = "/"
            }
          }
        },

      ]
  }]

}



pubsub = {
  "cloudrun_logs" = {
    name              = "cloudrun-logs"
    subscription_name = "sub-dataflow-reads-cloudrun-logs"
  }
  "deadletter_topic" = {
    name              = "deadletter-topic"
    subscription_name = "deadletter-subscription"

  }
}

secret_manager = {
  secret_data = "3a10a313a671503979ade1b15d461b5b" // delete before commit
  secret_id   = "datadog-api-key-for-dataflow"
}

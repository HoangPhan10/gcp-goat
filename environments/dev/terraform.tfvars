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

  private-subnet-app-secondary = {
    name                     = "private-subnet-app-secondary"
    cidr                     = "10.1.3.0/24"
    region                   = "asia-northeast2"
    private_ip_google_access = true
  }

  private-subnet-database = {
    name                     = "private-subnet-database"
    cidr                     = "10.1.2.0/24"
    region                   = "asia-northeast1"
    private_ip_google_access = true
  }

  private-subnet-direct-vpc = {
    name                     = "private-subnet-direct-vpc-asia-northeast1"
    cidr                     = "10.2.2.0/24"
    region                   = "asia-northeast1"
    private_ip_google_access = true
  }

  private-subnet-direct-vpc-asia-northeast2 = {
    name                     = "private-subnet-direct-vpc-asia-northeast2"
    cidr                     = "10.3.3.0/24"
    region                   = "asia-northeast2"
    private_ip_google_access = true
  }
}
vpc_subnets_proxy = {
  "proxy-asia-northeast1" : {
    proxy_only_subnet_name = "proxy-only-asia-northeast1"
    proxy_only_subnet_cidr = "10.129.0.0/23"
    region                 = "asia-northeast1"
  },
  "proxy-asia-northeast2" : {
    proxy_only_subnet_name = "proxy-only-asia-northeast2"
    proxy_only_subnet_cidr = "10.130.0.0/23"
    region                 = "asia-northeast2"
  }
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
  service1 = {
    name           = "app-notification-service-primary"
    container_name = "container-notification-service-primary"
    region         = "asia-northeast1"
    minScale       = 1
    maxScale       = 5
    docker_image   = "phanhoang102/docker-springboot-example:latest"
    ingress        = "internal-and-cloud-load-balancing"
    port           = 8080
  }

  service2 = {
    name           = "app-notification-service-secondary"
    container_name = "container-notification-service-secondary"
    region         = "asia-northeast2"
    minScale       = 1
    maxScale       = 5
    docker_image   = "phanhoang102/docker-springboot-example:latest"
    ingress        = "internal-and-cloud-load-balancing"
    port           = 8080
  }

  service3 = {
    name           = "web-apis-service-primary"
    container_name = "web-apis-service-primary"
    docker_image   = "phanhoang102/docker-example-nextjs:latest"
    region         = "asia-northeast1"
    minScale       = 1
    maxScale       = 3
    ingress        = "internal-and-cloud-load-balancing"
    env = {
      NEXT_PUBLIC_API_URL = "http://primary.alb.internal/notification/get"
    }
    # command        = ["/bin/false"]
    port           = 3000
    vpc_network    = "my-vpc-network"
    vpc_subnetwork = "private-subnet-direct-vpc-asia-northeast1"
  }

  service4 = {
    name           = "web-apis-service-secondary"
    container_name = "web-apis-service-secondary"
    docker_image   = "phanhoang102/docker-example-nextjs:latest"
    region         = "asia-northeast2"
    minScale       = 0
    maxScale       = 3
    ingress        = "internal-and-cloud-load-balancing"
    env = {
      NEXT_PUBLIC_API_URL = "http://secondary.alb.internal/notification/post"
    }
    port           = 3000
    vpc_network    = "my-vpc-network"
    vpc_subnetwork = "private-subnet-direct-vpc-asia-northeast2"
  }

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
  key_ring = "my-key-manager-artifact-cicd-100"
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

external_cloud_run_neg_web = {
  "neg-web-apis-service-primary" : {
    name : "neg-web-apis-service-primary",
    service_name : "web-apis-service-primary",
    region : "asia-northeast1"
  },
  "neg-web-apis-service-secondary" : {
    name : "neg-web-apis-service-secondary",
    service_name : "web-apis-service-secondary",
    region : "asia-northeast2"
  }
}
external_url_map_host_rules = [
  {
    hosts        = ["*"]
    path_matcher = "path-matcher-1"
  }
]
external_backend_services_config = {
  "apis-web-global-backend-primary" : {
    port_name = "http",
    backends = [
      {
        neg_key         = "neg-web-apis-service-primary"
        capacity_scaler = 1.0
      },
    ]
  },
  "apis-web-global-backend-secondary" : {
    port_name = "http",
    backends = [
      {
        neg_key         = "neg-web-apis-service-secondary"
        capacity_scaler = 1.0
      },
    ]
  }
}
external_url_map_path_matchers = [
  {
    name                = "path-matcher-1"
    default_service_key = "apis-web-global-backend-primary"
    path_rules = [
      {
        paths       = ["/notification", "/notification/*"]
        service_key = "apis-web-global-backend-primary"
      },
      {
        paths       = ["/v1/notification", "/v1/notification/*"]
        service_key = "apis-web-global-backend-secondary"
        route_action = {
          url_rewrite = {
            path_prefix_rewrite = "/notification/"
          }
        }
      }
    ]
}]
external_load_balancer_name_web      = "my-loadbalancer-app-external"
external_load_balancing_scheme_web   = "EXTERNAL_MANAGED"
external_url_map_default_service_key = "apis-web-global-backend-primary"

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

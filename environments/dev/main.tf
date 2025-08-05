provider "google" {
  project = var.project_id
}

module "bucket_storage" {
  source         = "../../modules/Storage/cloud_storage"
  project_id     = var.project_id
  bucket_storage = var.bucket_storage["my-bucket-dev-log-asia"]
}
module "bucket_storage_temp" {
  source         = "../../modules/Storage/cloud_storage"
  project_id     = var.project_id
  bucket_storage = var.bucket_storage["dataflow-temp-bucket-us"]
}
module "bucket_storage_saved" {
  source         = "../../modules/Storage/cloud_storage"
  project_id     = var.project_id
  bucket_storage = var.bucket_storage["saved_logs_bucket"]
}

module "key_management" {
  source         = "../../modules/Security/security/key_management"
  key_management = var.key_management
}

module "vpc_network" {
  source            = "../../modules/Networking/vpc_network/vpc"
  vpc_name          = var.vpc_name
  vpc_subnets       = var.vpc_subnets
  vpc_subnets_proxy = var.vpc_subnets_proxy
}

module "firewall" {
  depends_on                       = [module.vpc_network]
  source                           = "../../modules/Networking/vpc_network/firewall"
  vpc_name                         = var.vpc_name
  public_subnet_web_tag            = var.public_subnet_web_tag
  private_subnet_app_tag           = var.private_subnet_app_tag
  private_subnet_database_tag      = var.private_subnet_database_tag
  private_subnet_direct_to_vpc_tag = var.private_subnet_direct_to_vpc_tag
}

module "role_cloudrun" {
  source   = "../../modules/Management/iam_admin/role"
  iam_role = var.iam_role["role_cloudrun"]
}

module "sa_cloudrun" {
  depends_on = [module.role_cloudrun]
  source     = "../../modules/Management/iam_admin/service_account"
  service_account = merge(var.service_account["sa_cloudrun"], {
    role_id : module.role_cloudrun.id_role,
    project_id_role : var.project_id
  })
}

module "sa_dataflow" {
  depends_on = [module.role_cloudrun]
  source     = "../../modules/Management/iam_admin/service_account"
  service_account = merge(var.service_account["sa_dataflow"], {
    role_id : module.role_cloudrun.id_role,
    project_id_role : var.project_id
  })
}
locals {
  dataflow_roles = toset([
    "roles/dataflow.admin",
    "roles/dataflow.worker",
    "roles/pubsub.viewer",
    "roles/pubsub.subscriber",
    "roles/pubsub.publisher",
    "roles/secretmanager.secretAccessor",
    "roles/storage.objectAdmin",
    "roles/cloudasset.viewer",
    "roles/monitoring.viewer",
    "roles/compute.viewer",
  ])
}

resource "google_project_iam_member" "dataflow_iam_members" {
  for_each = toset(local.dataflow_roles)
  project  = var.project_id
  role     = each.value
  member   = module.sa_dataflow.member
}

module "cloud_run" {
  depends_on         = [module.vpc_network, module.sa_cloudrun]
  source             = "../../modules/Serverless/cloud_run"
  cloud_run_services = var.cloud_run_services
  email_sa_cloudrun  = module.sa_cloudrun.email_sa
}

module "alb_internal" {
  depends_on                           = [module.cloud_run]
  source                               = "../../modules/Networking/network_services/load_balancing"
  external_cloud_run_neg_web           = var.external_cloud_run_neg_web
  external_backend_services_config     = var.external_backend_services_config
  external_load_balancer_name_web      = var.external_load_balancer_name_web
  external_load_balancing_scheme_web   = var.external_load_balancing_scheme_web
  external_url_map_default_service_key = var.external_url_map_default_service_key
  external_url_map_host_rules          = var.external_url_map_host_rules
  external_url_map_path_matchers       = var.external_url_map_path_matchers
}

module "pub_sub_cloudrun_logs" {
  source     = "../../modules/Analytics/pub_sub"
  pubsub     = var.pubsub["cloudrun_logs"]
  project_id = var.project_id
}

module "pub_sub_deadletter_topic" {
  source     = "../../modules/Analytics/pub_sub"
  pubsub     = var.pubsub["deadletter_topic"]
  project_id = var.project_id
}

module "secret_manager" {
  source         = "../../modules/Security/security/secret_manager"
  project_id     = var.project_id
  secret_manager = var.secret_manager
}


module "router_sink" {
  depends_on = [module.pub_sub_cloudrun_logs, module.bucket_storage_saved]
  source     = "../../modules/Observability/logging/router_sink"
  project_id = var.project_id
  router_sink = {
    id_pubsub_logs           = module.pub_sub_cloudrun_logs.pubsub_topic_id
    id_saved_logs_bucket     = module.bucket_storage_saved.bucket_id
    name_pubsub_cloudrun_log = module.pub_sub_cloudrun_logs.pubsub_topic_name
    name_saved_logs_bucket   = module.bucket_storage_saved.bucket_name

  }
}

module "dataflow" {
  source     = "../../modules/Analytics/dataflow"
  project_id = var.project_id
  dataflow = {
    name                   = "pubsub-to-datadog"
    region                 = "us-central1"
    temp_bucket_name       = module.bucket_storage_temp.bucket_name
    datadog_site           = "ap1.datadoghq.com"
    pubsub_subscription_id = module.pub_sub_cloudrun_logs.pubsub_subscription_id
    deadletter_topic_id    = module.pub_sub_deadletter_topic.pubsub_topic_id
    id_key_version         = module.secret_manager.key_version_id
    service_account_email  = module.sa_dataflow.email_sa
  }
}

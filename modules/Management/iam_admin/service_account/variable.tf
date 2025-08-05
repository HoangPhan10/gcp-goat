variable "service_account" {
  type = object({
    project_id_role = string
    account_id      = string
    role_id         = optional(string)
  })
}

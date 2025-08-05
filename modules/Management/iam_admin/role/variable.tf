variable "iam_role" {
  type = object({
    role_id     = string
    title       = string
    description = string
    permissions = list(string)
  })
}
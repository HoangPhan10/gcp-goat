variable "key_management" {
  type = object({
    key_ring = string
    location = string
    crypto_key = map(object({
      name             = string
      rotation_period  = string
      algorithm        = string
      protection_level = string
      purpose          = string
    }))
  })
}

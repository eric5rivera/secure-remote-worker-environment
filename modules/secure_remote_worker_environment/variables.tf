variable tags {
  type        = map(any)
  description = "An object of tag key value pairs"
  default     = {}
}

variable name_prefix {
  type    = string
  default = "serverless-jenkins"
}

variable vpc_id {
  type = string
}
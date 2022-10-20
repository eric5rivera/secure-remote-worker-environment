terraform {
  cloud {
    organization = "ericmrivera"

    workspaces {
      name = "secure-remote-worker-environment"
    }
  }
}
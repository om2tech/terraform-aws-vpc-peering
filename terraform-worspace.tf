terraform {
  cloud {
    organization = "OM2Phoenix"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io

    workspaces {
      project = "om2-autotest"
      name    = "terraform-autotest-vpc-requester"
    }
  }
}

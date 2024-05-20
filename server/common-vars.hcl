locals {
  gh_token = get_env("TG_GITHUB_TOKEN", "<Provide 'TG_GITHUB_TOKEN' env variable>")
}

inputs = {
  base_module_url = "git::https://${local.gh_token}@github.com/moonorb/terraform-iac.git"

  common_tags = {
    admin_contact = "serhan.turkmenler@gmail.com"
    service_id    = "MoonOrb-Terraform-Demo"
  }
}
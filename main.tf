# Configure the 2 variables which are then passed to the module

module "static-web" {
  source = "./modules/static-web"

  domain_name  = "abcd.com"
  bucket_name  = "abc-123"
  ip-addresses = ["10.10.10.10/32"]
}



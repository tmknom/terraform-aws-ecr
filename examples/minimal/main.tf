module "ecr" {
  source          = "../../"
  name            = "example"
  tag_prefix_list = ["release"]
}

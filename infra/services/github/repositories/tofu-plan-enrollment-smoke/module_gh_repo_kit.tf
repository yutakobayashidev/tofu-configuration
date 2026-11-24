module "repository" {
  source = "git::https://github.com/zunoser/tfmodule-gh-repo-kit.git?ref=2871fec43812d4da413808013232c7234bd2f718"

  name        = "tofu-plan-enrollment-smoke"
  description = "Private smoke test for automatic Plan App enrollment"
  visibility  = "private"

  # GitHub Free has no rulesets for private repositories, so ci-gate is not
  # enforced. Add the ruleset from public roots after a plan upgrade.
  default_branch_ruleset = null
}

# Conftest Policy for OpenTofu

## Goal

Add Conftest to the Nix development shell and enforce that every
`github_issue_label` in an OpenTofu plan has a non-empty `description`.

The existing GitHub Actions workflow is out of scope and will be removed.

## Design

Evaluate OpenTofu plan JSON produced by `tofu show -json`. This uses evaluated
resource values and includes resources instantiated through modules, making it
the primary policy boundary for infrastructure changes.

Use this layout:

```text
policy/
└── terraform/
    ├── github_issue_label_description.rego
    ├── github_issue_label_description_test.rego
    └── helpers_test.rego
```

The policy walks `input.planned_values.root_module` so it also finds resources
nested in child modules.

Each policy emits a denial when `description` is:

- absent
- `null`
- an empty string

A non-empty string passes. Whitespace-only descriptions are not rejected in
this initial version.

## Developer Interface

Add `conftest` to `devShells.default.packages` in `flake.nix`.

Supported commands:

```bash
# Test a saved OpenTofu plan.
tofu show -json tfplan | conftest test --policy policy/terraform -

# Run Rego unit tests.
conftest verify --policy policy/terraform
```

## Testing

Rego unit tests cover these cases:

- non-empty description: allowed
- empty description: denied
- null description: denied
- missing description: denied

Implementation verification also runs:

- `nix fmt -- --check`
- `nix flake check`
- Conftest policy unit tests
- Conftest checks against representative plan JSON

Plan checks require initialized OpenTofu modules and provider/backend access.
Where generating a real plan is unavailable, the plan policy is proven with
Rego unit tests and a representative plan JSON fixture passed to Conftest.

## Repository Changes

- Add `conftest` to `flake.nix`.
- Add a plan Rego policy and tests under `policy/terraform/`.
- Remove `.github/workflows/tofu.yml`.
- Update `README.md` and `CLAUDE.md` with supported policy commands.
- Update `flake.lock` only if evaluation requires a lock-file change.

No compatibility wrappers, task runner, or replacement CI workflow will be
added.

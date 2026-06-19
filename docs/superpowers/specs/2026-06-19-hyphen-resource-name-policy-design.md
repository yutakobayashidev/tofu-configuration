# Hyphen in Resource Name Policy

## Goal

Add a Conftest policy that rejects managed OpenTofu resources whose local
resource name contains a hyphen.

For example, this resource is rejected:

```hcl
resource "google_project_iam_member" "test-1" {
  # ...
}
```

The preferred name is `test_1`.

## Input

The policy evaluates OpenTofu plan JSON produced by:

```bash
tofu show -json tfplan
```

It walks `input.planned_values.root_module` recursively so resources in child
modules are included.

## Detection

Inspect objects with:

- `mode == "managed"`
- a `name` containing `-`

Use the plan JSON `name` field rather than parsing `address`. This avoids false
positives from module names, resource types, indexes, and `for_each` keys that
may contain hyphens.

Data resources are excluded because their mode is `data`.

The rule is provider-independent and applies to all managed resource types.

## Files

Add:

```text
policy/terraform/
├── hyphen_in_resource_name.rego
└── hyphen_in_resource_name_test.rego
```

Reuse `wrap_single_resource` from `helpers_test.rego`.

## Denial

For a resource with address `google_project_iam_member.test-1`, emit:

```text
google_project_iam_member.test-1: [リソース名にハイフン (-) が含まれています。Terraform のベストプラクティスに従い、アンダースコア (_) を使用してください。](https://github.com/yutakobayashidev/tofu-configuration/blob/main/policy/terraform/hyphen_in_resource_name.rego)
```

The policy link points to the policy file in this repository.

## Tests

Use a table-driven Rego unit test covering:

- managed resource named `test`: allowed
- managed resource named `test-1`: denied
- data resource named `test-1`: allowed
- managed resource named `test-1` inside a child module: denied

The child-module case uses a representative nested plan input rather than the
single-resource helper.

## Documentation

No README or CLAUDE command changes are required because the existing
`conftest verify --policy policy/terraform` and plan-check commands
automatically include the new policy.

No GitHub Actions workflow is added.

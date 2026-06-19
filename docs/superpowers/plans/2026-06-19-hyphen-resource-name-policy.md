# Hyphen in Resource Name Policy Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reject managed OpenTofu resources whose local resource name contains a hyphen.

**Architecture:** Conftest evaluates the `name` and `mode` fields in OpenTofu plan JSON resources. Resource paths are restricted to module `resources` arrays so nested provider values cannot be mistaken for resources. A table-driven Rego test covers managed resources, data resources, nested values, and child modules without parsing opaque resource addresses.

**Tech Stack:** OpenTofu plan JSON, Conftest, OPA Rego v1

---

## File Structure

- Create `policy/terraform/hyphen_in_resource_name_test.rego`: define the four required policy cases.
- Create `policy/terraform/hyphen_in_resource_name.rego`: detect hyphens in managed resource names.

No existing policy, documentation, Nix, or workflow file needs modification.

### Task 1: Add Failing Resource Name Policy Tests

**Files:**

- Create: `policy/terraform/hyphen_in_resource_name_test.rego`

- [ ] **Step 1: Create the table-driven test**

```rego
package main

import rego.v1

test_deny_hyphen_in_resource_name if {
	not any_deny_hyphen_in_resource_name
}

any_deny_hyphen_in_resource_name if {
	seeds := [
		{
			"exp": set(), "msg": "managed resource without a hyphen passes",
			"input": wrap_single_resource({
				"address": "google_project_iam_member.test",
				"mode":    "managed",
				"name":    "test",
			}),
		},
		{
			"exp": {"google_project_iam_member.test-1: [リソース名にハイフン (-) が含まれています。Terraform のベストプラクティスに従い、アンダースコア (_) を使用してください。](https://github.com/yutakobayashidev/tofu-configuration/blob/main/policy/terraform/hyphen_in_resource_name.rego)"}, "msg": "managed resource with a hyphen is denied",
			"input": wrap_single_resource({
				"address": "google_project_iam_member.test-1",
				"mode":    "managed",
				"name":    "test-1",
			}),
		},
		{
			"exp": set(), "msg": "data resource with a hyphen passes",
			"input": wrap_single_resource({
				"address": "data.google_project.test-1",
				"mode":    "data",
				"name":    "test-1",
			}),
		},
		{
			"exp": set(), "msg": "nested resource values are ignored",
			"input": wrap_single_resource({
				"address": "example_resource.test",
				"mode":    "managed",
				"name":    "test",
				"values": {
					"nested": {
						"address": "not_a_resource.test-1",
						"mode":    "managed",
						"name":    "test-1",
					},
				},
			}),
		},
		{
			"exp": {"module.example.google_project_iam_member.test-1: [リソース名にハイフン (-) が含まれています。Terraform のベストプラクティスに従い、アンダースコア (_) を使用してください。](https://github.com/yutakobayashidev/tofu-configuration/blob/main/policy/terraform/hyphen_in_resource_name.rego)"}, "msg": "managed resource in a child module is denied",
			"input": {
				"planned_values": {
					"root_module": {
						"child_modules": [
							{
								"address": "module.example",
								"resources": [
									{
										"address": "module.example.google_project_iam_member.test-1",
										"mode":    "managed",
										"name":    "test-1",
									},
								],
							},
						],
					},
				},
			},
		},
	]

	some i
	seed := seeds[i]

	result := deny_hyphen_in_resource_name with input as seed.input

	result != seed.exp
	trace(sprintf("FAIL %s (%d): %s, wanted %v, got %v", ["test_deny_hyphen_in_resource_name", i, seed.msg, seed.exp, result]))
}
```

- [ ] **Step 2: Run the test to verify RED**

Run:

```bash
nix develop -c conftest verify --policy policy/terraform
```

Expected: FAIL because `deny_hyphen_in_resource_name` is undefined. Existing
policy tests must still compile.

- [ ] **Step 3: Commit the failing test**

```bash
git add policy/terraform/hyphen_in_resource_name_test.rego
git commit -m "test: add resource name policy cases"
```

### Task 2: Implement the Resource Name Policy

**Files:**

- Create: `policy/terraform/hyphen_in_resource_name.rego`

- [ ] **Step 1: Implement the minimum policy**

```rego
package main

import rego.v1

deny_hyphen_in_resource_name contains message if {
	walk(input.planned_values.root_module, [path, value])
	is_resource_path(path)
	value.mode == "managed"
	contains(value.name, "-")
	message := sprintf(
		"%s: [%s](%s)",
		[
			value.address,
			"リソース名にハイフン (-) が含まれています。Terraform のベストプラクティスに従い、アンダースコア (_) を使用してください。",
			"https://github.com/yutakobayashidev/tofu-configuration/blob/main/policy/terraform/hyphen_in_resource_name.rego",
		],
	)
}

is_resource_path(path) if {
	count(path) == 2
	path[0] == "resources"
}

is_resource_path(path) if {
	count(path) > 2
	count(path) % 2 == 0
	path[count(path) - 2] == "resources"
	every i in numbers.range(0, (count(path) - 4) / 2) {
		path[i * 2] == "child_modules"
	}
}
```

- [ ] **Step 2: Run the tests to verify GREEN**

Run:

```bash
nix develop -c conftest verify --policy policy/terraform
```

Expected: both policy test rules pass with zero failures.

- [ ] **Step 3: Check formatting and whitespace**

Run:

```bash
nix develop -c tofu fmt -check -recursive infra
git diff --check
```

Expected: both commands exit 0.

- [ ] **Step 4: Commit the policy**

```bash
git add policy/terraform/hyphen_in_resource_name.rego
git commit -m "feat: reject hyphens in resource names"
```

### Task 3: Verify the Complete Change

**Files:**

- Verify: `policy/terraform/hyphen_in_resource_name.rego`
- Verify: `policy/terraform/hyphen_in_resource_name_test.rego`

- [ ] **Step 1: Verify all systems evaluate**

Run:

```bash
nix flake check --no-build --all-systems
```

Expected: all configured systems evaluate successfully.

- [ ] **Step 2: Run all Rego unit tests**

Run:

```bash
nix develop -c conftest verify --policy policy/terraform
```

Expected: both policy test rules pass with zero failures.

- [ ] **Step 3: Verify OpenTofu formatting**

Run:

```bash
nix develop -c tofu fmt -check -recursive infra
```

Expected: exit 0.

- [ ] **Step 4: Audit scope and documentation impact**

Run:

```bash
git diff --check origin/main...HEAD
git diff --stat origin/main...HEAD
git status --short
```

Expected:

- no whitespace errors
- only the approved design, implementation plan, and two Rego files differ
- the worktree is clean

Confirm the pre-commit documentation check:

- `README.md` needs no update because its Conftest commands discover all policies.
- `CLAUDE.md` needs no update for the same reason.
- `AGENTS.md` needs no update because agent instructions are unchanged.
- `docs/` contains the approved design and implementation plan.

# Conftest OpenTofu Policy Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Conftest to the Nix development shell and reject OpenTofu plans containing a `github_issue_label` without a non-empty description.

**Architecture:** Conftest receives JSON from `tofu show -json` and evaluates a focused Rego policy under `policy/terraform`. A table-driven Rego unit test constructs representative planned resources without requiring backend credentials.

**Tech Stack:** Nix flakes, OpenTofu plan JSON, Conftest, OPA Rego v1

---

## File Structure

- Modify `flake.nix`: expose Conftest in the default development shell.
- Create `policy/terraform/helpers_test.rego`: build minimal plan JSON inputs for unit tests.
- Create `policy/terraform/github_issue_label_description.rego`: enforce label descriptions.
- Create `policy/terraform/github_issue_label_description_test.rego`: cover pass and denial cases.
- Delete `.github/workflows/tofu.yml`: remove the obsolete GitHub Actions workflow as requested.
- Modify `README.md`: document Conftest as a prerequisite and show plan-policy commands.
- Modify `CLAUDE.md`: add Conftest to the stack and agent-facing commands.
- Modify `z-ai/lessons.md`: retain the lesson captured from the source-versus-plan correction.

### Task 1: Add the Failing Rego Policy Tests

**Files:**

- Create: `policy/terraform/helpers_test.rego`
- Create: `policy/terraform/github_issue_label_description_test.rego`

- [ ] **Step 1: Create the test input helper**

```rego
package main

import rego.v1

wrap_single_resource(resource) := {
	"planned_values": {
		"root_module": {
			"resources": [resource],
		},
	},
}
```

- [ ] **Step 2: Create table-driven policy tests**

```rego
package main

import rego.v1

test_deny_github_issue_label_description if {
	not any_deny_github_issue_label_description
}

any_deny_github_issue_label_description if {
	seeds := [
		{
			"exp": set(), "msg": "pass",
			"resource": {
				"address": "github_issue_label.main", "type": "github_issue_label",
				"values": {"description": "foo"},
			},
		},
		{
			"exp": {"github_issue_label.main: [github_issue_label's description is required](https://github.com/yutakobayashidev/tofu-configuration/blob/main/policy/terraform/github_issue_label_description.rego)"}, "msg": "descriptoin is empty",
			"resource": {
				"address": "github_issue_label.main", "type": "github_issue_label",
				"values": {"description": ""},
			},
		},
		{
			"exp": {"github_issue_label.main: [github_issue_label's description is required](https://github.com/yutakobayashidev/tofu-configuration/blob/main/policy/terraform/github_issue_label_description.rego)"}, "msg": "descriptoin is null",
			"resource": {
				"address": "github_issue_label.main", "type": "github_issue_label",
				"values": {"description": null},
			},
		},
		{
			"exp": {"github_issue_label.main: [github_issue_label's description is required](https://github.com/yutakobayashidev/tofu-configuration/blob/main/policy/terraform/github_issue_label_description.rego)"}, "msg": "description should be set",
			"resource": {
				"address": "github_issue_label.main", "type": "github_issue_label",
				"values": {},
			},
		},
	]

	some i
	seed := seeds[i]

	result := deny_github_issue_label_description with input as wrap_single_resource(seed.resource)

	result != seed.exp
	trace(sprintf("FAIL %s (%d): %s, wanted %v, got %v", ["test_deny_github_issue_label_description", i, seed.msg, seed.exp, result]))
}
```

- [ ] **Step 3: Run the test to verify RED**

Run:

```bash
nix develop -c conftest verify --policy policy/terraform
```

Expected: FAIL because `conftest` is not yet in the development shell or `deny_github_issue_label_description` is undefined.

### Task 2: Add Conftest and Implement the Policy

**Files:**

- Modify: `flake.nix`
- Create: `policy/terraform/github_issue_label_description.rego`

- [ ] **Step 1: Add Conftest to the development shell**

Add `conftest` to `devShells.default.packages`:

```nix
packages = with pkgs; [
  cf-terraforming
  conftest
  (opentofu.withPlugins (p: [
```

- [ ] **Step 2: Implement the minimum policy**

```rego
package main

import rego.v1

allow_github_issue_label_description(values) if {
	values.description != null
	values.description != ""
}

deny_github_issue_label_description contains message if {
	walk(input.planned_values.root_module, [_, value])
	value.type == "github_issue_label"
	not allow_github_issue_label_description(value.values)
	message := sprintf(
		"%s: [%s](%s)",
		[
			value.address,
			"github_issue_label's description is required",
			"https://github.com/yutakobayashidev/tofu-configuration/blob/main/policy/terraform/github_issue_label_description.rego",
		],
	)
}
```

- [ ] **Step 3: Run the unit tests to verify GREEN**

Run:

```bash
nix develop -c conftest verify --policy policy/terraform
```

Expected: PASS for `test_deny_github_issue_label_description`.

### Task 3: Remove Obsolete CI and Document the Workflow

**Files:**

- Delete: `.github/workflows/tofu.yml`
- Modify: `README.md`
- Modify: `CLAUDE.md`
- Modify: `z-ai/lessons.md`

- [ ] **Step 1: Delete the workflow**

Delete `.github/workflows/tofu.yml`. Do not add a replacement workflow.

- [ ] **Step 2: Update README prerequisites**

Add Conftest beside OpenTofu and TFLint:

```markdown
- [Conftest](https://www.conftest.dev/)
```

- [ ] **Step 3: Document plan policy checks in README**

Add after the OpenTofu commands:

````markdown
### Policy Checks

Conftest evaluates the JSON representation of a saved OpenTofu plan:

```bash
tofu plan -out=tfplan
tofu show -json tfplan | conftest test --policy policy/terraform -
```

Run the Rego unit tests without creating a plan:

```bash
conftest verify --policy policy/terraform
```
````

- [ ] **Step 4: Update CLAUDE.md**

Add a `Policy` stack row for Conftest and append:

```bash
# OPA policy tests
conftest verify --policy policy/terraform

# Check an OpenTofu plan from the repository root
cd infra/services/github
tofu plan -out=tfplan
tofu show -json tfplan | conftest test --policy ../../../policy/terraform -
```

- [ ] **Step 5: Confirm the correction lesson is retained**

Ensure `z-ai/lessons.md` contains:

```markdown
- For OpenTofu OPA policy checks, prefer evaluating `tofu show -json` plan output unless source-HCL checks are specifically required; plan JSON reflects evaluated values and module expansion.
```

### Task 4: Format and Verify the Complete Change

**Files:**

- Modify if required by formatting: `flake.nix`
- Verify: all files changed by Tasks 1-3

- [ ] **Step 1: Format repository files**

Run:

```bash
nix fmt
```

Expected: exit 0.

- [ ] **Step 2: Verify the flake**

Run:

```bash
nix flake check
```

Expected: exit 0.

- [ ] **Step 3: Run Rego unit tests**

Run:

```bash
nix develop -c conftest verify --policy policy/terraform
```

Expected: all tests pass.

- [ ] **Step 4: Check repository consistency**

Run:

```bash
git diff --check
git status --short
```

Expected: no whitespace errors; only the planned files are changed or added.

- [ ] **Step 5: Perform the pre-commit documentation check**

Confirm:

- `README.md` documents the user-facing command.
- `CLAUDE.md` documents the agent-facing command.
- `AGENTS.md` needs no change because agent instructions are unchanged.
- `docs/` contains the approved design and this implementation plan.

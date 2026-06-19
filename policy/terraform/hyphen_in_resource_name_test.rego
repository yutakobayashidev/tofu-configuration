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
			"exp": {"google_project_iam_member.test-1: [リソース名にハイフン (-) が含まれています。アンダースコア (_) を使用してください。`tfmv -r '-/_'` で一括修正できます。 参照: https://developer.hashicorp.com/terraform/language/style#resource-naming https://docs.cloud.google.com/docs/terraform/best-practices/general-style-structure?hl=ja](https://github.com/yutakobayashidev/tofu-configuration/blob/main/policy/terraform/hyphen_in_resource_name.rego)"}, "msg": "managed resource with a hyphen is denied",
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
			"exp": {"module.example.google_project_iam_member.test-1: [リソース名にハイフン (-) が含まれています。アンダースコア (_) を使用してください。`tfmv -r '-/_'` で一括修正できます。 参照: https://developer.hashicorp.com/terraform/language/style#resource-naming https://docs.cloud.google.com/docs/terraform/best-practices/general-style-structure?hl=ja](https://github.com/yutakobayashidev/tofu-configuration/blob/main/policy/terraform/hyphen_in_resource_name.rego)"}, "msg": "managed resource in a child module is denied",
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

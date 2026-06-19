package main

import rego.v1

deny_hyphen_in_resource_name contains message if {
	walk(input.planned_values.root_module, [_, value])
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

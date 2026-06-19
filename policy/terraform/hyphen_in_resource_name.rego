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

# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

class_name MrGodotPlz


static func update_sizes_in_container(control: Control) -> void:
	control.size_flags_vertical += 1
	control.size_flags_vertical -= 1

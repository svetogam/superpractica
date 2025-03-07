# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TaskResource
extends Resource

@export var name_id: String
@export var name_text: String
@export_multiline var _instructions: String
var replacements := {}


func get_instructions() -> String:
	if replacements.size() > 0:
		var formatted_instructions := _instructions.format(replacements)
		return formatted_instructions
	else:
		return _instructions

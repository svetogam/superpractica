#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name TaskResource
extends Resource

@export var name_id: String
@export var name_text: String
@export_multiline var _instructions: String
var _replacements := {}


func set_instruction_replacements(p_replacements := {}) -> void:
	_replacements = p_replacements


func get_instructions() -> String:
	if _replacements.size() > 0:
		var formatted_instructions := _instructions.format(_replacements)
		return formatted_instructions
	else:
		return _instructions
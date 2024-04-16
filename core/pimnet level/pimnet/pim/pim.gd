#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name Pim
extends Panel

@onready var programs := $Programs as ModeGroup


# Virtual
func _on_focus() -> void:
	pass


func get_program(program_name: String) -> PimProgram:
	return programs.get_mode(program_name)

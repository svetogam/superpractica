#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingActionSetEmpty
extends FieldAction


static func get_name() -> int:
	return GridCounting.Actions.SET_EMPTY


func do() -> void:
	for unit in field.dynamic_model.get_units():
		unit.free()
	for block in field.dynamic_model.get_blocks():
		block.free()

	var cell = field.get_marked_cell()
	if cell != null:
		cell.toggle_mark()

	field.math_effects.clear()
	field.effect_counter.reset_count()

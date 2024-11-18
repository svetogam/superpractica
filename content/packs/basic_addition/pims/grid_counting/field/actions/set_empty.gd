#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldAction


func do() -> void:
	for unit in field.get_unit_list():
		unit.free()
	for two_block in field.get_two_block_list():
		two_block.free()
	for ten_block in field.get_ten_block_list():
		ten_block.free()

	var cell = field.get_marked_cell()
	if cell != null:
		cell.toggle_mark()

	field.math_effects.clear()
	field.effect_counter.reset_count()

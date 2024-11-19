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

var grid_cell: GridCell


static func get_name() -> int:
	return GridCounting.Actions.TOGGLE_MARK


func setup(p_grid_cell: GridCell) -> FieldAction:
	grid_cell = p_grid_cell
	return self


func is_valid() -> bool:
	if grid_cell == null:
		return false
	return true


func do() -> void:
	var marked_cell = field.get_marked_cell()
	if (marked_cell != null
			and grid_cell.get_instance_id() != marked_cell.get_instance_id()):
		marked_cell.toggle_mark()
	grid_cell.toggle_mark()

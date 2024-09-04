#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldProcess

const DELAY := 0.5
var _cell_number: int


func _init(p_cell_number: int) -> void:
	_cell_number = p_cell_number


func _ready() -> void:
	var cell = field.get_grid_cell(_cell_number)
	var zero := field.effect_counter.give_current_count(cell.position)

	await Game.wait_for(DELAY)

	complete(zero)

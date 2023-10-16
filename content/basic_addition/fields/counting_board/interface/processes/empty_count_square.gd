##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldProcess

const DELAY := 0.5
var _square_number: int


func setup(p_square_number: int) -> void:
	_square_number = p_square_number


func _ready() -> void:
	var square = field.queries.get_number_square(_square_number)
	var zero = field.counter.give_current_count(square.position)

	yield(Game.wait_for(DELAY), Game.DONE)

	complete([zero])

#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends VerificationState

var field: Field
var number_effect: NumberEffect
var start_square: NumberSquare
var squares_to_count: Array
var count := 0


func _enter(_last_state: String) -> void:
	field = verification.pim.field

	number_effect = verification.slot_panel.create_number_effect("addend_2")
	start_square = field.get_highlighted_number_square()

	var to_count := number_effect.number
	for i in range(to_count):
		var next_square = field.get_number_square(start_square.number + 1 + i)
		squares_to_count.append(next_square)

	await Game.wait_for(0.5)

	_put_next_counter()


func _put_next_counter() -> void:
	var next_square = squares_to_count[count]
	var field_counter = field.create_counter(next_square)

	await Game.wait_for(0.5)

	field.count_counter(field_counter)
	count += 1

	await Game.wait_for(0.5)

	if count == squares_to_count.size():
		await Game.wait_for(0.5)
		number_effect.queue_free()
		field.clear_effects()
		_change_state("CompareResult")
	else:
		_put_next_counter()

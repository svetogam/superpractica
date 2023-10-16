##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends VerificationState

var field: Field
var number_effect: NumberEffect
var start_square: NumberSquare
var squares_to_count: Array
var count := 0


func _enter(_last_state: String) -> void:
	field = verification.pim.field

	number_effect = verification.slot_panel.create_number_effect("addend_2")
	start_square = field.queries.get_highlighted_number_square()

	var to_count = number_effect.number
	for i in range(to_count):
		var next_square = field.queries.get_number_square(start_square.number + 1 + i)
		squares_to_count.append(next_square)

	yield(Game.wait_for(0.5), Game.DONE)

	_put_next_counter()


func _put_next_counter() -> void:
	var spawner = verification.pim.menu_control.spawn_panel.get_spawner(
			CountingBoardGlobals.Objects.COUNTER)
	var counter = spawner.create_interfield_object(false)
	var next_square = squares_to_count[count]

	counter.animator.connect("move_completed", self,
			"_on_counter_move_completed", [counter, next_square])
	var dest = verification.pim.field_viewer.convert_internal_to_external_point(
			next_square.position)
	counter.animator.move_to_position(dest)


func _on_counter_move_completed(counter: InterfieldObject, square: FieldObject) -> void:
	counter.queue_free()
	var field_counter = field.actions.create_counter(square)
	field.actions.count_counter(field_counter)
	count += 1

	yield(Game.wait_for(0.5), Game.DONE)

	if count == squares_to_count.size():
		yield(Game.wait_for(0.5), Game.DONE)
		number_effect.queue_free()
		field.clear_effects()
		_change_state("CompareResult")
	else:
		_put_next_counter()

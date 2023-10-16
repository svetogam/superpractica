##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends SpFieldTest

var units: Array
var bubbles: Array


func _get_scene_path() -> String:
	return (
		"res://content/debug/fields/bubble_sum/bubble_sum_field.tscn"
	)


func before_each():
	.before_each()
	_load_ref_scene(
		"res://content/debug/tests/fields/bubble_sum/bubble_sum_field_ref.tscn"
	)


func _setup_field_example() -> void:
	units.clear()
	bubbles.clear()
	field.actions.set_empty()
	units.append(field.actions.create_unit(Vector2(95, 100)))
	units.append(field.actions.create_unit(Vector2(100, 215)))
	units.append(field.actions.create_unit(Vector2(215, 155)))
	units.append(field.actions.create_unit(Vector2(330, 165)))
	bubbles.append(field.actions.create_bubble(Vector2(95, 105)))
	bubbles.append(field.actions.create_bubble(Vector2(140, 140), 135))
	bubbles.append(field.actions.create_bubble(Vector2(285, 90)))
	bubbles.append(field.actions.create_bubble(Vector2(335, 240)))
	field._trigger_update(field.UpdateTypes.INITIAL)


func test_create_and_delete_units():
	field.actions.create_unit($Ref/Unit1.position)
	field.actions.create_unit($Ref/Unit2.position)
	field.actions.create_unit($Ref/Unit3.position)
	assert_eq(field.queries.get_unit_list().size(), 3)

	var unit = field.queries.get_units_at_point($Ref/Unit1.position)[0]
	field.actions.delete_unit(unit)
	unit = field.queries.get_units_at_point($Ref/Unit2.position)[0]
	field.actions.delete_unit(unit)
	assert_eq(field.queries.get_unit_list().size(), 1)


func test_move_units():
	_setup_field_example()
	field.actions.move_unit(units[0], $Ref/MissObjects.position)
	field.actions.move_unit(units[1], $Ref/MissField.position)
	assert_eq(field.queries.get_unit_list().size(), 4)
	assert_eq(field.queries.is_unit_at_point($Ref/Unit1.position), false)
	assert_eq(field.queries.is_unit_at_point($Ref/MissObjects.position), true)
	assert_eq(field.queries.is_unit_at_point($Ref/Unit2.position), true)


func test_create_and_delete_bubbles():
	field.actions.create_bubble($Ref/Bubble1.position)
	field.actions.create_bubble($Ref/Bubble2.position)
	assert_eq(field.queries.get_bubble_list().size(), 2)

	var bubble = field.queries.get_bubbles_at_point($Ref/Bubble1.position)[0]
	field.actions.delete_bubble(bubble)
	assert_eq(field.queries.get_bubble_list().size(), 1)


func test_move_bubbles():
	var DRAG_VECTOR = Vector2(100.0, 25.0)

	_setup_field_example()
	field.actions.move_bubble(bubbles[2], $Ref/MissObjects.position)
	field.actions.move_bubble(bubbles[3], $Ref/MissField.position)
	assert_eq(field.queries.get_bubble_list().size(), 4)
	assert_eq(field.queries.is_bubble_at_point($Ref/Bubble3.position), false)
	assert_eq(field.queries.is_bubble_at_point($Ref/MissObjects.position), true)
	assert_eq(field.queries.is_bubble_at_point($Ref/Bubble4.position), true)

	_setup_field_example()
	field.actions.move_bubble_by(bubbles[1], DRAG_VECTOR)
	assert_eq(field.queries.is_unit_at_point($Ref/Unit1.position + DRAG_VECTOR), true)
	assert_eq(field.queries.is_unit_at_point($Ref/Unit2.position + DRAG_VECTOR), true)
	assert_eq(field.queries.is_unit_at_point($Ref/Unit3.position + DRAG_VECTOR), true)
	assert_eq(field.queries.is_unit_at_point($Ref/Unit4.position), true)
	assert_eq(field.queries.is_bubble_at_point($Ref/Bubble1.position + DRAG_VECTOR), true)
	assert_eq(field.queries.is_bubble_at_point($Ref/Bubble2.position + DRAG_VECTOR), true)
	assert_eq(field.queries.is_bubble_at_point($Ref/Bubble3.position), true)
	assert_eq(field.queries.is_bubble_at_point($Ref/Bubble3.position), true)

	_setup_field_example()
	field.actions.move_bubble_by(bubbles[0], DRAG_VECTOR)
	assert_eq(field.queries.is_unit_at_point($Ref/Unit1.position + DRAG_VECTOR), true)
	assert_eq(field.queries.is_unit_at_point($Ref/Unit2.position), true)
	assert_eq(field.queries.is_unit_at_point($Ref/Unit2.position + DRAG_VECTOR), false)
	assert_eq(field.queries.is_bubble_at_point($Ref/Bubble1.position + DRAG_VECTOR), true)


func test_pop_and_delete_bubbles():
	_setup_field_example()
	field.actions.pop_bubble(bubbles[1])
	field.actions.pop_bubble(bubbles[3])
	assert_eq(field.queries.get_unit_list().size(), 4)
	assert_eq(field.queries.get_bubble_list().size(), 2)

	field.actions.delete_bubble(bubbles[1])
	field.actions.delete_bubble(bubbles[3])
	assert_eq(field.queries.get_unit_list().size(), 1)
	assert_eq(field.queries.get_bubble_list().size(), 1)


func test_resize_bubbles():
	_setup_field_example()
	field.actions.resize_bubble(bubbles[3], 1)
	assert_eq(bubbles[3].get_internal_units().size(), 0)

	_setup_field_example()
	field.actions.resize_bubble(bubbles[3], 80)
	assert_eq(bubbles[3].get_internal_units().size(), 1)


func test_select_units():
	_setup_field_example()
	field.actions.select_unit(units[0])
	field.actions.select_unit(units[1])
	field.actions.select_unit(units[3])
	assert_eq(field.queries.get_selected_unit_list().size(), 3)

	field.actions.select_unit(units[0])
	field.actions.select_unit(units[1])
	assert_eq(field.queries.get_selected_unit_list().size(), 1)


func test_count_units():
	_setup_field_example()
	field.actions.count_unit(units[0])
	field.actions.count_unit(units[1])
	field.actions.count_unit(units[3])
	assert_eq(field.queries.get_selected_unit_list().size(), 3)

	field.actions.count_unit(units[0])
	field.actions.count_unit(units[1])
	assert_eq(field.queries.get_selected_unit_list().size(), 3)


func test_select_bubbles():
	_setup_field_example()
	field.actions.select_bubble(bubbles[0])
	assert_eq(field.queries.get_selected_unit_list().size(), 1)
	assert_eq(field.queries.get_selected_bubble_list().size(), 1)

	field.actions.select_bubble(bubbles[1])
	assert_eq(field.queries.get_selected_unit_list().size(), 3)
	assert_eq(field.queries.get_selected_bubble_list().size(), 2)

	field.actions.select_bubble(bubbles[0])
	assert_eq(field.queries.get_selected_unit_list().size(), 3)
	assert_eq(field.queries.get_selected_bubble_list().size(), 1)

	field.actions.select_bubble(bubbles[2])
	field.actions.select_bubble(bubbles[3])
	assert_eq(field.queries.get_selected_unit_list().size(), 3)
	assert_eq(field.queries.get_selected_bubble_list().size(), 3)


func test_undo_redo():
	var mem_states = []
	field.actions.create_unit($Ref/Unit1.position)
	mem_states.append(field.build_mem_state())
	field.actions.create_unit($Ref/Unit2.position)
	field.actions.create_bubble($Ref/Bubble1.position)
	mem_states.append(field.build_mem_state())
	field.actions.create_bubble($Ref/Bubble2.position)
	mem_states.append(field.build_mem_state())

	field.load_mem_state(mem_states[0])
	assert_eq(field.queries.get_unit_list().size(), 1)
	assert_eq(field.queries.get_bubble_list().size(), 0)

	field.load_mem_state(mem_states[2])
	assert_eq(field.queries.get_unit_list().size(), 2)
	assert_eq(field.queries.get_bubble_list().size(), 2)

	field.load_mem_state(mem_states[1])
	assert_eq(field.queries.get_unit_list().size(), 2)
	assert_eq(field.queries.get_bubble_list().size(), 1)


func test_set_empty():
	field.actions.create_unit($Ref/Unit1.position)
	field.actions.create_unit($Ref/Unit2.position)
	field.actions.create_bubble($Ref/Bubble1.position)
	field.actions.create_bubble($Ref/Bubble2.position)
	field.actions.set_empty()
	assert_eq(field.queries.get_unit_list().size(), 0)
	assert_eq(field.queries.get_bubble_list().size(), 0)

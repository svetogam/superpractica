##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

#DO NOT MAINTAIN

extends SpLevelTest

var pim: Pim
var field: Field


func before_each():
	.before_each()
	_load_level("debug_windows", "bubble_sum_1")
	_load_ref_scene(
		"res://content/debug/tests/pim_levels/do_not_maintain/bubble_sum_1/bubble_sum_pim_ref.tscn"
	)
	pim = pimnet.get_pim("BubbleSumPim")
	field = pim.field


func _setup_field_example() -> void:
	field.actions.set_empty()
	field.actions.create_unit(Vector2(95, 100))
	field.actions.create_unit(Vector2(100, 215))
	field.actions.create_unit(Vector2(215, 155))
	field.actions.create_unit(Vector2(330, 165))
	field.actions.create_bubble(Vector2(95, 105))
	field.actions.create_bubble(Vector2(140, 140), 135)
	field.actions.create_bubble(Vector2(285, 90))
	field.actions.create_bubble(Vector2(335, 240))
	field._trigger_update(field.UpdateTypes.INITIAL)


#func test_create_and_delete_units():
#	simulator.click_left_at($Ref/CreateUnit.position)
#	simulator.click_left_at($Ref/Unit1.position)
#	simulator.click_left_at($Ref/Unit2.position)
#	simulator.click_left_at($Ref/Unit3.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_unit_list().size(), 3)
#
#	simulator.click_left_at($Ref/DeleteUnit.position)
#	simulator.click_left_at($Ref/Unit1.position)
#	simulator.click_left_at($Ref/Unit2.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_unit_list().size(), 1)


#func test_move_units():
#	var point
#	_setup_field_example()
#
#	simulator.click_left_at($Ref/MoveObject.position)
#	simulator.drag_left_between($Ref/Unit1.position, $Ref/MissObjects.position)
#	simulator.drag_left_between($Ref/Unit2.position, $Ref/MissPim.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_unit_list().size(), 3)
#	point = _get_field_point_for($Ref/Unit1)
#	assert_eq(field.queries.is_unit_at_point(point), false)
#	point = _get_field_point_for($Ref/Unit2)
#	assert_eq(field.queries.is_unit_at_point(point), false)
#	point = _get_field_point_for($Ref/MissObjects)
#	assert_eq(field.queries.is_unit_at_point(point), true)
#
#
#func test_create_and_delete_bubbles():
#	simulator.click_left_at($Ref/CreateBubble.position)
#	simulator.click_left_at($Ref/Bubble1.position)
#	simulator.click_left_at($Ref/Bubble2.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_bubble_list().size(), 2)
#
#	simulator.click_left_at($Ref/DeleteBubble.position)
#	simulator.click_left_at($Ref/Bubble1.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_bubble_list().size(), 1)
#
#
#func test_move_bubbles():
#	var point
#	var DRAG_VECTOR = Vector2(100.0, 25.0)
#	simulator.click_left_at($Ref/MoveObject.position)
#	simulator.run()
#	yield(simulator, "done")
#
#	_setup_field_example()
#	simulator.drag_left_between($Ref/Bubble3.position, $Ref/MissObjects.position)
#	simulator.drag_left_between($Ref/Bubble4.position, $Ref/MissPim.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_bubble_list().size(), 4)
#	point = _get_field_point_for($Ref/Bubble3)
#	assert_eq(field.queries.is_bubble_at_point(point), false)
#	point = _get_field_point_for($Ref/MissObjects)
#	assert_eq(field.queries.is_bubble_at_point(point), true)
#	point = _get_field_point_for($Ref/Bubble4)
#	assert_eq(field.queries.is_bubble_at_point(point), true)
#
#	_setup_field_example()
#	simulator.drag_left_by($Ref/Bubble2.position, DRAG_VECTOR)
#	simulator.run()
#	yield(simulator, "done")
#	point = pimnet.get_field_point_at_external_point($Ref/Unit1.position + DRAG_VECTOR)
#	assert_eq(field.queries.is_unit_at_point(point), true)
#	point = pimnet.get_field_point_at_external_point($Ref/Unit2.position + DRAG_VECTOR)
#	assert_eq(field.queries.is_unit_at_point(point), true)
#	point = pimnet.get_field_point_at_external_point($Ref/Unit3.position + DRAG_VECTOR)
#	assert_eq(field.queries.is_unit_at_point(point), true)
#	point = pimnet.get_field_point_at_external_point($Ref/Unit4.position)
#	assert_eq(field.queries.is_unit_at_point(point), true)
#	point = pimnet.get_field_point_at_external_point($Ref/Bubble1.position + DRAG_VECTOR)
#	assert_eq(field.queries.is_bubble_at_point(point), true)
#	point = pimnet.get_field_point_at_external_point($Ref/Bubble2.position + DRAG_VECTOR)
#	assert_eq(field.queries.is_bubble_at_point(point), true)
#	point = pimnet.get_field_point_at_external_point($Ref/Bubble3.position)
#	assert_eq(field.queries.is_bubble_at_point(point), true)
#	point = pimnet.get_field_point_at_external_point($Ref/Bubble4.position)
#	assert_eq(field.queries.is_bubble_at_point(point), true)
#
#	_setup_field_example()
#	simulator.drag_left_by($Ref/Bubble1.position, DRAG_VECTOR)
#	simulator.run()
#	yield(simulator, "done")
#	point = pimnet.get_field_point_at_external_point($Ref/Unit1.position + DRAG_VECTOR)
#	assert_eq(field.queries.is_unit_at_point(point), true)
#	point = pimnet.get_field_point_at_external_point($Ref/Bubble1.position + DRAG_VECTOR)
#	assert_eq(field.queries.is_bubble_at_point(point), true)
#	point = pimnet.get_field_point_at_external_point($Ref/Unit2.position)
#	assert_eq(field.queries.is_unit_at_point(point), true)
#	point = pimnet.get_field_point_at_external_point($Ref/Unit2.position + DRAG_VECTOR)
#	assert_eq(field.queries.is_unit_at_point(point), false)


#func test_pop_and_delete_bubbles():
#	_setup_field_example()
#	simulator.click_left_at($Ref/PopBubble.position)
#	simulator.click_left_at($Ref/Bubble2.position)
#	simulator.click_left_at($Ref/Bubble4.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_unit_list().size(), 4)
#	assert_eq(field.queries.get_bubble_list().size(), 2)
#
#	_setup_field_example()
#	simulator.click_left_at($Ref/DeleteBubble.position)
#	simulator.click_left_at($Ref/Bubble2.position)
#	simulator.click_left_at($Ref/Bubble4.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_unit_list().size(), 1)
#	assert_eq(field.queries.get_bubble_list().size(), 1)


#func test_resize_bubbles():
#	var bubble
#	var initial_radius
#	simulator.click_left_at($Ref/ResizeBubble.position)
#	simulator.run()
#	yield(simulator, "done")
#
#	_setup_field_example()
#	simulator.drag_left_by($Ref/BubbleHandleUL.position, Vector2(-200, 0))
#	simulator.run()
#	yield(simulator, "done")
#	bubble = field.get_object_at_point(_get_field_point_for($Ref/Bubble4))
#	assert_eq(bubble.has_max_radius(), true)
#
#	_setup_field_example()
#	simulator.drag_left_by($Ref/BubbleHandleUL.position, Vector2(200, 0))
#	simulator.run()
#	yield(simulator, "done")
#	bubble = field.get_object_at_point(_get_field_point_for($Ref/Bubble4))
#	assert_eq(bubble.has_min_radius(), true)
#
#	_setup_field_example()
#	simulator.drag_left_by($Ref/BubbleHandleU.position, Vector2(0, -200))
#	simulator.run()
#	yield(simulator, "done")
#	bubble = field.get_object_at_point(_get_field_point_for($Ref/Bubble4))
#	assert_eq(bubble.has_max_radius(), true)
#
#	_setup_field_example()
#	bubble = field.get_object_at_point(_get_field_point_for($Ref/Bubble4))
#	initial_radius = bubble.radius
#	simulator.drag_left_by($Ref/BubbleHandleU.position, Vector2(-200, 0))
#	simulator.run()
#	yield(simulator, "done")
#	assert_almost_eq(bubble.radius, initial_radius, 0.01)
#
#	_setup_field_example()
#	simulator.drag_left_by($Ref/BubbleHandleL.position, Vector2(-200, 0))
#	simulator.run()
#	yield(simulator, "done")
#	bubble = field.get_object_at_point(_get_field_point_for($Ref/Bubble4))
#	assert_eq(bubble.has_max_radius(), true)
#
#	_setup_field_example()
#	bubble = field.get_object_at_point(_get_field_point_for($Ref/Bubble4))
#	initial_radius = bubble.radius
#	simulator.drag_left_by($Ref/BubbleHandleL.position, Vector2(0, -200))
#	simulator.run()
#	yield(simulator, "done")
#	assert_almost_eq(bubble.radius, initial_radius, 0.01)


func test_select_units():
	_setup_field_example()
	simulator.click_left_at($Ref/SelectUnit.position)
	simulator.click_left_at($Ref/Unit1.position)
	simulator.click_left_at($Ref/Unit2.position)
	simulator.click_left_at($Ref/Unit4.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(pim.get_memo_output().get_value(), 3)

	simulator.click_left_at($Ref/Unit1.position)
	simulator.click_left_at($Ref/Unit2.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(pim.get_memo_output().get_value(), 1)


func test_count_units():
	_setup_field_example()
	simulator.click_left_at($Ref/CountUnit.position)
	simulator.click_left_at($Ref/Unit1.position)
	simulator.click_left_at($Ref/Unit2.position)
	simulator.click_left_at($Ref/Unit4.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(pim.get_memo_output().get_value(), 3)

	simulator.click_left_at($Ref/Unit1.position)
	simulator.click_left_at($Ref/Unit2.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(pim.get_memo_output().get_value(), 3)


func test_select_bubbles():
	_setup_field_example()
	simulator.click_left_at($Ref/SelectBubble.position)
	simulator.click_left_at($Ref/Bubble1.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(pim.get_memo_output().get_value(), 1)

	simulator.click_left_at($Ref/Bubble2.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(pim.get_memo_output().get_value(), 2)

	simulator.click_left_at($Ref/Bubble1.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(pim.get_memo_output().get_value(), 1)

	simulator.click_left_at($Ref/Bubble3.position)
	simulator.click_left_at($Ref/Bubble4.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(pim.get_memo_output().get_value(), 3)


func test_undo_redo():
	simulator.click_left_at($Ref/CreateUnit.position)
	simulator.click_left_at($Ref/Unit1.position)
	simulator.click_left_at($Ref/Unit2.position)
	simulator.click_left_at($Ref/CreateBubble.position)
	simulator.click_left_at($Ref/Bubble1.position)
	simulator.click_left_at($Ref/Bubble2.position)
	simulator.click_left_at($Ref/Undo.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_unit_list().size(), 2)
	assert_eq(field.queries.get_bubble_list().size(), 1)

	simulator.click_left_at($Ref/Undo.position, 5)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_unit_list().size(), 0)
	assert_eq(field.queries.get_bubble_list().size(), 0)

	simulator.click_left_at($Ref/Redo.position, 5)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_unit_list().size(), 2)
	assert_eq(field.queries.get_bubble_list().size(), 2)


func test_reset_and_undo_reset():
	simulator.click_left_at($Ref/CreateUnit.position)
	simulator.click_left_at($Ref/Unit1.position)
	simulator.click_left_at($Ref/Unit2.position)
	simulator.click_left_at($Ref/CreateBubble.position)
	simulator.click_left_at($Ref/Bubble1.position)
	simulator.click_left_at($Ref/Bubble2.position)
	simulator.click_left_at($Ref/Reset.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_unit_list().size(), 0)
	assert_eq(field.queries.get_bubble_list().size(), 0)

	simulator.click_left_at($Ref/Undo.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_unit_list().size(), 2)
	assert_eq(field.queries.get_bubble_list().size(), 2)


func test_create_by_object_spawners():
	simulator.drag_left_by($Ref/PimMenuScrollBar.position, Vector2(0, 600))
	simulator.drag_left_between($Ref/AfterScrollCounter.position, $Ref/Unit1.position)
	simulator.drag_left_between($Ref/AfterScrollCounter.position, $Ref/MissPim.position)
	simulator.drag_left_between($Ref/AfterScrollBubble.position, $Ref/Bubble1.position)
	simulator.drag_left_between($Ref/AfterScrollBubble.position, $Ref/MissPim.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_unit_list().size(), 1)
	assert_eq(field.queries.get_bubble_list().size(), 1)

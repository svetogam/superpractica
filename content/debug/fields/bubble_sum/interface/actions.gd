##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldInterfaceComponent

#####################################################################
# Basic Actions
#####################################################################

func create_unit(point: Vector2) -> FieldObject:
	var unit = _field.create_object(BubbleSumGlobals.Objects.UNIT)
	unit.position = point
	return unit


func create_bubble(point: Vector2, radius:=-1) -> FieldObject:
	var bubble = _field.create_object(BubbleSumGlobals.Objects.BUBBLE)
	bubble.position = point
	if radius != -1:
		bubble.resize_to(radius)
	return bubble


func delete_unit(unit: FieldObject) -> void:
	unit.queue_free()


func pop_bubble(bubble: FieldObject) -> void:
	bubble.queue_free()


func delete_bubble(bubble: FieldObject) -> void:
	delete_objects_internal_to_bubble(bubble)
	bubble.queue_free()


func delete_objects_internal_to_bubble(bubble: FieldObject) -> void:
	var internal_objects = bubble.get_internal_objects()
	for object in internal_objects:
		object.queue_free()


func move_unit(unit: FieldObject, position: Vector2) -> void:
	if not _field.has_point(position):
		return

	unit.position = position


func move_unit_by(unit: FieldObject, vector: Vector2) -> void:
	move_unit(unit, unit.position + vector)


func move_bubble(bubble: FieldObject, position: Vector2) -> void:
	if not _field.has_point(position):
		return

	var delta_vector = position - bubble.position
	for object in bubble.get_internal_objects():
		object.position += delta_vector
	bubble.position = position


func move_bubble_by(bubble: FieldObject, vector: Vector2) -> void:
	move_bubble(bubble, bubble.position + vector)


func resize_bubble(bubble: FieldObject, radius: int) -> void:
	bubble.resize_to(radius)


func select_unit(unit: FieldObject) -> void:
	unit.toggle_select()


func select_bubble(bubble: FieldObject) -> void:
	toggle_bubble_selection(bubble, true)


func toggle_bubble_selection(bubble: FieldObject, give_contents_same_selection: bool) -> void:
	bubble.toggle_select()
	if give_contents_same_selection:
		deselect_units()
		select_units_internal_to_selected_bubbles()


func select_units_internal_to_selected_bubbles() -> void:
	var units_to_select = _field.queries.get_units_internal_to_bubbles(
								_field.queries.get_selected_bubble_list())
	for unit in units_to_select:
		unit.set_selected(true)


func deselect_units() -> void:
	for unit in _field.queries.get_unit_list():
		unit.set_selected(false)


func deselect_bubbles() -> void:
	for bubble in _field.queries.get_bubble_list():
		bubble.set_selected(false)


func count_unit(unit: FieldObject) -> NumberEffect:
	if not unit.selected:
		unit.set_selected(true)
		return _field.counter.count_next(unit.position, true)
	return null


func clear_count() -> void:
	deselect_units()
	_field.counter.reset_count()


#####################################################################
# Field-Setting
#####################################################################

func set_empty() -> void:
	for unit in _field.queries.get_unit_list():
		unit.queue_free()
	for bubble in _field.queries.get_bubble_list():
		bubble.queue_free()
	clear_count()

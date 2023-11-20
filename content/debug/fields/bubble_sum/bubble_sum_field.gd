##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Field


func get_globals() -> GDScript:
	return BubbleSumGlobals


func _on_update(update_type: int) -> void:
	if update_type == UpdateTypes.TOOL_MODE_CHANGED:
		actions.clear_count()
		actions.deselect_units()
		actions.deselect_bubbles()

	_set_depth_of_bubbles_by_size()


func _set_depth_of_bubbles_by_size() -> void:
	var bubble_list = queries.sort_bubble_list_by_size()
	for bubble in bubble_list:
		bubble.move_to_front()


func reset_state() -> void:
	push_action("set_empty")


func on_internal_drop(object: FieldObject, point: Vector2) -> void:
	if object.get_object_type() == BubbleSumGlobals.Objects.UNIT:
		push_action("move_unit", [object, point])


func on_incoming_drop(object: InterfieldObject, point: Vector2, _source: Field) -> void:
	if object.object_type == BubbleSumGlobals.Objects.UNIT:
		push_action("create_unit", [point])
	elif object.object_type == BubbleSumGlobals.Objects.BUBBLE:
		push_action("create_bubble", [point, object.input_shape.get_radius()])


func on_outgoing_drop(object: FieldObject) -> void:
	if object.get_object_type() == BubbleSumGlobals.Objects.UNIT:
		push_action("delete_unit", [object])

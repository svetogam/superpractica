# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldObjectMode

var action: GridCountingActionToggleMark


func _hovered(_external: bool, _grabbed_object: FieldObject) -> void:
	field.clear_prefig()
	if action == null:
		action = GridCountingActionToggleMark.new(field, object.number)
	if not Input.is_action_pressed("primary_mouse"):
		action.prefigure()


func _unhovered(_external: bool, _grabbed_object: FieldObject) -> void:
	if action == null:
		action = GridCountingActionToggleMark.new(field, object.number)
	var viewport = get_viewport()
	if not viewport.get_visible_rect().has_point(viewport.get_mouse_position()):
		action.unprefigure()


func _pressed(_point: Vector2) -> void:
	if action == null:
		action = GridCountingActionToggleMark.new(field, object.number)
	action.unprefigure()
	action.push()
	get_viewport().set_input_as_handled()

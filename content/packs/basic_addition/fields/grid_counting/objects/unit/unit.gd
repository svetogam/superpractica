# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldObject

var cell_number: int
var cell: GridCell:
	get:
		return field.dynamic_model.get_grid_cell(cell_number)
var drop_action: FieldAction


static func _get_object_type() -> String:
	return GridCounting.OBJECT_UNIT


func _update_active_modes(new_tool: String) -> void:
	if new_tool == GridCounting.TOOL_PIECE_DELETER:
		$StateChart.send_event("enable_delete")
	else:
		$StateChart.send_event("disable_delete")
	if new_tool == GridCounting.TOOL_PIECE_DRAGGER:
		$StateChart.send_event("enable_drag")
	else:
		$StateChart.send_event("disable_drag")


func _pressed(_point: Vector2) -> void:
	if $StateChart/States/ActiveModes/Delete/On.active:
		GridCountingActionDeleteUnit.new(field, cell.number).push()
		get_viewport().set_input_as_handled()

	if $StateChart/States/ActiveModes/Drag/On.active:
		grab(true)


func _dragged(_external: bool, point: Vector2, _change: Vector2) -> void:
	if $StateChart/States/ActiveModes/Drag/On.active:
		var dest_cell = field.get_grid_cell_at_point(point)
		if dest_cell != null:
			drop_action = GridCountingActionMoveUnit.new(
				field, cell.number, dest_cell.number
			)
			drop_action.prefigure()
		elif drop_action != null:
			drop_action.unprefigure()


func _dropped(_external: bool, _point: Vector2) -> void:
	if $StateChart/States/ActiveModes/Drag/On.active:
		assert(drop_action != null)
		drop_action.push()


func _dropped_out(_receiver: Field) -> void:
	if $StateChart/States/ActiveModes/Drag/On.active:
		GridCountingActionDeleteUnit.new(field, cell.number).push()


func put_on_cell(p_cell_number: int) -> void:
	cell_number = p_cell_number
	position = cell.position


func set_variant(variant: StringName) -> void:
	assert(%Sprite.sprite_frames.has_animation(variant))
	%Sprite.animation = variant
